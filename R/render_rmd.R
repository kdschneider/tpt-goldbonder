# render rmds

fs::dir_create(here::here("_book/downloads/analysis/"))


## get file paths
files_path <- fs::dir_ls(
  path = here::here("Rmd"),
  glob = "*.Rmd"
)

## render

custom_render <- function(input) {
  rmarkdown::render(
    input = input,
    output_dir = here::here("_book/downloads/analysis/")
  )
}

purrr::walk(
  .x = files_path,
  .f = custom_render
)
