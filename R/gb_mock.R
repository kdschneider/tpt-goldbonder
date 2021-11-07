library(tidyverse)
library(lubridate)

source(here::here("R/custom_functions.R"))

## read data ----
### cr/au ----
files <- list.files(
  here::here("data-raw/gatebreak/mock/cr_au")
)

data_crau <-
  tibble(
    filename = files,
    type = rep(c("blind", "sample"), each = 3, times = 4),
    chip = rep(1:4, each = 6),
    rep = rep(1:3, times = 8)
  ) |>
  mutate(
    measurement = map(
      filename,
      ~read_csv(
        here::here("data-raw/gatebreak/mock/cr_au", .),
        skip = 8
      ) |>
        select(
          amps = "Reading",
          volts = "Value",
          date = "Date",
          time = "Time"
        ) |>
        mutate(
          date = dmy(date) + hms(time),
          volts = round(volts, digits = 1)
        ) |>
        select(-time)
    )
  ) |>
  select(-filename) |>
  unnest(measurement) |>
  group_by(chip, rep) |>
  nest(measurement = c("amps", "volts")) |>
  ungroup()


data_mock <-
  data_crau

## plots ----

plot_crau_kennlinie <-
  data_crau |>
  mutate(index = row_number()) |>
  mutate(
    chip = str_glue("Chip: {chip}") |>
      as_factor()
  ) |>
  filter(type == "sample") |>
  unnest(measurement) |>
  ggplot(
    aes(
      x = volts,
      y = amps * 10^6,
    )
  ) +
  geom_line(
    aes(
      colour = as.factor(rep),
      group = index
    )
  ) +
  scale_colour_brewer(palette = "Set1") +
  labs(
    colour = "Rep.",
    x = "Spannung in Volt",
    y = "Stromstärke in µA"
  ) +
  facet_wrap(
    facets = vars(chip)
  )

plot_crau_blind <-
  data_crau |>
  ungroup() |>
  filter(type == "blind") |>
  unnest(measurement) |>
  group_by(volts) |>
  summarise(amps = mean(amps)) |>
  ggplot(
    aes(
      x = volts,
      y = amps * 10^6
    )
  ) +
  geom_line() +
  labs(
    colour = "Rep.",
    x = "Spannung in Volt",
    y = "Stromstärke in µA"
  )


## output ----
### data
write_rds(
  x = data_mock,
  file = here::here("data/gatebreak/gb_mock.rds")
)

### plots
save(
  plot_crau_kennlinie,
  plot_crau_blind,
  file = here::here("data/gatebreak/gb_mock_plots.rda")
)
