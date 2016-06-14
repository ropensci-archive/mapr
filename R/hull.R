#' Conex hull
#'
#' @export
#' @param x input
#' @param ... further args, ignored
hull <- function(x, ...) {
 UseMethod("hull")
}

#' @export
hull.leaflet <- function(x, ...) {
  dat <- Filter(function(z) z$method == "addMarkers" || z$method == "addCircleMarkers", x$x$calls)[[1]]
  dat <- data.frame(long = dat$args[[2]], lat = dat$args[[1]], stringsAsFactors = FALSE)
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

# hull.gbif <- function(x, ...) {
#   dat <- x$data[,c('decimalLongitude', 'decimalLatitude')]
#   dat <- na.omit(dat)
#   hpts <- grDevices::chull(dat$decimalLongitude, dat$decimalLatitude)
#   hpts <- c(hpts, hpts[1])
#   graphics::lines(x[hpts, ])
# }
