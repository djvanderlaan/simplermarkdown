
.onLoad <- function(libname, pkgname) {
  tools::vignetteEngine("tinymarkdown", 
    weave = mdweave_to_html, 
    tangle = mdtangle,
    pattern = "[.]Rmd$", package = "tinymarkdown")
}
