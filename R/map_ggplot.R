#' ggplot2 mapping
#'
#' @export
#' @template args
#' @param map (character) One of world, world2, state, usa, county, france,
#' italy, or nz
#' @param color Default color of your points.
#' @param size point size, Default: 3
#' @param point_color Default color of your points. Deprecated, use
#' `color`
#' @param name (character) the column name that contains the name to use in 
#' creating the map. If left `NULL` we look for a "name" column. 
#' default: `NULL`
#' @param ... Ignored
#' @return A ggplot2 map, of class `gg/ggplot`
#'
#' @examples
#' # map spocc output, here using a built in object
#' data(occdat_eg1)
#' map_ggplot(occdat_eg1)
#'
#' # map rgbif output, here using a built in object
#' data(gbif_eg1)
#' map_ggplot(gbif_eg1)
#'
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' ddat <- occ(query = 'Lynx rufus californicus', from = 'gbif', limit=100)
#' map_ggplot(ddat)
#' map_ggplot(ddat$gbif)
#' map_ggplot(ddat$gbif, "usa")
#' map_ggplot(ddat, "county")
#'
#' ### usage of occ2sp()
#' #### SpatialPoints
#' spdat <- occ2sp(ddat)
#' map_ggplot(spdat)
#' #### SpatialPointsDataFrame
#' spdatdf <- as(spdat, "SpatialPointsDataFrame")
#' map_ggplot(spdatdf)
#'
#' ## rgbif
#' if (requireNamespace("rgbif")) {
#' library("rgbif")
#' library("ggplot2")
#' ### occ_search() output
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_ggplot(res)
#' 
#' ### occ_data() output
#' res <- occ_data(scientificName = "Puma concolor", limit = 100)
#' map_ggplot(res)
#' 
#' #### many taxa
#' res <- occ_data(scientificName = c("Puma concolor", "Quercus lobata"), 
#'    limit = 30)
#' map_ggplot(res)
#' 
#' ### add a convex hull
#' hull(map_ggplot(res))
#' }
#'
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor', 'Foo bar'),
#'                  longitude = c(-120, -121, -121),
#'                  latitude = c(41, 42, 45), stringsAsFactors = FALSE)
#' map_ggplot(df)
#'
#' # many species, each gets a different color
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE)
#' map_ggplot(dat, color = c('#976AAE', '#6B944D', '#BD5945'))
#'}

map_ggplot <- function(x, map = "world", point_color = "#86161f", color = NULL,
  size = 3, lon = "longitude", lat = "latitude",  name = NULL, ...) {
  UseMethod("map_ggplot")
}

#' @export
map_ggplot.occdat <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", 
  name = NULL, ...) {

  check_inputs(match.call())
  x <- spocc::occ2df(x)
  make_amap(dat_cleaner(x, lon = lon, lat = lat, name = name), map,
            color, size)
}

#' @export
map_ggplot.occdatind <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", 
  name = NULL, ...) {

  check_inputs(match.call())
  x <- spocc::occ2df(x)
  make_amap(dat_cleaner(x, lon = lon, lat = lat, name = name), map,
            color, size)
}

#' @export
map_ggplot.gbif <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", 
  name = NULL, ...) {

  check_inputs(match.call())
  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  make_amap(dat_cleaner(x, lon = "decimalLongitude", 
    lat = "decimalLatitude", name = name), map, color, size)
}

#' @export
map_ggplot.gbif_data <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", 
  name = NULL, ...) {

  check_inputs(match.call())
  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  make_amap(dat_cleaner(x, lon = "decimalLongitude", 
    lat = "decimalLatitude", name = name), map, color, size)
}

#' @export
map_ggplot.SpatialPoints <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", 
  name = NULL, ...) {

  check_inputs(match.call())
  make_amap(data.frame(x), map, color, size)
}

#' @export
map_ggplot.SpatialPointsDataFrame <- function(x, map = "world", 
  point_color = "#86161f", color = NULL, size = 3, lon = "longitude",
  lat = "latitude", name = NULL, ...) {

  check_inputs(match.call())
  make_amap(data.frame(x), map, color, size)
}

#' @export
map_ggplot.data.frame <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", name = NULL, ...) {

  check_inputs(match.call())
  make_amap(dat_cleaner(x, lon = lon, lat = lat, name = name), map,
            color, size)
}

#' @export
map_ggplot.default <- function(x, map = "world", point_color = "#86161f",
  color = NULL, size = 3, lon = "longitude", lat = "latitude", name = NULL, ...) {
  
  stop(
    sprintf("map_ggplot does not support input of class '%s'", class(x)),
    call. = FALSE
  )
}

### helpers ------------------------------------------
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

make_amap <- function(x, map, color, size) {
  wmap <- suppressMessages(ggplot2::map_data(map))
  latitude <- longitude <- lat <- long <- decimalLongitude <-
    decimalLatitude <- group <- name <- NA
  ggplot(x, aes(longitude, latitude, colour = name)) +
    geom_point(size = size) +
    pick_colors(x, color) +
    geom_polygon(
      aes(long, lat, group = group), fill = NA, colour = "black", data = wmap) +
    sutils_blank_theme()
}
