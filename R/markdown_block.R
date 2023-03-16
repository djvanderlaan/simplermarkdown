

#' Return a code block object that can be included in the pandoc parse tree
#'
#' @param content a character vector containing the code
#' @param language language of the code in the code block
#' @param id optional id of the code block
#' @param ... additional arguments should be named. These are added to the
#'   markdown block as additional arguments.
#'
#' @return 
#' Returns a \code{list} with the correct structure for a code block in 
#' the pandoc parse tree.
#'
#' @export
markdown_block <- function(content, language, id = "", ...) {
  # parse extra arguments
  # This should be an unnamed list with each element a 2 element
  # vector; first element the name; second element the value
  extra <- list(...)
  if (!all(names(extra) != ""))
    stop("Additional arguments all need to be named")
  extra <- lapply(extra, \(x) as.character(x)[1])
  extra <- lapply(names(extra), \(x) list(x, extra[[x]]))
  # block
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

