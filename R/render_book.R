# render report

# clean _book folder
if (fs::dir_exists(here::here("_book")) == TRUE) {
  fs::dir_delete(here::here("_book"))
}

## render bs4_book
bookdown::render_book(
  input = here::here(""),
  output_format = "bookdown::bs4_book",
  output_dir = here::here("_book"),
  params = list(
    "online" = TRUE,
    "show_code" = FALSE
  )
)

## render pdf
bookdown::render_book(
  input = here::here(""),
  output_format = "bookdown::pdf_document2",
  output_dir = here::here("_book/downloads"),
  params = list(
    "online" = FALSE,
    "show_code" = FALSE
  )
)

## create downloads

utils::zip(
  zipfile = here::here("_book/downloads/data.zip"),
  files = here::here("data")
)
