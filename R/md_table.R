#' Generate a markdown table from a data.frame
#'
#' @param tab a data frame
#' @param caption text of the caption. When omitted no caption is added to the
#'   table.
#' @param as_character return the table as a character vector. If \code{FALSE}
#'   the table will be written to the standard output. 
#' @param ... unused. 
#'
#' @return
#' Then \code{as_character = FALSE} a character vector with the markdown
#' containing the table is returned.  Otherwise, 
#' nothing is returned; the markdown is then written to the console.
#'
#' @export
#' 
md_table <- function(tab, caption, as_character = FALSE, ...) {
  res <- vector("list", ncol(tab))
  for (i in seq_along(res)) {
    t <- format(tab[[i]])
    t <- format(c(names(tab)[i], t))
    nc <- max(nchar(t))
    line <- paste0(rep("-", nc), collapse ="")
    t <- c(t[1], line, tail(t, -1))
    res[[i]] <- t
  }
  res <- do.call(paste, c("", res, "", sep = "|"))
  if (!missing(caption) && !is.null(caption)) {
    res <- c(paste0(": ", caption), "", res)
  }
  if (as_character) paste0(res, collapse="\n")  else writeLines(res)
}
