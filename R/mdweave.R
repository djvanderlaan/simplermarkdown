#' Run the code in a markdown file and generate a new markdown file
#'
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting markdown file.
#' @param extra_arguments extra arguments passed on to pandoc. Should be a length 1 
#'  character vector.
#' @param cmd command used to run pandoc. See details. 
#'
#' @details
#' \code{mdweave} calls pandoc. Pandoc will parse the markdown document and
#' pass the parsed file to a filter that runs the R-code and modifies the parsed
#' file. The new parse tree is passed on to pandoc which will output the new
#' markdown file using this new tree.
#'
#' Using the \code{cmd} argument the exact command used to run pandoc can be
#' modified. It is passed on to \code{\link{sprintf}} and uses positional 
#' arguments: (1) name of the input file, (2) location of the pandoc filer that
#' is used to run the R-code, (3) name of the output file, (4) the value of 
#' \code{extra_arguments}.
#'
#' @export
#' 
mdweave <- function(fn, ofn = paste0(fn, ".md"), 
    extra_arguments = "", cmd = 'pandoc %4$s -s "%1$s" --filter "%2$s" -o "%3$s"') {
  script <- system.file("scripts/filter.R", package = "tinymarkdown")
  cmd <- sprintf(cmd, fn, script, ofn, extra_arguments)
  system(cmd)
}
