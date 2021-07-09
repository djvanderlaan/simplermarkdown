library(devtools)
document()
load_all()

system("pandoc -s work/test.md -t json > work/test.json")

dta <- rjson::fromJSON(file = "work/test.json", simplify = FALSE)
foo <- dta

sapply(dta$blocks, function(c) c$t)

dta$blocks[[2]]

block <- dta$blocks[[3]]

sapply(block$c, function(c) c$t)
block$c[[3]]
block$c[[1]]
block$c[[9]]
block$c[[11]]

types <- c("Emph", "Para", "Plain", "BlockQuote")
types_to_ignore <- c("Str", "Space", "Str", "Strong", "Link", "Image", "Table", "SoftBreak")

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


inline_block_number <- 1


evaluate_inline_code <- function(block) {
  b <- get_block(block)
  if (!is.null(b) && b$language == "R") {
    id <- if (b$id == "") "<unlabeled inline block>" else b$id
    message("Evaluating code in inline block '", id, "'.")
    block <- do.call(str, list(code = b$code, id = b$id, language = b$language))
  }
  block
}

evaluate_code_block <- function(block, default_fun = "eval") {
  b <- get_block(block)
  if (!is.null(b) && b$language == "R") {
    id <- if (b$id == "") "<unlabeled code block>" else b$id
    message("Evaluating code in block '", id, "'.")
    if (exists("fun", b$arguments)) {
      fun <- b$arguments$fun 
      b$arguments$fun <- NULL
    } else {
      fun <- default_fun
    }
    res <- do.call(fun, c(
      list(code = b$code, id = b$id, language = b$language), b$arguments))
    if (is.character(res)) raw_block(res) else res
  }
  block
}

parse_blocks <- function(blocks) {
  for (i in seq_along(blocks)) {
    block <- blocks[[i]]
    if (block$t == "Code") {
      block <- evaluate_inline_code(block)
    } else if (block$t == "CodeBlock") {
      block <- evaluate_code_block(block)
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
    } else if (block$t == "Div") {
      block$c[[2]] <- parse_blocks(block$c[[2]])
    } else if (block$t %in% types) {
      block$c <- parse_blocks(block$c)
    } else if (block$t %in% types_to_ignore) {
      # do nothing
    } else {
      warning("Ignoring unsupported block type '", block$t, "'.");
      print(block)
    }
    blocks[[i]] <- block
  }
  blocks
}


tmp <- parse_blocks(foo$blocks)

tmp2 <- dta
tmp2$blocks <- tmp
writeLines(rjson::toJSON(tmp2), "work/test_proc.json")
system("pandoc -s work/test_proc.json -o work/test_proc.md")
system("pandoc -s work/test_proc.md -o work/test_proc.pdf")



foo <- function(i = 0, env) {
  cat(env$bar, "\n")
  env$bar <- env$bar + 1
  if (i > 1) foo(i-1, env)
}
foobar <- function(i = 0) {
  env <- environment()
  env$bar <- 10
  foo(i, env)
}
foobar(2)
