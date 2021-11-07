# run all analysis scripts ----

####################################
# cleans the data folder and       #
# creates all data for the report. #
####################################

fs::dir_create(here::here("data"))

## clean data folder ----
fs::dir_ls(
    path = here::here("data"),
    recurse = TRUE,
    type = "file"
  ) |>
  fs::file_delete()

## source all analysis scripts ----
source(here::here("R/gb_screening.R"))
source(here::here("R/gb_mock.R"))
source(here::here("R/pt_bbd.R"))

remove(list = ls())
