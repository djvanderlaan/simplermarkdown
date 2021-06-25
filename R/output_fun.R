

#' @export
#' 
table <- function(code, language = "R", id = "",  ...) {
  tab <- source(exprs = str2expression(code), echo = FALSE)
  md_table(tab$value, as_character = TRUE, ...)
}


#' @export
#' 
figure <- function(code, language = "R", id = "", ...) {
  expr <- str2expression(code)
  md_figure(expr, as_character = TRUE, ...)
}


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


#' @export
#' 
raw <- function(code, language = "R", id = "", ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = FALSE)
  )
  res <- paste0(res, collapse="\n")
  raw_block(res)
}

