#' ggpmap visualization of species occurences
#'
#' @export
#' @template args
#' @param zoom zoom level for map. Adjust depending on how your data look.
#' @param color Default color of your points.
#' @param size point size, Default: 3
#' @param maptype (character) map theme. see `get_map` in `ggmap`
#' for options. Default: none
#' @param source (character) Google Maps ("google"), OpenStreetMap ("osm"),
#' Stamen Maps ("stamen"), or CloudMade maps ("cloudmade"). Default: `osm`
#' @param point_color Default color of your points. Deprecated, use `color`
#' @param ... Ignored
#' @details Does not support adding a convex hull via [hull()]
#'
#' @note **BEWARE**: this may error for you with a message like
#' _GeomRasterAnn was built with an incompatible version of ggproto_. This
#' is fixed in the dev version of `ggmap`, but not in the CRAN version.
#' Apologies for the problem.
#'
#' @examples \dontrun{
#' # BEWARE: this may error for you with a message like
#' # "GeomRasterAnn was built with an incompatible version of ggproto".
#' # This is fixed in the dev version of `ggmap`, but not in the CRAN
#' # version. Apologies for the problem.
#'
#' ## spocc
#' library("spocc")
#' gd <- occ(query = 'Accipiter striatus', from = 'gbif', limit=75,
#'   has_coords = TRUE)
#' map_ggmap(gd)
#' map_ggmap(gd$gbif)
#'
#' ## rgbif
#' library("rgbif")
#' ### occ_search() output
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_ggmap(res)
#' 
#' ### occ_data() output
#' res <- occ_data(scientificName = "Puma concolor", limit = 100)
#' map_ggmap(res)
#' 
#' #### many taxa
#' res <- occ_data(scientificName = c("Puma concolor", "Quercus lobata"), 
#'    limit = 30)
#' map_ggmap(res)
#'
#' 
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor', 'Foo bar'),
#'                  longitude = c(-120, -121, -123),
#'                  latitude = c(41, 42, 45), stringsAsFactors = FALSE)
#' map_ggmap(df)
#'
#' ### usage of occ2sp()
#' #### SpatialPointsDataFrame
#' spdat <- occ2sp(gd)
#' map_ggmap(spdat)
#'
#' # many species, each gets a different color
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE,
#'   gbifopts = list(country = 'US'))
#' map_ggmap(dat)
#' map_ggmap(dat, zoom = 5)
#' map_ggmap(dat, color = '#6B944D')
#' map_ggmap(dat, color = c('#976AAE', '#6B944D', '#BD5945'))
#' }
map_ggmap <- function(x, zoom = 3, point_color = "#86161f", color = NULL,
                      size = 3, lon = 'longitude', lat = 'latitude',
                      maptype = "terrain", source = "google", ...) {
  UseMethod("map_ggmap")
}

#' @export
map_ggmap.occdat <- function(x, zoom = 3, point_color = "#86161f", color = NULL,
                             size = 3, lon = 'longitude', lat = 'latitude',
                             maptype = "terrain", source = "google", ...) {
  check_inputs(match.call())
  x <- spocc::occ2df(x)
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.occdatind <- function(x, zoom = 3, point_color = "#86161f",
                                color = NULL, size = 3, lon = 'longitude',
                                lat = 'latitude', maptype = "terrain",
                                source = "google", ...) {
  check_inputs(match.call())
  x <- spocc::occ2df(x)
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.gbif <- function(x, zoom = 3, point_color = "#86161f", color = NULL,
                           size = 3, lon = 'longitude', lat = 'latitude',
                           maptype = "terrain", source = "google", ...) {
  check_inputs(match.call())
  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  x <- guess_latlon(x, lon = 'decimalLongitude', lat = 'decimalLatitude')
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.gbif_data <- function(x, zoom = 3, point_color = "#86161f", color = NULL,
                           size = 3, lon = 'longitude', lat = 'latitude',
                           maptype = "terrain", source = "google", ...) {
  check_inputs(match.call())
  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  x <- guess_latlon(x, lon = 'decimalLongitude', lat = 'decimalLatitude')
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.data.frame <- function(x, zoom = 3, point_color = "#86161f",
                                 color = NULL, size = 3, lon = 'longitude',
                                 lat = 'latitude', maptype = "terrain",
                                 source = "google", ...) {
  check_inputs(match.call())
  x <- guess_latlon(x, lat, lon)
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.SpatialPoints <- function(x, zoom = 3, point_color = "#86161f",
                                    color = NULL, size = 3, lon = 'longitude',
                                    lat = 'latitude', maptype = "terrain",
                                    source = "google", ...) {
  check_inputs(match.call())
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.SpatialPointsDataFrame <- function(x, zoom = 3,
        point_color = "#86161f",
        color = NULL, size = 3, lon = 'longitude', lat = 'latitude',
        maptype = "terrain", source = "google", ...) {
  check_inputs(match.call())
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  map_ggmapper(x, zoom, color, size, maptype, source)
}

#' @export
map_ggmap.default <- function(x, zoom = 3, point_color = "#86161f",
  color = NULL, size = 3, lon = 'longitude', lat = 'latitude',
  maptype = "terrain", source = "google", ...) {

  stop(
    sprintf("map_ggmap does not support input of class '%s'", class(x)),
    call. = FALSE
  )
}

## helpers ---------------------
map_center <- function(x) {
  min_lat <- min(x$latitude, na.rm = TRUE)
  max_lat <- max(x$latitude, na.rm = TRUE)
  min_long <- min(x$longitude, na.rm = TRUE)
  max_long <- max(x$longitude, na.rm = TRUE)
  center_lat <- min_lat + (max_lat - min_lat)/2
  center_long <- min_long + (max_long - min_long)/2
  c(lon = center_long, lat = center_lat)
}

map_bbox <- function(x) {
  min_lat <- min(x$latitude, na.rm = TRUE)
  max_lat <- max(x$latitude, na.rm = TRUE)
  min_long <- min(x$longitude, na.rm = TRUE)
  max_long <- max(x$longitude, na.rm = TRUE)
  c(left = min_long, bottom = min_lat, right = max_long, top = max_lat)
}

map_ggmapper <- function(x, zoom, color, size, maptype, source) {
  check4pkg("ggmap")
  x <- x[stats::complete.cases(x$latitude, x$longitude), ]
  x <- x[!x$latitude == 0 & !x$longitude == 0, ]
  species_map <- ggmap::get_map(location = map_center(x), zoom = zoom,
                                maptype = maptype, source = source)
  latitude <- longitude <- name <- NA
  ggmap::ggmap(species_map) +
    geom_point(data = x[, c("latitude", "longitude", "name")],
               aes(x = longitude, y = latitude, colour = name), size = size) +
    pick_colors(x, color) +
    ggtitle(paste0("Distribution of ", unique(x$name))) +
    labs(x = "Longitude", y = "Latitude")
}
