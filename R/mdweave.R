#' Run the code in a markdown file and generate a new markdown file
#'
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting markdown file.
#' @param cmd1 command used to run pandoc. See details. 
#' @param cmd2 command used to run pandoc. See details. 
#' @param ... ignored
#'
#' @details
#' \code{mdweave} calls pandoc twice. In the first call the markdown file is
#' parsed by pandoc and the parse tree is written to a temporary file. This
#' parse tree is the read by mdweave and any R-code in the tree is executed
#' resulting in a modified parse tree. This file is then stored to a new
#' temporary file. Pandoc is the called a second time to convert the new
#' parse tree to a markdown file. 
#'
#' The arguments \code{cmd1} and \code{cmd2} contain the calls used to run 
#' pandoc. The arguments can be used to, for example pas additional arguments
#' to pandoc. They use positional arguments. In \code{cmd1}, the first argument
#' (\code{%1$s}) is the input file name and the second (\code{%2$s}) the 
#' temporary file containing the parsed tree. In \code{cmd2}, the first argument
#' is the temporary file with the modified parse tree and the second argument
#' the output file.
#'
#' @export
#' 
mdweave <- function(fn, ofn = file_subs_ext(basename(fn), ".md", FALSE), 
    cmd1 = 'pandoc -s "%1$s" -t json -o "%2$s"', 
    cmd2 = 'pandoc -s "%1$s" -t markdown -o "%2$s"', ...) {
  # Check if output filename does nog conflict with input filename
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  # Convert markdown to a parse tree in json
  tmp_ofn <- tempfile(fileext = ".json")
  on.exit(file.remove(tmp_ofn))
  cmd1 <- sprintf(cmd1, fn, tmp_ofn)
  system(cmd1)
  # Set environment variable with location of output file
  # Possibly needed for filters to know where to put output
  # files such as figures
  outputdir <- dirname(ofn)
  dir.create(outputdir, recursive = TRUE, showWarnings = FALSE)
  Sys.setenv(MDOUTDIR = outputdir)
  on.exit(Sys.unsetenv("MDOUTDIR"))
  # Filter json (run R code in json) and save result
  dta <- filter_pandoc_json_tree(tmp_ofn)
  tmp_ifn <- tempfile(fileext = ".json")
  on.exit(file.remove(tmp_ifn))
  writeLines(rjson::toJSON(dta), tmp_ifn)
  # Convert json back to markdown
  cmd2 <- sprintf(cmd2, tmp_ifn, ofn)
  system(cmd2)
  # Return filename of the final file 
  invisible(ofn)
}

