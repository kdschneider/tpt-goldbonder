# render book

## render bs4_book
bookdown::render_book(
  input = here::here(""),
  output_format = "bookdown::bs4_book",
  output_dir = here::here("_book"),
  params = c(
    "online" = TRUE
  )
)

## render pdf
bookdown::render_book(
  input = here::here(""),
  output_format = "bookdown::pdf_document2",
  output_dir = here::here("_book/downloads")
)
