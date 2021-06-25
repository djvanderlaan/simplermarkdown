
#' @export
#' 
weave <- function(fn, ofn = paste0(fn, ".md")) {
  script <- system.file("scripts/filter.R", package = "simplermarkdown")
  cmd <- sprintf('pandoc -s "%s" --filter "%s" -o "%s"', 
    fn, script, ofn)
  system(cmd)
}
