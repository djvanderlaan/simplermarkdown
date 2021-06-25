


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
