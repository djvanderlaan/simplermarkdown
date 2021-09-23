#' Output filters for code blocks in markdown
#'
#' @param code character vector containing the code of the code block
#' @param language the language in which the code is written (as specified in 
#'   the markdown file).
#' @param id the identifier of the code block.
#' @param ... additional arguments speficied as arguments in the code block are
#'   passed on to the filter function. Often these are ignored, or they are 
#'   passed on to other functions (see 'Details').
#' @param echo the code in \code{code} is repeated in the output. 
#' @param results include the results of running the code in the output. The 
#'   output of code that explicitly writes to standard output is always 
#'   included.
#'
#' @details
#' The filter functions \code{tab} and \code{fig} call 
#' \code{\link{md_table}} and \code{\link{md_figure}} respectively; additional
#' arguments are passed on to those functions. Other filter functions ignore the 
#' additional arguments. 
#'
#' It is also possible to write custom output filter. An output filter should have
#' \code{code}, \code{language} and \code{id} as its first three arguments. It 
#' should either return a character vector containing the markdown that should be
#' included in the resulting markdown file or an object that can be directly 
#' included in the pandoc parse tree. If the function does not return a character
#' vector it is assumed the latter is returned. \code{tinymarkdown} defines a
#' small number of valid object constructors: \code{\link{raw_block}} and
#' \code{\link{markdown_block}}.
#'
#' The custom function should be available when running the markdown document
#' through pandoc. The easiest way is to \code{\link{source}} or define the 
#' function in the markdown document before using it. 
#'
#' @rdname output_fun
#' @export
#' 
output_table <- function(code, language = "R", id = "",  ...) {
  tab <- source(exprs = str2expression(code), echo = FALSE)
  md_table(tab$value, as_character = TRUE, ...)
}


#' @rdname output_fun
#' @export
#' 
output_figure <- function(code, language = "R", id = "", ...) {
  expr <- str2expression(code)
  md_figure(expr, as_character = TRUE, id = id, ...)
}


#' @rdname output_fun
#' @export
#' 
output_eval <- function(code, language = "R", id = "", echo = TRUE, 
    results = TRUE, ...) {
  res <- utils::capture.output(
    source(exprs = str2expression(code), echo = echo, print.eval = results)
  )
  res <- paste0(res, collapse="\n")
  markdown_block(res, language, id, ...)
}


#' @rdname output_fun
#' @export
#' 
output_raw <- function(code, language = "R", id = "", ...) {
  res <- utils::capture.output(
    source(exprs = str2expression(code), echo = FALSE)
  )
  res <- paste0(res, collapse="\n")
  raw_block(res)
}

#' @rdname output_fun
#' @export 
#' 
output_str <- function(code, language = "R", id = "", ...) {
  res <- source(exprs = str2expression(code), echo = FALSE)
  res <- paste0(as.character(res$value), collapse="\n")
  str_block(res)
}

