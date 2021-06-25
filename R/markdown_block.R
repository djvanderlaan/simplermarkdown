

#' @export
#' 
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
