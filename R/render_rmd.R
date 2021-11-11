# render rmds
## render

custom_format <-
  prettydoc::html_pretty(
    theme = "cayman",
    highlight = "github",
    math = "katex"
  )

custom_render <- function(input, out_dir) {
  rmarkdown::render(
    input = input,
    output_dir = out_dir,
    output_format = custom_format
  )
}

## analysis scripts
## get file paths
files_path <- fs::dir_ls(
  path = here::here("Rmd"),
  glob = "*.Rmd"
)

purrr::walk(
  .x = files_path,
  .f = custom_render,
  out_dir = here::here("_book/downloads")
)
