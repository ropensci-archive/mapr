#' Add a convex hull to a map
#'
#' @export
#' @param x input
#' @param ... ignored
#' @details Can be used with [map_leaflet()], [map_plot()],
#' and [map_ggplot()]. Other methods in this package may be supported
#' in the future.
#'
#' @return Adds a convex hull to the plot. See [grDevices::chull()]
#' for info.
#'
#' @examples
#' # map spocc output, here using a built in object
#' data(occdat_eg1)
#' map_plot(occdat_eg1, hull = TRUE)
#'
#' # map rgbif output, here using a built in object
#' hull(map_ggplot(occdat_eg1))
#'
#' @examples \dontrun{
#' # leaflet
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE)
#' hull(map_leaflet(dat))
#'
#' # ggplot
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' hull(map_ggplot(res))
#'
#' # base plots
#' library("spocc")
#' out <- occ(query='Accipiter striatus', from='gbif', limit=25,
#'   has_coords=TRUE)
#' map_plot(out, hull = TRUE)
#' }
hull <- function(x, ...) {
  UseMethod("hull")
}

#' @export
hull.leaflet <- function(x, ...) {
  dat <- Filter(function(z) z$method == "addMarkers" ||
                  z$method == "addCircleMarkers", x$x$calls)[[1]]
  dat <- data.frame(long = dat$args[[2]], lat = dat$args[[1]],
                    stringsAsFactors = FALSE)
  outline <- dat[grDevices::chull(dat$long, dat$lat), ]
  x %>%
    addPolygons(data = outline, lng = ~long, lat = ~lat,
                fill = FALSE, weight = 2, color = "#FFFFCC", group = "Outline")
}

#' @export
hull.gg <- function(x, ...) {
  longitude <- latitude <- NA
  outline <- x$data[grDevices::chull(x$data$longitude, x$data$latitude), ]
  x + geom_polygon(data = outline, aes(x = longitude, y = latitude),
                   fill = NA, size = 1, colour = "black")
}
