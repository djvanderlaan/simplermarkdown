

#' Return a code block object that can be included in the pandoc parse tree
#'
#' @param content a character vector containing the code
#' @param language language of the code in the code block
#' @param id optional id of the code block
#' @param ... ignored. 
#'
#' @return 
#' Returns a \code{list} with the correct structure for a code block in 
#' the pandoc parse tree.
#'
#' @export
markdown_block <- function(content, language, id = "", ...) {
  list(
    t = "CodeBlock",
    c = list(
      list(
        id,
        list(language),
        list()
      ),
      content
    )
  )
}
