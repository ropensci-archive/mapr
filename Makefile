all: move rmd2md

move:
		cp inst/vign/mapr_vignette.md vignettes
		cp -rf inst/vign/img/* vignettes/img/

rmd2md:
		cd vignettes;\
		mv mapr_vignette.md mapr_vignette.Rmd
