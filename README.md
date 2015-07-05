spoccutils
==========



[![Build Status](https://api.travis-ci.org/ropensci/spoccutils.png)](https://travis-ci.org/ropensci/spoccutils)
[![Build status](https://ci.appveyor.com/api/projects/status/3tyojycmeqmj2pcw?svg=true)](https://ci.appveyor.com/project/sckott/spoccutils)
[![Coverage Status](https://coveralls.io/repos/ropensci/spoccutils/badge.svg)](https://coveralls.io/r/ropensci/spoccutils)

Helper for [spocc](https://github.com/ropensci/spocc) - a client for getting species occurrence data from many sources.

This package has utilities for:

* Making maps, with:
    * base R
    * ggplot2
    * Leaflet
    * GitHub Gists
    * ...

We split this package off from `spocc` to make `spocc` lighter weight so that users that just want data don't have to install a bunch of other dependencies for mapping, etc.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Installation

Install `spoccutils`


```r
install.packages("spoccutils", dependencies = TRUE)
```

Or the development version from GitHub


```r
devtools::install_github("ropensci/spoccutils")
```


```r
library("spoccutils")
library("spocc")
```

## Make maps

### Leaflet


```r
spp <- c('Danaus plexippus', 'Accipiter striatus', 'Pinus contorta')
dat <- occ(query = spp, from = 'gbif', has_coords = TRUE)
map_leaflet(dat, dest = ".")
```

![leafletmap](http://f.cl.ly/items/3w2Y1E3Z0T2T2z40310K/Screen%20Shot%202014-02-09%20at%2010.38.10%20PM.png)

### Github gist


```r
dat <- fixnames(dat)
map_gist(dat, color = c("#976AAE","#6B944D","#BD5945"))
```

![gistmap](http://f.cl.ly/items/343l2G0A2J3T0n2t433W/Screen%20Shot%202014-02-09%20at%2010.40.57%20PM.png)

### ggplot2 family maps

#### ggmaps


```r
ecoengine_data <- occ(query = 'Lynx rufus californicus', from = 'ecoengine', limit = 100)
map_ggmaps(ecoengine_data)
```

![ggmaps](http://f.cl.ly/items/1L3r0b3k1W2o1Z3j2I3r/Screen%20Shot%202015-07-02%20at%202.55.59%20PM.png)

#### ggplot


```r
map_ggplot(ecoengine_data, "usa")
#> Error in occ2df(x): object 'ecoengine_data' not found
```

![ggplot2](http://f.cl.ly/items/1k2a012u1F1H1E13370U/Screen%20Shot%202015-07-02%20at%203.21.31%20PM.png)

### Base R plots


```r
map_plot(dat, cex = 1, pch = 10)
```

![basremap](http://f.cl.ly/items/2J3d1z1t0U3r410o2T3d/Screen%20Shot%202015-07-02%20at%202.57.04%20PM.png)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/spoccutils/issues).
* License: MIT
* Get citation information for `spoccutils` in R doing `citation(package = 'spoccutils')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
