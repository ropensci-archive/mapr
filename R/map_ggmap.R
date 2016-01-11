#' ggpmap visualization of species occurences
#'
#' @export
#' @template args
#' @param zoom zoom level for map. Adjust depending on how your data look.
#' @param point_color Default color of your points
#' @param ... Ignored
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' ed <- occ(query = 'Lynx rufus californicus', from = 'ecoengine', limit=100)
#' map_ggmap(ed)
#' gd <- occ(query = 'Accipiter striatus', from = 'gbif', limit=100)
#' map_ggmap(gd)
#' bd <- occ(query = 'Accipiter striatus', from = 'bison', limit=100)
#' map_ggmap(bd)
#'
#' ## gbif
#' 'xxxx'
#'
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor', 'Foo bar'),
#'                  longitude = c(-120, -121, -121),
#'                  latitude = c(41, 42, 45), stringsAsFactors = FALSE)
#' map_ggpmap(df)
#'}
map_ggmap <- function(x, zoom = 5, point_color = "#86161f",
                      lon = 'longitude', lat = 'latitude', ...) {
  UseMethod("map_ggmap")
}

#' @export
map_ggmap.occdat <- function(x, zoom = 5, point_color = "#86161f",
                             lon = 'longitude', lat = 'latitude', ...) {
  check4pkg("ggmap")
  dt <- occ2df(x)
  latitude <- NA
  longitude <- NA
  # Remove rows with missing data
  dt <- dt[complete.cases(dt$latitude, dt$longitude), ]
  min_lat <- min(dt$latitude, na.rm = TRUE)
  max_lat <- max(dt$latitude, na.rm = TRUE)
  min_long <- min(dt$longitude, na.rm = TRUE)
  max_long <- max(dt$longitude, na.rm = TRUE)
  species <- unique(dt$name)
  center_lat <- min_lat + (max_lat - min_lat)/2
  center_long <- min_long + (max_long - min_long)/2
  map_center <- c(lon = center_long, lat = center_lat)
  species_map <- ggmap::get_map(location = map_center, zoom = zoom, maptype = "terrain")
  temp <- dt[, c("latitude", "longitude")]
  ggmap::ggmap(species_map) +
    geom_point(data = temp,
               aes(x = longitude, y = latitude), color = point_color, size = 3) +
    ggtitle(paste0("Distribution of ", species)) +
    labs(x = "Longitude", y = "Latitude")
}
# [BUGS]: Can't figure out why it leaves out points even after I center the plot
# on the data. Setting zoom = 'auto' leaves out even more points.

#' @export
map_ggmap.default <- function(x, zoom = 5, point_color = "#86161f",
                              lon = 'longitude', lat = 'latitude', ...) {
  stop(sprintf("map_ggmap does not support input of class '%s'", class(x)), call. = FALSE)
}
