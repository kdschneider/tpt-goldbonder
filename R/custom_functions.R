# custom functions

# check if package is loaded
check_loaded <- function(package) {
  package %in% .packages()
}

# rescale factors
rescale_factors <- function(data, factors) {
  data |>
    mutate(
      across(
        .cols = {{ factors }},
        .fns = function(x) { scales::rescale(x, to = c(-1,1)) }
      )
    )
}

create_effect_plot <- function(data, factors, response, rename) {

  dat <-
    data |>
    rescale_factors({{ factors }}) |>
    pivot_longer(cols = {{ factors }}) |>
    mutate(
      name = as_factor(name) |>
        fct_recode(dots_list({{ rename }}))
    ) |>
    group_by(name, value) |>
    summarise({{ response }} := mean({{ response }})) |>
    drop_na()

  plot <-
    dat |>
    ggplot(
      aes(
        x = value,
        y = {{ response }}
      )
    ) +
    geom_line() +
    geom_point() +
    facet_wrap(vars(name), ncol = 3)

  return(plot)
}

### plotly/ggplot for html/pdf
show_plot <- function(plot, ...) {
  if (knitr::is_html_output() == TRUE) {
    return(plotly::ggplotly(plot, ...))
  } else {
    return(plot)
  }
}
