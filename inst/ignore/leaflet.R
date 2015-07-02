#' Make an interactive map with Leaflet
#'
#' @export
#' @import leaflet
#'
#' @param data A data.frame, with any number of columns, but with at least the
#'    following: name (the taxonomic name), latitude (in dec. deg.), longitude
#'    (in dec. deg.)
#' @param ... Further arguments passed on to \code{\link[leaflet]{xxx}}
#' @examples \dontrun{
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = c('gbif', 'ecoengine'), limit=30, has_coords = TRUE)
#' dat <- fixnames(dat, "query")
#' map_leaflet(dat)
#' }
map_leaflet <- function(x, ...) {
  stopifnot(is(x, "occdatind") | is(x, "occdat"))
  x <- if (is(x, "occdatind")) {
    do.call(rbind, x$data)
  } else {
    occ2df(x)
  }
  # spplist <- as.character(unique(x$name))
  # datgeojson <- spocc_stylegeojson(input = x, var = "name", ...)
  leaflet::leaflet(x) %>%
    leaflet::addTiles() %>%
    leaflet::addMarkers(~longitude, ~latitude)
}
