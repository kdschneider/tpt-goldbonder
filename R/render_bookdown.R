# render report

rendermyreport <- function() {

  # clean _book folder
  if (fs::dir_exists(here::here("_book")) == TRUE) {
    fs::dir_delete(here::here("_book"))
  }
  
  ## render bs4_book ----
  bookdown::render_book(
    input = here::here(""),
    output_format = "bookdown::bs4_book",
    output_dir = here::here("_book"),
    params = list(
      "online" = TRUE,
      "show_code" = FALSE
    )
  )
  
  ## render single page html ----
  bookdown::render_book(
    input = here::here(""),
    output_format = "bookdown::html_document2",
    output_dir = here::here("_book/downloads"),
    params = list(
      "online" = FALSE,
      "show_code" = FALSE
    )
  )
  
  if (fs::dir_exists(here::here("_book/downloads")) == FALSE) {
    fs::dir_create(here::here("_book/downloads"))
  }
  
  if (fs::file_exists(here::here("tpt_goldbonder_bericht.html")) == TRUE) {
    fs::file_move(
      path = here::here("tpt_goldbonder_bericht.html"),
      new_path = here::here("_book/downloads/tpt_goldbonder_bericht.html")
    )
  }
  
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
  
  zip::zip(
    zipfile = "_book/downloads/data.zip",
    files = "data",
    root = here::here()
  )
}
