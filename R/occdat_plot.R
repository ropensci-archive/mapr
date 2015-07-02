#' Use base R plotting methods to visualize spocc data.
#'
#' @importFrom rworldmap getMap
#' @export
plot.occdat <- function(x, ...) {
  df <- occ2df(x)
  df <- df[complete.cases(df),]
  sp::coordinates(df) <- ~longitude + latitude
  sp::proj4string(df) <- sp::CRS("+init=epsg:4326")
  sp::plot(rworldmap::getMap())
  points(df, col = "red", ...)
}
