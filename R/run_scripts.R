# run all analysis scripts ----

####################################
# cleans the data folder and       #
# creates all data for the report. #
####################################

fs::dir_create(here::here("data"))
fs::dir_create(here::here("_temp"))

## clean data folder ----
fs::dir_ls(
    path = here::here("data"),
    recurse = TRUE,
    type = "file"
  ) |>
  fs::file_delete()

## purl scripts
### get file paths
files_path <- fs::dir_ls(
  path = here::here("Rmd"),
  glob = "*.Rmd"
)

### get file names
files_name <-
  list.files(
    path = here::here("Rmd"),
  ) |>
  fs::path_filter(glob = "*.Rmd") |>
  fs::path_ext_remove()


purrr::walk2(
  .x = files_path,
  .y = files_name,
  .f = ~knitr::purl(
    input = .x,
    output = here::here("_temp", glue::glue("{.y}.R")),
    documentation = 0
  )
)


## source all analysis scripts ----
scripts <- fs::dir_ls(
  path = here::here("_temp"),
  glob = "*.R"
)

purrr::walk(
  scripts,
  source
)

## clean
fs::dir_delete(here::here("_temp"))
