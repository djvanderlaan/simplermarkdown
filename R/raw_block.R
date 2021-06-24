

raw_block <- function(content, language = "markdown") {
  list(
    t = "RawBlock", 
    c = list(language, paste0(content, collapse="\n"))
  )
}