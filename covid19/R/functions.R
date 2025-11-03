#' Launch COVID-19 Shiny App
#'
#' Opens the interactive Shiny app included in the package.
#'
#' @export
launch_covid19_app <- function() {
  app_dir <- system.file("shinyapp", package = "covid19")
  if (app_dir == "") stop("Could not find Shiny app directory. Try re-installing `covid19`.", call. = FALSE)
  shiny::runApp(app_dir, display.mode = "normal")
}
