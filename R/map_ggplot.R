#' ggplot2 mapping
#'
#' @export
#' @param x Input, object of class \code{occdat}
#' @param map (character) One of world, world2, state, usa, county, france, italy, or nz
#' @param point_color Default color of your points
#' @param ... Ignored
#' @return A ggplot2 map, of class \code{gg/ggplot}
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' dat <- occ(query = 'Lynx rufus californicus', from = 'ecoengine', limit=100)
#' map_ggplot(dat)
#' map_ggplot(dat, "usa")
#' map_ggplot(dat, "county")
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_ggplot(res)
#'}
map_ggplot <- function(x, map = "world", point_color = "#86161f", ...) {
  UseMethod("map_ggplot")
}

#' @export
map_ggplot.occdat <- function(x, map = "world", point_color = "#86161f", ...) {
  latitude <- longitude <- lat <- long <- decimalLongitude <- decimalLatitude <- group <- NA
  dt <- occ2df(x)
  dt <- dt[complete.cases(dt$latitude, dt$longitude), ]
  wmap <- map_data(map)
  ggplot(dt, aes(longitude, latitude)) +
    geom_point(color = point_color, size = 3) +
    geom_polygon(aes(long, lat, group = group), fill = NA, colour = "black", data = wmap) +
    sutils_blank_theme()
}

#' @export
map_ggplot.gbif <- function(x, map = "world", point_color = "#86161f", ...) {
  latitude <- longitude <- lat <- long <- decimalLongitude <- decimalLatitude <- group <- NA
  dt <- x$data
  dt <- dt[complete.cases(dt$decimalLatitude, dt$decimalLongitude), ]
  wmap <- map_data(map)
  ggplot(dt, aes(decimalLongitude, decimalLatitude)) +
    geom_point(color = point_color, size = 3) +
    geom_polygon(aes(long, lat, group = group), fill = NA, colour = "black", data = wmap) +
    sutils_blank_theme()
}

#' @export
map_ggplot.default <- function(x, ...) {
  stop(sprintf("map_ggplot does not support input of class '%s'", class(x)), call. = FALSE)
}

sutils_blank_theme <- function(){
  theme(axis.line = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.background = element_blank(),
        plot.margin = rep(ggplot2::unit(0, "null"), 4))
}
