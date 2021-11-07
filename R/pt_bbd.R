# pulltest: box behnken

library(tidyverse)
library(rsm)
library(parsnip)

source(here::here("R/custom_functions.R"))

## create design ----

set.seed(9393)

coding_bbd <-
  list(
    ultrasound.coded ~ (ultrasound - 160)/50,
    time.coded ~ (time - 200)/50,
    force.coded ~ (force - 200)/50,
    gold.coded ~ (gold - 70)/30,
    chrome.coded ~ (chrome - 6)/4,
    temperature.coded ~ (temperature - 100)/50
  )

design_bbd <-
  bbd(
    k = ~ ultrasound.coded + time.coded + force.coded + gold.coded + chrome.coded + temperature.coded,
    n0 = 3,
    coding = coding_bbd,
    randomize = TRUE
  ) |>
  decode.data() |>
  mutate(
    measurement_1 = NA,
    measurement_2 = NA,
    measurement_3 = NA,
    measurement_4 = NA,
    measurement_5 = NA,
    measurement_6 = NA,
    measurement_7 = NA,
    measurement_8 = NA,
    measurement_9 = NA,
    measurement_10 = NA
  )

write_csv(
  x = design_bbd,
  file = here::here("data/doe/pt_bbd.csv")
)



## read data ----
data_bbd <-
  read_csv(
    here::here("data-raw/pulltest/box_behnken/pt-bbd.csv")
  ) |>
  pivot_longer(
    cols = measurement_1:measurement_10,
    names_to = "measurement",
    values_to = "rip_force"
  ) |>
  mutate(
    across(
      .cols = ultrasound:temperature,
      .fns = function(x) { scales::rescale(x, to = c(-1,1)) },
      .names = "{.col}.c"
    )
  )

data_bbd_mean <-
  data_bbd |>
  select(-measurement) |>
  group_by(run.order) |>
  mutate(
    rip_force_sd = sd(rip_force),
    rip_force_se = plotrix::std.error(rip_force),
    rip_force = mean(rip_force)
  ) |>
  unique() |>
  ungroup()

## regression ----

model_specs <-
  linear_reg() |>
  set_engine("lm")

model_bbd <-
  model_specs |>
  fit(
    formula = rip_force ~ run.order +
      ultrasound + time + force + temperature + chrome + gold +
      ultrasound:time + ultrasound:force + ultrasound:temperature + ultrasound:chrome + ultrasound:gold +
      time:force + time:temperature + time:chrome + time:gold +
      force:temperature + force:chrome + force:gold +
      temperature:chrome + temperature:gold + chrome:gold +
      I(ultrasound^2) + I(time^2) + I(force^2) + I(temperature^2) + I(chrome^2) + I(gold^2),
    data = data_bbd_mean
  )


## plots ----

plot_bbd_runorder <-
  data_bbd |>
  mutate(index = row_number()) |>
  pivot_longer(ultrasound:temperature) |>
  mutate(
    bondtool = as_factor(bondtool) |>
      fct_inseq()
  ) |>
  group_by(bondtool) |>
  mutate(
    bondtool_mean = mean(rip_force)
  ) |>
  ggplot(aes(x = index)) +
  geom_line(
    mapping = aes(
      y = bondtool_mean,
      colour = bondtool
    ),
    size = 1
  ) +
  geom_point(
    mapping = aes(y = rip_force),
    alpha = 0.5,
    size = 1
  ) +
  labs(
    x = "Versuchsreihenfolge",
    y = "max. Kraft in ...",
    labs = "Bondtool"
  )

plot_bbd_effect <-
  data_bbd_mean |>
  create_effect_plot(
    factors = ultrasound:temperature,
    response = rip_force
  ) +
  scale_x_continuous(n.breaks = 3) +
  labs(
    x = "Level",
    y = "max. Kraft in ...",
    colour = "Bondtool"
  )


## output ----
fs::dir_create(
  path = c(
    here::here("data/doe"),
    here::here("data/pulltest")
  ),
  recurse = TRUE
)

save(
  data_bbd,
  data_bbd_mean,
  file = here::here("data/pulltest/pt_bbd.rda")
)

save(
  model_bbd,
  file = here::here("data/pulltest/pt_bbd_regression.rda")
)

save(
  plot_bbd_effect,
  plot_bbd_runorder,
  file = here::here("data/pulltest/pt_bbd_plots.rda")
)
