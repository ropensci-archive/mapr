#' Base R mapping
#'
#' @export
#' @template args
#' @param color Default color of your points.
#' @param size point size, Default: 1
#' @param ... Further args to \code{\link{points}}
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=25, has_coords=TRUE))
#' ### class occdat
#' map_plot(out)
#' ### class occdatind
#' map_plot(out$gbif)
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_plot(res)
#'
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor', 'Foo bar'),
#'                  longitude = c(-120, -121, -121),
#'                  latitude = c(41, 42, 45), stringsAsFactors = FALSE)
#' map_plot(df)
#'
#' ### usage of occ2sp()
#' #### SpatialPoints
#' spdat <- occ2sp(out)
#' map_plot(spdat)
#' #### SpatialPointsDataFrame
#' spdatdf <- as(spdat, "SpatialPointsDataFrame")
#' map_plot(spdatdf)
#'
#' # many species, each gets a different color
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE)
#' map_plot(dat)
#' ## diff. color for each taxon
#' map_plot(dat, color = c('#976AAE', '#6B944D', '#BD5945'))
#' }
map_plot <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  UseMethod("map_plot")
}

#' @export
map_plot.occdat <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  df <- spocc::occ2df(x)
  plot_er(plot_prep(df), color, size, ...)
}

#' @export
map_plot.occdatind <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  df <- spocc::occ2df(x)
  plot_er(plot_prep(df), color, size, ...)
}

#' @export
map_plot.gbif <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  df <- x$data
  df <- df[complete.cases(df$decimalLatitude, df$decimalLongitude), ]
  df <- df[df$decimalLongitude != 0, ]
  sp::coordinates(df) <- ~decimalLongitude + decimalLatitude
  plot_er(df, color, size, ...)
}

#' @export
map_plot.data.frame <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  x <- guess_latlon(x, lat, lon)
  plot_er(plot_prep(x), color, size, ...)
}

#' @export
map_plot.SpatialPoints <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  plot_er(plot_prep(x), color, size, ...)
}

#' @export
map_plot.SpatialPointsDataFrame <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  plot_er(plot_prep(x), color, size, ...)
}

#' @export
map_plot.default <- function(x, lon = 'longitude', lat = 'latitude', color = NULL, size = 1, ...) {
  stop(sprintf("map_plot does not support input of class '%s'", class(x)), call. = FALSE)
}


##### helpers --------------------
plot_prep <- function(x) {
  x <- x[complete.cases(x$latitude, x$longitude), ]
  x <- x[x$longitude != 0, ]
  sp::coordinates(x) <- ~longitude + latitude
  x
}

plot_er <- function(x, color, size, ...) {
  x <- check_colors(x, color)
  sp::proj4string(x) <- sp::CRS("+init=epsg:4326")
  sp::plot(rworldmap::getMap())
  graphics::points(x, pch = 16, col = x$color, cex = size, ...)
  #graphics::points(x, pch = 16, col = x$color, cex = x$size, ...)
}
