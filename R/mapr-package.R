#' Visualize species occurrence data
#'
#' @section Many inputs:
#' All functions take the following kinds of inputs:
#' \itemize{
#'  \item An object of class `occdat`, from the package \pkg{spocc}.
#'  An object of this class is composed of many objects of class
#'  `occdatind`
#'  \item An object of class `occdatind`, from the package \pkg{spocc}
#'  \item An object of class `gbif`, from the package \pkg{rgbif}
#'  \item An object of class `data.frame`. This data.frame can have any
#'  columns, but must include a column for taxonomic names (e.g., `name`),
#'  and for latitude and longitude (we guess your lat/long columns, starting
#'  with the default `latitude` and `longitude`)
#'  \item An object of class `SpatialPoints`
#'  \item An object of class `SpatialPointsDatFrame`
#' }
#'
#' @section Package API:
#' \itemize{
#'  \item [map_plot()] - static Base R plots
#'  \item [map_ggplot()] - static ggplot2 plots
#'  \item [map_ggmap()] - static ggplot2 plots with map layers
#'  \item [map_leaflet()] - interactive Leaflet.js interactive maps
#'  \item [map_gist()] - ineractive, shareable maps on GitHub Gists
#' }
#'
#' @importFrom ggplot2 geom_point aes ggtitle labs map_data
#' ggplot geom_point geom_polygon element_blank theme scale_color_manual
#' scale_color_brewer
#' @importFrom httr POST stop_for_status content upload_file
#' @importFrom sp SpatialPoints SpatialPointsDataFrame plot
#' @importFrom rworldmap getMap
#' @import leaflet
#' @name mapr-package
#' @aliases mapr
#' @docType package
#' @keywords package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
NULL

#' Example dataset: output from call to [spocc::occ()]
#'
#' A dataset with 25 rows, and 62 columns, from the query:
#' `spocc::occ(query='Accipiter striatus', from='gbif', limit=25, has_coords=T)`
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 25 rows and 62 variables
#' @name occdat_eg1
NULL

#' Example dataset: output from call to [rgbif::occ_search()]
#'
#' A dataset with 50 rows, and 101 columns, from the query:
#' `rgbif::occ_search(scientificName = "Puma concolor", limit = 100)`
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 50 rows and 101 variables
#' @name gbif_eg1
NULL
