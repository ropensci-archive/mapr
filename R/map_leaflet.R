#' Make an interactive map with Leaflet.js
#'
#' @export
#'
#' @template args
#' @param color Default color of your points.
#' @param size point size, Default: 13
#' @param ... Ignored
#' @details We add popups by default, and add all columns to the popup. The html is
#' escaped with \code{\link[htmltools]{htmlEscape}}
#' @return a Leaflet map in Viewer in Rstudio, or in your default browser otherwise
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=50, has_coords=TRUE))
#' ### with class occdat
#' map_leaflet(out)
#' ### with class occdatind
#' map_leaflet(out$gbif)
#' ### use occ2sp
#' map_leaflet(occ2sp(out))
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_leaflet(res)
#'
#' ## SpatialPoints class
#' library("sp")
#' df <- data.frame(longitude = c(-120,-121),
#'                  latitude = c(41, 42), stringsAsFactors = FALSE)
#' x <- SpatialPoints(df)
#' map_leaflet(x)
#'
#' ## SpatialPointsDataFrame class
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' x <- res$data
#' library("sp")
#' x <- x[complete.cases(x$decimalLatitude, x$decimalLongitude), ]
#' coordinates(x) <- ~decimalLongitude+decimalLatitude
#' map_leaflet(x)
#'
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor'),
#'                  longitude = c(-120,-121),
#'                  latitude = c(41, 42), stringsAsFactors = FALSE)
#' map_leaflet(df)
#'
#' # many species
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE)
#' map_leaflet(dat)
#' map_leaflet(dat, color = c('#AFFF71', '#AFFF71', '#AFFF71'))
#' map_leaflet(dat, color = c('#976AAE', '#6B944D', '#BD5945'))
#' }
map_leaflet <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  UseMethod("map_leaflet")
}

#' @export
map_leaflet.occdat <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map_ll(dat_cleaner(spocc::occ2df(x), lon, lat), color, size)
}

#' @export
map_leaflet.occdatind <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map_ll(dat_cleaner(spocc::occ2df(x), lon, lat))
}

#' @export
map_leaflet.SpatialPoints <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map(x)
}

#' @export
map_leaflet.SpatialPointsDataFrame <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map(x)
}

#' @export
map_leaflet.gbif <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map_ll(dat_cleaner(x$data, lon = 'decimalLongitude', lat = 'decimalLatitude'))
}

#' @export
map_leaflet.data.frame <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  make_map_ll(dat_cleaner(x, lon, lat))
}

#' @export
map_leaflet.default <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 13, ...) {
  stop(sprintf("map_leaflet does not support input of class '%s'", class(x)), call. = FALSE)
}

# helpers ------------------------------------
dat_cleaner <- function(x, lon = 'longitude', lat = 'latitude') {
  x <- guess_latlon(x, lat, lon)
  x[complete.cases(x$latitude, x$longitude), ]
}

make_map <- function(x, color, size) {
  lf <- leaflet::leaflet(data = x)
  lf <- leaflet::addTiles(lf)
  leaflet::addMarkers(lf)
}

make_map_ll <- function(x, color, size) {
  x <- check_colors(x, color)
  x$popups <- make_popups(x)
  lf <- leaflet::leaflet(data = x)
  lf <- leaflet::addTiles(lf)
  leaflet::addCircleMarkers(
    lf, ~longitude, ~latitude,
    color = ~color, radius = size,
    popup = ~popups
  )
}

make_popups <- function(x) {
  res <- c()
  for (i in seq_len(NROW(x))) {
    temp <- c()
    for (j in seq_along(x[i, ])) {
      temp[j] <- sprintf('<tr><td><strong>%s</strong></td><td>%s</td></tr>', names(x)[j], x[i,j])
    }
    res[i] <- htmlEscape(sprintf('<table>\n%s\n</table>', paste0(temp, collapse = "\n")))
    temp <- NULL
  }
  res
}
