#' Launch shiny app
#' @examples
#' \dontrun{
#' # example code
#' runRing()
#' }
#' @export
runRing <- function(){
  shiny::runApp(system.file("shinyapp", package = "keepitsecret"))
}
