warning_color_vec <-
  "length of taxa names not equal to color vector, generating colors for you"

check_colors <- function(x, color) {
  if (!is.null(color)) {
    if (length(unique(x$name)) != length(color)) {
      warning(warning_color_vec, call. = FALSE)
      ref <- data.frame(
        name = unique(x$name),
        color = RColorBrewer::brewer.pal(length(unique(x$name)), name = "Set1"),
        stringsAsFactors = FALSE)
    } else {
      ref <- data.frame(name = unique(x$name), color = color,
                        stringsAsFactors = FALSE)
    }
    merge(x, ref, by = "name")
  } else {
    x$color <- "#F7766D"
    x
  }
}

pick_colors <- function(x, color) {
  if (!is.null(color)) {
    if (length(unique(x$name)) != length(color)) {
      warning(warning_color_vec, call. = FALSE)
      scale_color_brewer(type = "qual", palette = 6)
    } else {
      scale_color_manual(values = color)
    }
  }
}
