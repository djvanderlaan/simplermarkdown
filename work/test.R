library(devtools)
document()
load_all()

system("pandoc -s work/test.md -t json > work/test.json")

dta <- rjson::fromJSON(file = "work/test.json", simplify = FALSE)

sapply(dta$blocks, function(c) c$t)

dta$blocks[[2]]

block <- dta$blocks[[3]]

sapply(block$c, function(c) c$t)
block$c[[3]]
block$c[[1]]
block$c[[9]]
block$c[[11]]

types <- c("Emph", "Para", "Plain")

blocks <- dta$blocks[[3]]$c

str_block <- function(content) {
  list(
    t = "Str",
    c = as.character(content)
  )
}

#' @export 
#' 
str <- function(code, languare = "R", id = "", ...) {
  res <- source(exprs = str2expression(code), echo = FALSE)
  res <- paste0(as.character(res$value), collapse="\n")
  str_block(res)
}


parse_blocks <- function(blocks) {
  for (i in seq_along(blocks)) {
    block <- blocks[[i]]
    cat("===", i, "\n")
    print(block$t)
    if (block$t == "Code") {
      b <- get_block(block)
      print(b)
      message(block$c[[2]])
      if (!is.null(b) && b$language == "R") {
        message("Evaluating code")
        block <- do.call(str, list(code = b$code, id = b$id, language = b$language))
      }
      #print(get_block(block))
    } else if (block$t == "Header") {
      block$c[[3]] <- parse_blocks(block$c[[3]])
    } else if (block$t == "BulletList") {
      for (j in seq_along(block$c)) {
        block$c[[j]] <- parse_blocks(block$c[[j]])
      }
    } else if (block$t == "OrderedList") {
      for (j in seq_along(block$c[[2]])) {
        block$c[[2]][[j]] <- parse_blocks(block$c[[2]][[j]])
      }
    } else if (block$t %in% types) {
      block$c <- parse_blocks(block$c)
    } 
    blocks[[i]] <- block
  }
  blocks
}

tmp <- parse_blocks(dta$blocks)

get_block

get_block(dta$blocks[[3]]$c[[9]])
