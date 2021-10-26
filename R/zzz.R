
.onLoad <- function(libname, pkgname) {
  tools::vignetteEngine("mdweave_to_html", 
    weave = mdweave_to_html_vignette, 
    tangle = mdtangle_vignette,
    pattern = "[.][R]?md$", package = "simplermarkdown")
  tools::vignetteEngine("mdweave_to_pdf", 
    weave = mdweave_to_pdf_vignette, 
    tangle = mdtangle_vignette,
    pattern = "[.][R]?md$", package = "simplermarkdown")
}
