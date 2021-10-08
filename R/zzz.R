
.onLoad <- function(libname, pkgname) {
  tools::vignetteEngine("mdweave_to_html", 
    weave = mdweave_to_html, 
    tangle = mdtangle,
    pattern = "[.][R]?md$", package = "simplermarkdown")
  tools::vignetteEngine("mdweave_to_pdf", 
    weave = mdweave_to_pdf, 
    tangle = mdtangle,
    pattern = "[.][R]?md$", package = "simplermarkdown")
}
