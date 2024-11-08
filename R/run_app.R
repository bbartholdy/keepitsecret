#' Launch shiny app
#' @examples
#' # example code
#' 
#' ## Not run
#' 
#' runRing()
#' @export
runRing <- function(){
  shiny::runApp(system.file("shinyapp", package = "keepitsecret"))
}
