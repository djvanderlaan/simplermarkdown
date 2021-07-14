
#' Return a raw object that can be included in the pandoc parse tree
#'
#' @param content a character vector containing the content to include
#'   in the final document.
#' @param language language of the content 
#'
#' @details
#' A raw block is included as is into the final markdown document. This can
#' be used for example to include raw chunks of markdown.
#'
#' @export
#'
raw_block <- function(content, language = "markdown") {
  list(
    t = "RawBlock", 
    c = list(language, paste0(content, collapse="\n"))
  )
}
