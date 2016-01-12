#' Vizualize species occurrence data
#'
#' @section Many inputs:
#' All functions take the following four kinds of inputs
#' \itemize{
#'  \item An object of class `occdat`, from the package `spocc`. An object of
#'  this class is composed of many objects of class `occdatind`
#'  \item An object of class `occdatind`, from the package `spocc`
#'  \item An object of class `gbif`, from the package `rgbif`
#'  \item An object of class `data.frame`. This data.frame can have any columns,
#'  but must include a column for taxonomic names (e.g., `name`), and for latitude
#'  and longitude (we guess your lat/long columns, starting with the default
#'  `latitude` and `longitude`)
#' }
#'
#' @section Mapping options:
#' \itemize{
#'  \item \code{\link{map_plot}} - Base R plots
#'  \item \code{\link{map_ggplot}} - ggplot2 plots
#'  \item \code{\link{map_ggmap}} - ggplot2 plots with map layers
#'  \item \code{\link{map_leaflet}} - Leaflet.js interactive maps
#'  \item \code{\link{map_gist}} - Ineractive, shareable maps on GitHub Gists
#' }
#'
#' @importFrom methods as is
#' @importFrom stats na.omit complete.cases setNames
#' @importFrom utils write.csv browseURL
#' @importFrom graphics points
#' @importFrom ggplot2 geom_point aes ggtitle labs map_data
#' ggplot geom_point geom_polygon element_blank theme
#' @importFrom httr POST stop_for_status content upload_file
#' @importFrom sp SpatialPoints SpatialPointsDataFrame plot
#' @importFrom rworldmap getMap
#' @importFrom gistr gist_create
#' @importFrom RColorBrewer brewer.pal
#' @importFrom spocc occ2df
#' @import leaflet
#' @name mapr-package
#' @aliases mapr
#' @docType package
#' @keywords package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
NULL
