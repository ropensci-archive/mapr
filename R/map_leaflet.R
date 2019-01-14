#' Make interactive maps with Leaflet.js
#'
#' @export
#'
#' @template args
#' @param color Default color of your points.
#' @param size point size, Default: 13
#' @param name (character) the column name that contains the name to use in 
#' creating the map. If left `NULL` we look for a "name" column. 
#' @param ... Ignored
#' @details We add popups by default, and add all columns to the popup. The
#' html is escaped with [htmltools::htmlEscape()]
#' @return a Leaflet map in Viewer in Rstudio, or in your default browser
#' otherwise
#' @examples \dontrun{
#' ## spocc
#' library("spocc")
#' (out <- occ(query='Accipiter striatus', from='gbif', limit=50,
#'   has_coords=TRUE))
#' ### with class occdat
#' map_leaflet(out)
#' ### with class occdatind
#' map_leaflet(out$gbif)
#' ### use occ2sp
#' map_leaflet(occ2sp(out))
#'
#' ## rgbif
#' library("rgbif")
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' map_leaflet(res)
#'
#' ## SpatialPoints class
#' library("sp")
#' df <- data.frame(longitude = c(-120,-121),
#'                  latitude = c(41, 42), stringsAsFactors = FALSE)
#' x <- SpatialPoints(df)
#' map_leaflet(x)
#'
#' ## SpatialPointsDataFrame class
#' library("rgbif")
#' ### occ_search() output
#' res <- occ_search(scientificName = "Puma concolor", limit = 100)
#' x <- res$data
#' library("sp")
#' x <- x[stats::complete.cases(x$decimalLatitude, x$decimalLongitude), ]
#' coordinates(x) <- ~decimalLongitude+decimalLatitude
#' map_leaflet(x)
#' 
#' ### occ_data() output
#' res <- occ_data(scientificName = "Puma concolor", limit = 100)
#' map_leaflet(res)
#' 
#' #### many taxa
#' res <- occ_data(scientificName = c("Puma concolor", "Quercus lobata"), 
#'    limit = 30)
#' res
#' map_leaflet(res)
#' 
#'
#' ## data.frame
#' df <- data.frame(name = c('Poa annua', 'Puma concolor'),
#'                  longitude = c(-120,-121),
#'                  latitude = c(41, 42), stringsAsFactors = FALSE)
#' map_leaflet(df)
#'
#' # many species
#' library("spocc")
#' spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
#' dat <- occ(spp, from = 'gbif', limit = 50, has_coords = TRUE)
#' map_leaflet(dat)
#' map_leaflet(dat, color = c('#AFFF71', '#AFFF71', '#AFFF71'))
#' map_leaflet(dat, color = c('#976AAE', '#6B944D', '#BD5945'))
#'
#' # add a convex hull
#' ## map_leaflet(dat) %>% hull()  # using pipes
#' hull(map_leaflet(dat))
#' }
map_leaflet <- function(x, lon = 'longitude', lat = 'latitude', color = NULL,
                        size = 13, name = NULL, ...) {
  UseMethod("map_leaflet")
}

#' @export
map_leaflet.occdat <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {

  make_map_ll(dat_cleaner(spocc::occ2df(x), lon, lat, name), color, size)
}

#' @export
map_leaflet.occdatind <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {
  
  make_map_ll(dat_cleaner(spocc::occ2df(x), lon, lat, name), color, size)
}

#' @export
map_leaflet.SpatialPoints <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {
  
  make_map(x, color, size)
}

#' @export
map_leaflet.SpatialPointsDataFrame <- function(x, lon = 'longitude', 
  lat = 'latitude', color = NULL, size = 13, name = NULL, ...) {

  make_map(x, color, size)
}

#' @export
map_leaflet.gbif <- function(x, lon = 'longitude', lat = 'latitude', 
  color = NULL, size = 13, name = NULL, ...) {

  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  make_map_ll(
    dat_cleaner(x, lon = 'decimalLongitude', lat = 'decimalLatitude', name),
    color = color,
    size = size
  )
}

#' @export
map_leaflet.gbif_data <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {

  x <- if ("data" %in% names(x)) x$data else bdt(lapply(x, function(z) z$data))
  make_map_ll(
    dat_cleaner(x, lon = 'decimalLongitude', lat = 'decimalLatitude', name),
    color = color,
    size = size
  )
}

#' @export
map_leaflet.data.frame <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {
  
  make_map_ll(dat_cleaner(x, lon, lat, name), color, size)
}

#' @export
map_leaflet.default <- function(x, lon = 'longitude', lat = 'latitude',
  color = NULL, size = 13, name = NULL, ...) {
  
  stop(
    sprintf("map_leaflet does not support input of class '%s'", class(x)),
    call. = FALSE
  )
}

# helpers ------------------------------------
dat_cleaner <- function(x, lon = 'longitude', lat = 'latitude', name = NULL) {
  x <- guess_latlon(x, lat, lon)
  x <- x[stats::complete.cases(x$latitude, x$longitude), ]
  x <- check_name(x, name)
  return(x)
}

make_map <- function(x, color, size) {
  lf <- leaflet::leaflet(data = x)
  lf <- leaflet::addTiles(lf)
  leaflet::addMarkers(lf)
}

make_map_ll <- function(x, color, size) {
  x <- check_colors(x, color)
  x$popups <- make_popups(x)
  lf <- leaflet::leaflet(data = x)
  lf <- leaflet::addTiles(lf)
  leaflet::addCircleMarkers(
    lf, ~longitude, ~latitude,
    color = ~color, radius = size,
    popup = ~popups
  )
}

make_popups <- function(x) {
  res <- c()
  for (i in seq_len(NROW(x))) {
    temp <- c()
    for (j in seq_along(x[i, ])) {
      temp[j] <- sprintf('<tr><td><strong>%s</strong></td><td>%s</td></tr>',
                         names(x)[j], x[i,j])
    }
    res[i] <- sprintf('<table>\n%s\n</table>',
                      paste0(temp, collapse = "\n"))
    temp <- NULL
  }
  res
}
