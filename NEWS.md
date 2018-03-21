mapr 0.4.0
==========

### MINOR IMPROVEMENTS

* All `map_*()` functions now support `gbif_data` class from the `rgbif` package, which is the output of `rgbif::occ_data()` (#29)
* Added `.github` files for contributing, issue and PR templates (#30)


mapr 0.3.4
==========

### MINOR IMPROVEMENTS

* Now using markdown for docs (#27)
* Replaced `httr` with `crul` as http client (#26)

### Problem with ggmap

* Note that there is a problem with `map_ggmap` due to a bug in 
`ggmap`. It is fixed in the `ggmap` dev version, so should be fixed
in the CRAN version soon, hopefully.


mapr 0.3.0
==========

### NEW FEATURES

* Now in all functions, when there's more than 1 taxon, we'll do a separate
color for each taxon and draw a legend if applicable (#21) (#22)
* Added support for adding convex hulls to some of the plot types (#23)
thanks to @rossmounce for the feature request
* `map_leaflet()` now adds metadata as a popup to each marker (#18) (#25)


mapr 0.2.0
==========

### NEW FEATURES

* Released to CRAN.
