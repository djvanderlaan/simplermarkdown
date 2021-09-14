#' Run the code in a markdown file and generate a new document
#' 
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting file.
#' @param extra_arguments2 extra arguments passed on to pandoc. Should be a length 1 
#'  character vector.
#' @param cmd2 command used to run pandoc. See details. 
#' @param ... additional arguments are passed on to \code{\link{mdweave}}.
#'
#' @details
#' These functions first call \code{\link{mdweave}} to run the code in the original
#' file and convert the original markdown file to a new markdown file. This second
#' markdown file is then converted to the desired output format using a second run
#' of \code{pandoc}.
#'
#' In case of converting to pdf the file is required to have the extension 
#' \code{.pdf}. In case of converting to LaTeX, the file cannot have the extension 
#' \code{.pdf}. That is because in both cases the file is first converted to 
#' LaTeX. In case of a file with the extension \code{.pdf} the file is than 
#' further converted to PDF. 
#'
#' @return
#' Returns the name of the resulting outout file.
#'
#' @export
#' @rdname mdweave_to
mdweave_to_pdf <- function(fn, ofn = file_subs_ext(basename(fn), ".pdf", FALSE), 
    extra_arguments2 = "", cmd2 = 'pandoc %3$s -s "%1$s" -t latex -o "%2$s"', ...) {
  # Check if extension of ofn is .pdf; this is required by pandoc
  if (!grepl("\\.pdf$", ofn)) stop("ofn should have the extension .pdf.")
  # First convert fn to md using mdweave
  ofn_md <- file_subs_ext(ofn, ".md", FALSE)
  if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  system(cmd2)
  invisible(ofn)
}

#' @export
#' @rdname mdweave_to
mdweave_to_tex <- function(fn, ofn = file_subs_ext(basename(fn), ".tex", FALSE), 
    extra_arguments2 = "", cmd2 = 'pandoc %3$s -s "%1$s" -t latex -o "%2$s"', ...) {
  if (grepl("\\.pdf$", ofn)) stop("ofn cannot have the extension .pdf.")
  # First convert fn to md using mdweave
  ofn_md <- file_subs_ext(ofn, ".md", FALSE)
  if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  system(cmd2)
  invisible(ofn)
}


#' @export
#' @rdname mdweave_to
mdweave_to_html <- function(fn, ofn = file_subs_ext(basename(fn), ".html", FALSE), 
    extra_arguments2 = "", cmd2 = 'pandoc %3$s -s "%1$s" -t html -o "%2$s"', ...) {
  # First convert fn to md using mdweave
  ofn_md <- file_subs_ext(ofn, ".md", FALSE)
  if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  system(cmd2)
  invisible(ofn)
}

