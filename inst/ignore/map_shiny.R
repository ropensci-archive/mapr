#' Shiny visualization of species occurrences
#'
#' @export
#'
#' @template args
#' @param color Default color of your points.
#' @param size point size, Default: 13
#' @param ... Ignored
#' @return Opens a shiny app in your default browser
#' @examples \dontrun{
#' library("spocc")
#' (x <- occ(query='Accipiter striatus', from='gbif', limit=50,
#'   has_coords=TRUE))
#' readr::write_csv(spocc::occ2df(x), path = "inst/shinysingle/dat.csv")
#' map_shiny(x)
#'
map_shiny(
  query = 'Accipiter striatus', from = 'gbif', limit = 50, has_coords = TRUE
)
#' }
# map_shiny <- function(x, lon = 'longitude', lat = 'latitude', color = NULL,
#                         size = 13, ...) {
  #x <- dat_cleaner(spocc::occ2df(x), lon, lat)
map_shiny <- function(...) {
  (dots <- lazyeval::lazy_dots(...))
  # message("Hit <escape> to stop")
  # shiny::runApp(system.file("shinysingle/app.R", package = "mapr"))
}
