warning_color_vec <-
  "length of taxa names not equal to color vector, generating colors for you"

check_colors <- function(x, color) {
  if (!is.null(color)) {
    if (length(unique(x$name)) != length(color)) {
      warning(warning_color_vec, call. = FALSE)
      ref <- data.frame(
        name = unique(x$name),
        color = RColorBrewer::brewer.pal(length(unique(x$name)),
                                         name = "Set1"),
        stringsAsFactors = FALSE)
    } else {
      ref <- data.frame(name = unique(x$name), color = color,
                        stringsAsFactors = FALSE)
    }
    merge(x, ref, by = "name")
  } else {
    # x$color <- "#F7766D"
    # x
    ref <- data.frame(
      name = unique(x$name),
      color = {
        if (length(unique(x$name)) >= 3) {
          if (length(unique(x$name)) > 9) {
            message(
              "no. taxa > 9, using single color - consider passing in colors")
            "#F7766D"
          } else {
            RColorBrewer::brewer.pal(length(unique(x$name)), name = "Set1")
          }
        } else {
          sample(
            suppressWarnings(
              RColorBrewer::brewer.pal(length(unique(x$name)), name = "Set1")
            ),
            length(unique(x$name))
          )
        }
      },
      stringsAsFactors = FALSE)
    merge(x, ref, by = "name")
  }
}

pick_colors <- function(x, color) {
  if (!is.null(color)) {
    if (length(unique(x$name)) != length(color)) {
      warning(warning_color_vec, call. = FALSE)
      ggplot2::scale_color_brewer(type = "qual", palette = 6)
    } else {
      ggplot2::scale_color_manual(values = color)
    }
  }
}
