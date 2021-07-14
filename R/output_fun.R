

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
#' The filter functions \code{table} and \code{figure} call 
#' \code{\link{md_table}} and \code{\link{md_figure}} respectively; additional
#' arguments are passed on to those functions. Other filter functions ignore the 
#' additional arguments. 
#'
#' @rdname output_fun
#' @export
#' 
table <- function(code, language = "R", id = "",  ...) {
  tab <- source(exprs = str2expression(code), echo = FALSE)
  md_table(tab$value, as_character = TRUE, ...)
}


#' @rdname output_fun
#' @export
#' 
figure <- function(code, language = "R", id = "", ...) {
  expr <- str2expression(code)
  md_figure(expr, as_character = TRUE, ...)
}


#' @rdname output_fun
#' @export
#' 
eval <- function(code, language = "R", id = "", echo = TRUE, 
    results = TRUE, ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = echo, print.eval = results)
  )
  res <- paste0(res, collapse="\n")
  markdown_block(res, language, id, ...)
}


#' @rdname output_fun
#' @export
#' 
raw <- function(code, language = "R", id = "", ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = FALSE)
  )
  res <- paste0(res, collapse="\n")
  raw_block(res)
}

#' @rdname output_fun
#' @export 
#' 
str <- function(code, languare = "R", id = "", ...) {
  res <- source(exprs = str2expression(code), echo = FALSE)
  res <- paste0(as.character(res$value), collapse="\n")
  str_block(res)
}

