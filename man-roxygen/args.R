#' @param x The data. An object of class \code{occdat}, \code{occdatind},
#' \code{gbif}, or \code{data.frame}. The package \pkg{spocc} needed for
#' the first two, and \pkg{rgbif} needed for the third. When \code{data.frame}
#' input, any number of columns allowed, but with at least the following:
#' name (the taxonomic name), latitude (in dec. deg.), longitude (in dec. deg.)
#' @param lon,lat (character) Longitude and latitude variable names. Ignored
#' unless \code{data.frame} input to \code{x} parameter. We attempt to guess, but
#' if nothing close, we stop. Default: \code{longitude} and \code{latitude}
