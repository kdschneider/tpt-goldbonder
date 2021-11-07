# purl scripts

## get file paths
files_path <- fs::dir_ls(
  path = here::here("Rmd"),
  glob = "*.Rmd"
)

## get file names
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
    output = here::here("R", glue::glue("{.y}.R"))
  )
)
