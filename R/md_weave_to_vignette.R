# Wrappers around the mdweave_to_* functions and mdtangle function intended
# for use for handling vignettes. The main difference is that these functions
# check if pandoc is available and if not will generate dummy output and not
# generate an error.

mdweave_to_html_vignette <- function(fn, ofn = file_subs_ext(basename(fn), "html", FALSE), ...) {
  if (!has_pandoc()) {
    writeLines("Cannot find pandoc. Not able to weave vignette.", ofn)
    ofn
  } else {
    mdweave_to_html(fn, ofn, ...)
  }
}


mdweave_to_pdf_vignette <- function(fn, ofn = file_subs_ext(basename(fn), "pdf", FALSE), ...) {
  if (!has_pandoc()) {
    writeLines("Cannot find pandoc. Not able to weave vignette.", ofn)
    ofn
  } else {
    mdweave_to_pdf(fn, ofn, ...)
  }
}


mdtangle_vignette <- function(fn, ofn = file_subs_ext(basename(fn), ".R"), ...) {
  if (!has_pandoc()) {
    writeLines("# Cannot find pandoc. Not able to tangle vignette.", ofn)
    ofn
  } else {
    mdtangle(fn, ofn, ...)
  }
}

