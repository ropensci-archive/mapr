#' Use base R plotting methods to visualize spocc data.
#'
#' @export
#' @method plot occdat
plot.occdat <- function(x, ...) {
  df <- occ2df(x)
  df <- df[complete.cases(df),]
  sp::coordinates(df) <- ~longitude + latitude
  sp::proj4string(df) <- sp::CRS("+init=epsg:4326")
  plot(rworldmap::getMap())
  points(df, col = "red", ...)
}
