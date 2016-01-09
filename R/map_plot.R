#' Base R mapping
#'
#' @export
#' @param x Input, an object of class \code{occdat}
#' @param ... Further args to \code{\link{points}}
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=100, has_coords=TRUE))
#' map_plot(out)
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_plot(res)
#' }
map_plot <- function(x, ...) {
  UseMethod("map_plot")
}

#' @export
map_plot.occdat <- function(x, ...) {
  df <- spocc::occ2df(x)
  df <- df[complete.cases(df$latitude, df$longitude), ]
  df <- df[df$longitude != 0, ]
  sp::coordinates(df) <- ~longitude + latitude
  plot_er(df, ...)
}

#' @export
map_plot.gbif <- function(x, ...) {
  df <- x$data
  df <- df[complete.cases(df$decimalLatitude, df$decimalLongitude), ]
  df <- df[df$decimalLongitude != 0, ]
  sp::coordinates(df) <- ~decimalLongitude + decimalLatitude
  plot_er(df, ...)
}

#' @export
map_plot.default <- function(x, ...) {
  stop(sprintf("map_plot does not support input of class '%s'", class(x)), call. = FALSE)
}

plot_er <- function(x, ...) {
  sp::proj4string(x) <- sp::CRS("+init=epsg:4326")
  sp::plot(rworldmap::getMap())
  graphics::points(x, col = "red", ...)
}
