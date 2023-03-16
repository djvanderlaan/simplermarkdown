

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
  # parse extra arguments
  extra <- list(...)
  if (!all(names(extra) != ""))
    stop("Additional arguments all need to be named")
  extra <- lapply(extra, \(x) as.character(x)[1])

  list(
    t = "CodeBlock",
    c = list(
      list(
        id,
        list(language),
        extra
      ),
      content
    )
  )
}
