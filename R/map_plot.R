#' Base R mapping
#'
#' @export
#' @template args
#' @param color Default color of your points.
#' @param size point size, passed to `cex` Default: 1
#' @param pch point symbol shape, Default: 16
#' @param hull (logical) whether to add a convex hull. Default: `FALSE`
#' @param name (character) the column name that contains the name to use in 
#' creating the map. If left `NULL` we look for a "name" column. 
#' @param ... Further args to [graphics::points()]
#' @return Plots a world scale map
#'
#' @examples
#' # map spocc output, here using a built in object
#' data(occdat_eg1)
#' map_plot(occdat_eg1)
#'
#' # map rgbif output, here using a built in object
#' data(gbif_eg1)
#' map_plot(gbif_eg1)
#'
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=25,
#'   has_coords=TRUE))
#' ### class occdat
#' map_plot(out)
#' map_plot(out, hull = TRUE)
#' ### class occdatind
#' map_plot(out$gbif)
#' map_plot(out$gbif, hull = TRUE)
#'
#' ## rgbif
#' library("rgbif")
#' ### occ_search() output
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_plot(res)
#' map_plot(res, hull = TRUE)
#' 
#' ### occ_data() output
#' res <- occ_data(scientificName = "Puma concolor", limit = 100)
#' map_plot(res)
#' #### many taxa
#' res <- occ_data(scientificName = c("Puma concolor", "Quercus lobata"), 
#'    limit = 30)
#' res
#' map_plot(res)
#' 
#'
#' ## data.frame
#' df <- data.frame(
#'   name = c('Poa annua', 'Puma concolor', 'Foo bar', 'Stuff things'),
#'   longitude = c(-125, -123, -121, -110),
#'   latitude = c(41, 42, 45, 30), stringsAsFactors = FALSE)
#' map_plot(df)
#' map_plot(df, hull = TRUE)
#'
#' ### usage of occ2sp()
#' #### SpatialPoints
#' spdat <- occ2sp(out)
#' map_plot(spdat)
#' map_plot(spdat, hull = TRUE)
#'
#' #### SpatialPointsDataFrame
#' spdatdf <- as(spdat, "SpatialPointsDataFrame")
#' map_plot(spdatdf)
#' map_plot(spdatdf, hull = TRUE)
#'
#' # many species, each gets a different color
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta',
#'   'Ursus americanus')
#' dat <- occ(spp, from = 'gbif', limit = 30, has_coords = TRUE,
#'   gbifopts = list(country = 'US'))
#' map_plot(dat)
#' map_plot(dat, hull = TRUE)
#' ## diff. color for each taxon
#' map_plot(dat, color = c('#976AAE', '#6B944D', '#BD5945', 'red'))
#' map_plot(dat, color = c('#976AAE', '#6B944D', '#BD5945', 'red'), hull = TRUE)
#'
#' # add a convex hull
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_plot(res, hull = FALSE)
#' map_plot(res, hull = TRUE)
#' }
map_plot <- function(x, lon = 'longitude', lat = 'latitude', color = NULL,
                     size = 1, pch = 16, hull = FALSE, name = NULL, ...) {
  UseMethod("map_plot")
}

#' @export
map_plot.occdat <- function(x, lon = 'longitude', lat = 'latitude',
                            color = NULL, size = 1, pch = 16,
                            hull = FALSE, name = NULL, ...) {
  df <- spocc::occ2df(x)
  x <- check_name(x, name)
  df <- check_colors(df, color)
  plot_er(plot_prep(df), size, hull, ...)
}

#' @export
map_plot.occdatind <- function(x, lon = 'longitude', lat = 'latitude',
                               color = NULL, size = 1, pch = 16,
                               hull = FALSE, name = NULL, ...) {
  df <- spocc::occ2df(x)
  x <- check_name(x, name)
  df <- check_colors(df, color)
  plot_er(plot_prep(df), size, hull, ...)
}

#' @export
map_plot.gbif <- function(x, lon = 'longitude', lat = 'latitude', color = NULL,
                          size = 1, pch = 16, hull = FALSE, name = NULL, ...) {
  df <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  df <- guess_latlon(df)
  x <- check_name(x, name)
  df <- df[stats::complete.cases(df$latitude, df$longitude), ]
  df <- df[df$longitude != 0, ]
  df <- check_colors(df, color)
  sp::coordinates(df) <- ~longitude + latitude
  plot_er(df, size, hull, ...)
}

#' @export
map_plot.gbif_data <- function(x, lon = 'longitude', lat = 'latitude', color = NULL,
                          size = 1, pch = 16, hull = FALSE, name = NULL, ...) {
  df <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  df <- guess_latlon(df)
  x <- check_name(x, name)
  df <- df[stats::complete.cases(df$latitude, df$longitude), ]
  df <- df[df$longitude != 0, ]
  df <- check_colors(df, color)
  sp::coordinates(df) <- ~longitude + latitude
  plot_er(df, size, hull, ...)
}

#' @export
map_plot.data.frame <- function(x, lon = 'longitude', lat = 'latitude',
                                color = NULL, size = 1, pch = 16,
                                hull = FALSE, name = NULL, ...) {
  x <- guess_latlon(x, lat, lon)
  x <- check_name(x, name)
  x <- check_colors(x, color)
  plot_er(plot_prep(x), size, hull, ...)
}

#' @export
map_plot.SpatialPoints <- function(x, lon = 'longitude', lat = 'latitude',
                                   color = NULL, size = 1, pch = 16,
                                   hull = FALSE, name = NULL, ...) {
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  x <- check_name(x, name)
  x <- check_colors(x, color)
  plot_er(plot_prep(x), size, hull, ...)
}

#' @export
map_plot.SpatialPointsDataFrame <- function(x, lon = 'longitude',
                                            lat = 'latitude', color = NULL,
                                            size = 1, pch = 16,
                                            hull = FALSE, name = NULL, ...) {
  x <- data.frame(x)
  x <- guess_latlon(x, lat, lon)
  x <- check_name(x, name)
  x <- check_colors(x, color)
  plot_er(plot_prep(x), size, hull, ...)
}

#' @export
map_plot.default <- function(x, lon = 'longitude', lat = 'latitude',
                             color = NULL, size = 1, pch = 16,
                             hull = FALSE, name = NULL, ...) {
  stop(
    sprintf("map_plot does not support input of class '%s'", class(x)),
    call. = FALSE
  )
}


##### helpers --------------------
plot_prep <- function(x) {
  x <- x[stats::complete.cases(x$latitude, x$longitude), ]
  x <- x[x$longitude != 0, ]
  sp::coordinates(x) <- ~longitude + latitude
  x
}

plot_er <- function(x, size, hull, pch = 16, ...) {
  sp::proj4string(x) <- sp::CRS("+init=epsg:4326")
  maps::map()
  graphics::points(x, pch = pch, col = x$color, cex = size, ...)
  if (length(unique(x$color)) > 1) {
    graphics::legend(x = -180, y = -20, unique(x$name), pch = 16,
                     col = unique(x$color), bty = "n", cex = 0.8)
  }
  make_hull(x, hull)
}

make_hull <- function(x, hull) {
  if (hull) {
    x <- data.frame(sp::coordinates(x))
    hpts <- grDevices::chull(x$longitude, x$latitude)
    hpts <- c(hpts, hpts[1])
    graphics::lines(x[hpts, ])
  }
}
