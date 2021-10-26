
has_pandoc <- function() {
  x <- Sys.which("pandoc")
  !is.na(x) && (x != "")
}
