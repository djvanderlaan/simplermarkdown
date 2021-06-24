
source("R/get_block.R")
source("R/raw_block.R")
source("R/markdown_block.R")


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

md_figure <- function(expr, name, caption = "", dir = "figures", 
    device = c("png", "pdf"), as_character = FALSE, ...) {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  device <- match.arg(device)
  extension <- ""
  if (device == "png") { 
    fn <- file.path(dir, paste0(name, ".png"))
    png(fn, ...)
  } else if (device == "pdf") { 
    fn <- file.path(dir, paste0(name, ".pdf"))
    pdf(fn, ...)
  }
  on.exit(dev.off())
  res <- capture.output(
    source(exprs = expr, echo = FALSE)
  )
  if (as_character) {
    paste0("\n![", caption, "](", fn, ")\n")
  } else {
    cat("\n![", caption, "](", fn, ")\n", sep = "")
  }
  
}


table <- function(code, language = "R", id = "", caption = "", ...) {
  tab <- source(exprs = str2expression(code), echo = FALSE)
  md_table(tab$value, caption = caption, as_character = TRUE, ...)
}


figure <- function(code, language = "R", id = "", name, caption = "", 
    dir = "figures", device = c("png" ,"pdf"), ...) {
  expr <- str2expression(code)
  md_figure(expr, name = name, caption = caption, dir = dir, device = device, 
    as_character = TRUE, ...)
}


eval <- function(code, language = "R", id = "", echo = TRUE, 
    results = TRUE, ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = echo, print.eval = results)
  )
  res <- paste0(res, collapse="\n")
  markdown_block(res, language, id, ...)
}


raw <- function(code, language = "R", id = "", ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = FALSE)
  )
  res <- paste0(res, collapse="\n")
  raw_block(res)
}








# dta <- rjson::fromJSON(file = "foo2.json", simplify = FALSE)
# 
# dta$blocks[[6]]
# 
# 
# 
# 
# 
# 
# get_block(dta$blocks[[4]])
# get_block(dta$blocks[[6]])
# 
# 
# 
# 
# default_fun = "eval"
# 
# block <- dta$blocks[[4]]
# block <- get_block(block)
# if (block$language != "R") stop()
# 
# fun <- if (exists("fun", block$arguments)) block$arguments$fun else default_fun
# 
# do.call(fun, c(
#     list(code = block$code, id = block$id, language = block$language),
#     block$arguments
#   ))
# 
# 



# Read pandoc parse tree from stdin
# con <- file("stdin")
# input <- readLines(con, warn = FALSE)
# close(con)
# dta <- rjson::fromJSON(input, simplify = FALSE)


system("pandoc -s foo2.md -t json > foo2.json")
# dta <- rjson::fromJSON(file = "foo2.json", simplify = FALSE)

process <- function(con) {
  dta <- rjson::fromJSON(file = con, simplify = FALSE)
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

new_dta <- process("foo2.json")  
writeLines(rjson::toJSON(new_dta), con = "foo2_proc.json")

system("pandoc -s foo2_proc.json -o foo2_proc.md")
system("pandoc -s foo2_proc.md -o foo2.pdf")
system("pandoc -s foo2_proc.md -o foo2.html")
