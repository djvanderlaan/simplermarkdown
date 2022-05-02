#' Output filters for code blocks in markdown
#'
#' @param code character vector containing the code of the code block
#' @param language the language in which the code is written (as specified in 
#'   the markdown file).
#' @param id the identifier of the code block.
#' @param ... additional arguments specified as arguments in the code block are
#'   passed on to the filter function. Often these are ignored, or they are 
#'   passed on to other functions (see 'Details').
#' @param echo the code in \code{code} is repeated in the output. 
#' @param results include the results of running the code in the output. The 
#'   output of code that explicitly writes to standard output is always 
#'   included.
#' @param drop_empty do not include any output if the resulting code block 
#'   would be empty.
#' @param cmd the command to use in the \code{\link{system2}} call. Only needed
#'   when different than the language. 
#' @param comment_char string prepended to output of commands run by
#'   \code{output_shell}.
#'
#' @details
#' The filter functions \code{output_table} and \code{output_figure} call 
#' \code{\link{md_table}} and \code{\link{md_figure}} respectively; additional
#' arguments are passed on to those functions. Other filter functions ignore the 
#' additional arguments. 
#'
#' It is also possible to write custom output filter. An output filter should have
#' \code{code}, \code{language} and \code{id} as its first three arguments. It 
#' should either return a character vector containing the markdown that should be
#' included in the resulting markdown file or an object that can be directly 
#' included in the pandoc parse tree. If the function does not return a character
#' vector it is assumed the latter is returned. \code{simplermarkdown} defines a
#' small number of valid object constructors: \code{\link{raw_block}} and
#' \code{\link{markdown_block}}.
#'
#' The custom function should be available when running the markdown document
#' through pandoc. The easiest way is to \code{\link{source}} or define the 
#' function in the markdown document before using it. 
#'
#' The filter function \code{output_shell} can be used to process chunks of code
#' from other languages than R. These chunks of code are written to a temporary
#' file which is then ran using the \code{cmd} using a call to
#' \code{\link{system2}}. The output of that is captured and when \code{results
#' = TRUE} included in the output. The output lines are prepended by
#' \code{comment_char}. When \code{echo = TRUE} the code is also included before
#' the output.
#'
#' @return
#' The functions either return a character vector with markdown,  
#' or return a list with the correct structure to include in the pandoc parse 
#' tree. 
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
  md_figure(code, as_character = TRUE, id = id, ...)
}


#' @rdname output_fun
#' @export
#' 
output_eval <- function(code, language = "R", id = "", echo = TRUE, 
    results = TRUE, drop_empty = TRUE, ...) {
  #res <- utils::capture.output(
  #  source(textConnection(code), echo = echo, print.eval = results, 
  #    max.deparse.length = Inf)
  #)
  #if (echo && length(res) >= 1 && res[1] == "") res <- utils::tail(res, -1)
  res <- run_and_capture(code, results = results, echo = echo)
  res <- format_traditional(res)
  res <- paste0(res, collapse="\n")
  if (drop_empty) {
    # Check if we have only empty lines or no lines at all; in that case
    # return empty markdown
    empty_output <- (length(res) == 0) || all((grepl("^[[:blank:]]*$", res)))
    if (empty_output) return(raw_block(""))
  }
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

#' @rdname output_fun
#' @export 
#' 
output_shell <- function(code, language, id = "", cmd = language,
    echo = TRUE, results = TRUE, comment_char = "# ", ...) {
  fn <- tempfile()
  writeLines(code, fn)
  on.exit(file.remove(fn))
  res <- system2(cmd, fn, stdout = TRUE, stderr = TRUE)
  input <- if (echo) paste0(code, collapse = "\n") else NULL
  output <- if (results) paste0("# ", res, collapse = "\n") else NULL
  markdown_block(paste0(c(input, output), collapse = "\n\n"), language, ...)
}

