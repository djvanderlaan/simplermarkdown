

#' @export
#' 
filter_pandoc_json_tree <- function(con) {
  if (missing(con)) {
    con <- file("stdin")
    input <- readLines(con, warn = FALSE)
    close(con)
    dta <- rjson::fromJSON(input, simplify = FALSE)
  } else {
    dta <- rjson::fromJSON(file = con, simplify = FALSE)
  }
  default_fun = "eval"
  
  # Go over all of the blocks in the tree; check if they contain R code and
  # evaluate the code
  new_dta <- dta
  for (i in seq_along(dta$blocks)) {
    block <- get_block(dta$blocks[[i]])
    if (!is.null(block) && block$language == "R") {
      if (exists("fun", block$arguments)) {
        fun <- block$arguments$fun 
        block$arguments$fun <- NULL
      } else {
        fun <- default_fun
      }
      res <- do.call(fun, c(
        list(code = block$code, id = block$id, language = block$language),
        block$arguments
      ))
      new_dta$blocks[[i]] <- if (is.character(res)) raw_block(res) else res
    }
  }
  new_dta
}
