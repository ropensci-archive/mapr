#' ggpmap visualization of species occurences
#'
#' @export
#' @param x Input, object of class \code{occdat}
#' @param zoom zoom level for map. Adjust depending on how your data look.
#' @param point_color Default color of your points
#' @param ... Ignored
#' @examples \dontrun{
#' library("spocc")
#' ecoengine_data <- occ(query = 'Lynx rufus californicus', from = 'ecoengine', limit=100)
#' map_ggmap(ecoengine_data)
#' gbif_data <- occ(query = 'Accipiter striatus', from = 'gbif', limit=100)
#' map_ggmap(gbif_data)
#' bison_data <- occ(query = 'Accipiter striatus', from = 'bison', limit=100)
#' map_ggmap(bison_data)
#'}
map_ggmap <- function(x, zoom = 5, point_color = "#86161f", ...) {
  UseMethod("map_ggmap")
}

#' @export
map_ggmap.occdat <- function(x, zoom = 5, point_color = "#86161f", ...) {
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
map_ggmap.default <- function(x, ...) {
  stop(sprintf("map_ggmap does not support input of class '%s'", class(x)), call. = FALSE)
}
