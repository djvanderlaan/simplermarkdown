
#' Return a raw chunk of text that can be included in the pandoc parse tree
#'
#' @param content a character vector containing the content to include
#'   in the final document.
#' @param language language of the content 
#'
#' @details
#' A raw block is included as is into the final markdown document. This can
#' be used for example to include raw chunks of markdown.
#'
#' @return 
#' Returns a \code{list} with the correct structure for a \code{RowBlock} in 
#' the pandoc parse tree.
#'
#' @export
raw_block <- function(content, language = "markdown") {
  list(
    t = "RawBlock", 
    c = list(language, paste0(content, collapse="\n"))
  )
}

