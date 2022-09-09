mapr
====



[![R-check](https://github.com/ropensci/mapr/workflows/R-check/badge.svg)](https://github.com/ropensci/mapr/actions/)
[![cran checks](https://cranchecks.info/badges/worst/mapr)](https://cranchecks.info/pkgs/mapr)
[![codecov](https://codecov.io/gh/ropensci/mapr/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/mapr)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/mapr?color=FAB657)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/mapr)](https://cran.r-project.org/package=mapr)


Helper for making maps of species occurrence data, including for:

* spocc (https://github.com/ropensci/spocc)
* rgbif (https://github.com/ropensci/rgbif)
* and some `sp` classes

This package has utilities for making maps with:

* base R
* ggplot2
* Leaflet - via `leaflet` pkg
* GitHub Gists - via `gistr` package

Get started with the docs: https://docs.ropensci.org/mapr/

## Installation

Install `mapr`


```r
install.packages("mapr")
```

Or the development version from GitHub


```r
remotes::install_github("ropensci/mapr")
```


```r
library("mapr")
library("spocc")
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/mapr/issues).
* License: MIT
* Get citation information for `mapr` in R doing `citation(package = 'mapr')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
