#' Extract code from the code blocks in a markdown file
#'
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting R-script
#' @param extra_arguments extra arguments passed on to pandoc. Should be a length 1 
#'  character vector.
#' @param cmd command used to run pandoc. See details. 
#'
#' @details
#' \code{mdtangle} calls pandoc. Pandoc will parse the markdown document and
#' write the parsed file to temporary file. This file is read by 
#' \code{mdtangle} and the code is extracted from it and written to \code{ofn}.
#'
#' Using the \code{cmd} argument the exact command used to run pandoc can be
#' modified. It is passed on to \code{\link{sprintf}} and uses positional 
#' arguments: (1) name of the input file, (2) location of the temporary file
#' to which the parsed document is written, (3) the value of 
#' \code{extra_arguments}.
#'
#' @export
#' 
mdtangle <- function(fn, ofn = paste0(fn, ".R"), 
    extra_arguments = "", cmd = 'pandoc %3$s -s "%1$s" -t json -o "%2$s"') {
  tmp_ofn <- tempfile(fileext = ".json")
  on.exit(file.remove(tmp_ofn))
  cmd <- sprintf(cmd, fn, tmp_ofn, extra_arguments)
  system(cmd)
  dta <- rjson::fromJSON(file = tmp_ofn, simplify = FALSE)
  default_fun <- "eval"
  verbosity   <- 1
  code <- character(0)
  gather_code <- function(block, default_fun = "eval", verbosity = 1) {
    b <- get_block(block)
    if (!is.null(b) && b$language == "R") {
      id <- if (b$id == "") "<unlabeled code block>" else b$id
      if (verbosity > 0) message("Evaluating code in block '", id, "'.")
      code <<- c(code, paste("#", id), b$code, "")
    }
    block
  }
  ignore_inline <- function(block, verbosity = 1)  {
    block
  }
  # Go over all of the blocks in the tree; check if they contain R code and
  # evaluate the code
  dta$blocks <- parse_blocks(dta$blocks, default_fun = default_fun, 
    verbosity = verbosity, eval_block = gather_code, eval_inline = ignore_inline)
  writeLines(code, con = ofn)
}

