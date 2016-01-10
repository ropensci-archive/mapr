#' Make an interactive map with Leaflet.js
#'
#' @export
#'
#' @param x Input
#' @param lon Longitude variable name
#' @param lat Latitude variable name
#' @param ... Further args to \code{\link{points}}
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=50, has_coords=TRUE))
#' ### with class occdat
#' map_leaflet(out)
#' ### with class occdatind
#' map_leaflet(out$gbif)
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_leaflet(res)
#'
#' ## data.frame
#' df <- data.frame(longitude = c(-120,-121), latitude = c(41, 42), stringsAsFactors = FALSE)
#' map_leaflet(df)
#' }
map_leaflet <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  UseMethod("map_leaflet")
}

#' @export
map_leaflet.occdat <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  map_leafer(spocc::occ2df(x), lon, lat)
}

#' @export
map_leaflet.occdatind <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  map_leafer(spocc::occ2df(x), lon, lat)
}

#' @export
map_leaflet.gbif <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  map_leafer(x$data, lon = 'decimalLongitude', lat = 'decimalLatitude')
}

#' @export
map_leaflet.data.frame <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  map_leafer(x, lon, lat)
}

#' @export
map_leaflet.default <- function(x, lon = 'longitude', lat = 'latitude', ...) {
  stop(sprintf("map_leaflet does not support input of class '%s'", class(x)), call. = FALSE)
}

# helpers
map_leafer <- function(x, lon = 'longitude', lat = 'latitude') {
  x <- guess_latlon(x, lat, lon)
  x <- x[complete.cases(x$latitude, x$longitude), ]
  lf <- leaflet::leaflet(data = x)
  lf <- leaflet::addTiles(lf)
  leaflet::addMarkers(lf, ~longitude, ~latitude)
}
