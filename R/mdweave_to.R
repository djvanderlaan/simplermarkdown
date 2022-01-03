#' Run the code in a markdown file and generate a new document
#' 
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting file.
#' @param extra_arguments2 extra arguments passed on to pandoc. Should be a length 1 
#'  character vector.
#' @param run_in_temp When TRUE the intermediary markdown file and generated figures (when
#'  not using custom paths) are created in a temporary directory. Otherwise these will be
#'  generated in the same directory as the output file.
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
    extra_arguments2 = "--self-contained", run_in_temp = TRUE,
    cmd2 = 'pandoc %3$s -s "%1$s" -t latex -o "%2$s"', ...) {
  # Check if extension of ofn is .pdf; this is required by pandoc
  if (!grepl("\\.pdf$", ofn)) stop("ofn should have the extension .pdf.")
  # First convert fn to md using mdweave
  if (run_in_temp) {
    dir <- tempfile()
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    ofn_md <- file.path(dir, file_subs_ext(basename(fn), ".md", FALSE))
  } else {
    ofn_md <- file_subs_ext(ofn, ".md", FALSE)
    if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  }
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  run_cmd(cmd2, paste0("Failed to convert the markdown file to PDF. ", 
    "You may want to first run mdweave and inspect the resulting markdown ", 
    "file. The command was '%3$s'."))
  invisible(ofn)
}

#' @export
#' @rdname mdweave_to
mdweave_to_tex <- function(fn, ofn = file_subs_ext(basename(fn), ".tex", FALSE), 
    extra_arguments2 = "--self-contained", run_in_temp = TRUE,
    cmd2 = 'pandoc %3$s -s "%1$s" -t latex -o "%2$s"', ...) {
  if (grepl("\\.pdf$", ofn)) stop("ofn cannot have the extension .pdf.")
  # First convert fn to md using mdweave
  if (run_in_temp) {
    dir <- tempfile()
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    ofn_md <- file.path(dir, file_subs_ext(basename(fn), ".md", FALSE))
  } else {
    ofn_md <- file_subs_ext(ofn, ".md", FALSE)
    if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  }
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  run_cmd(cmd2, paste0("Failed to convert the markdown file to tex. ", 
    "You may want to first run mdweave and inspect the resulting markdown ", 
    "file. The command was '%3$s'."))
  invisible(ofn)
}


#' @export
#' @rdname mdweave_to
mdweave_to_html <- function(fn, ofn = file_subs_ext(basename(fn), ".html", FALSE), 
    extra_arguments2 = "--self-contained", run_in_temp = TRUE,
    cmd2 = 'pandoc %3$s -s "%1$s" -t html -o "%2$s"', ...) {
  # First convert fn to md using mdweave
  if (run_in_temp) {
    dir <- tempfile()
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    ofn_md <- file.path(dir, file_subs_ext(basename(fn), ".md", FALSE))
  } else {
    ofn_md <- file_subs_ext(ofn, ".md", FALSE)
    if (ofn_md == fn) ofn_md <- paste0(ofn, ".md")
  }
  mdweave(fn, ofn_md, ...)
  # Convert md to pdf
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  cmd2 <- sprintf(cmd2, ofn_md, ofn, extra_arguments2)
  run_cmd(cmd2, paste0("Failed to convert the markdown file to HTML. ", 
    "You may want to first run mdweave and inspect the resulting markdown ", 
    "file. The command was '%3$s'."))
  invisible(ofn)
}

