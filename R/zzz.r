sc <- function(l) Filter(Negate(is.null), l)

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)

check4pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

check_inputs <- function(x) {
  calls <- names(sapply(x, deparse))[-1]
  calls_vec <- "point_color" %in% calls
  if (any(calls_vec)) {
    stop("The parameter 'point_color' has been replaced by 'color'",
         call. = FALSE)
  }
}

bdt <- function(x) {
  (bb <- data.table::setDF(
    data.table::rbindlist(x, fill = TRUE, use.names = TRUE)
  ))
}
