## mapr datasets preparation script

# gbif_eg1
library(rgbif)
foo <- occ_search(scientificName = "Puma concolor", limit = 100)
z <- foo$data
for (i in seq_along(z)) {
  if (is.character(z[[i]])) {
    cat(names(z)[i], sep = "\n")
    tools::showNonASCII(na.omit(z[[i]]))
  }
}
foo$data$rightsHolder <- stringi::stri_escape_unicode(foo$data$rightsHolder)
foo$data$stateProvince <- stringi::stri_escape_unicode(foo$data$stateProvince)
foo$data$verbatimLocality <- stringi::stri_escape_unicode(foo$data$verbatimLocality)
foo$data$recordedBy <- stringi::stri_escape_unicode(foo$data$recordedBy)
foo$data$rights <- stringi::stri_escape_unicode(foo$data$rights)
foo$data$identifiedBy <- stringi::stri_escape_unicode(foo$data$identifiedBy)
foo$data$occurrenceRemarks <- stringi::stri_escape_unicode(foo$data$occurrenceRemarks)
z <- foo$data
gbif_eg1 <- foo$data
save(gbif_eg1, file = "data/gbif_eg1.rda", version = 2)

# occdat_eg1
library(spocc)
res <- occ(query='Accipiter striatus', from='gbif', limit=25, has_coords=TRUE)
res$gbif$data[[1]]$rights <- stringi::stri_escape_unicode(res$gbif$data[[1]]$rights)
tools::showNonASCII(res$gbif$data[[1]]$rights)
occdat_eg1 <- res
save(occdat_eg1, file = "data/occdat_eg1.rda", version = 2)
