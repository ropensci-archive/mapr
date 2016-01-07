#' Vizualize species occurrence data
#'
#' @importFrom methods as is
#' @importFrom stats na.omit complete.cases setNames
#' @importFrom utils write.csv browseURL
#' @importFrom graphics points
#' @importFrom ggplot2 geom_point aes ggtitle labs map_data
#' ggplot geom_point geom_polygon element_blank theme
#' @importFrom httr POST stop_for_status content upload_file
#' @importFrom leafletR toGeoJSON leaflet
#' @importFrom sp SpatialPoints SpatialPointsDataFrame plot
#' @importFrom rworldmap getMap
#' @importFrom gistr gist_create
#' @importFrom RColorBrewer brewer.pal
#' @import spocc
#' @name mapr-package
#' @aliases mapr
#' @docType package
#' @keywords package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
NULL
