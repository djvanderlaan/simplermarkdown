


get_block <- function(block) {
  if (block$t != "CodeBlock") return(NULL)
  id <- block$c[[1]][[1]]
  language <- if (length(block$c[[1]][[2]]))
    block$c[[1]][[2]][[1]] else ""
  if (language != "R") return(NULL)
  args1 <- if (length(block$c[[1]][[2]]) > 1) {
    tail(unlist(block$c[[1]][[2]]), -1)
  } else character(0L)
  arguments <- get_block_arguments(block$c[[1]][[3]])
  code <- block$c[[2]]
  list(
    id = id,
    language = language,
    arguments_single = args1,
    arguments = arguments,
    code = code
  )
}

get_block_arguments <- function(arguments) {
  sapply(arguments, function(a) {
    val <- a[[2]]
    if (val == "TRUE") { 
      val <- TRUE 
    } else if (val == "FALSE") {
      val <- FALSE
    } else if (grepl("^[0-9]+$", val)) {
      val <- as.numeric(val)
    }
    res <- list(val)
    names(res) <- a[[1]]
    res
  })
}



raw_block <- function(content, language = "markdown") {
  list(
    t = "RawBlock", 
    c = list(language, content)
  )
}

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


md_table <- function(tab, caption) {
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
  writeLines(res)
}

md_figure <- function(expr, name, caption = "", dir = "figures") {
  fn <- file.path(dir, paste0(name, ".png"))
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  png(fn)
  on.exit(dev.off())
  expr
  cat("\n![", caption, "](", fn, ")\n", sep = "")
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
con <- file("stdin")
input <- readLines(con, warn = FALSE)
close(con)
dta <- rjson::fromJSON(input, simplify = FALSE)



default_fun = "eval"

# Go over all of the blocks in the tree; check if they contain R code and
# evaluate the code
new_dta <- dta
for (i in seq_along(dta$blocks)) {
  
  block <- get_block(dta$blocks[[i]])
  
  if (!is.null(block) && block$language == "R") {
    fun <- if (exists("fun", block$arguments)) 
      block$arguments$fun else default_fun
    res <- do.call(fun, c(
      list(code = block$code, id = block$id, language = block$language),
      block$arguments
    ))
    new_dta$blocks[[i]] <- res
  }
}

  
writeLines(rjson::toJSON(new_dta), con = "foo2_proc.json")

