


get_block <- function(block) {
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
    if (val == "true") { 
      val <- TRUE 
    } else if (val == "false") {
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
        list(id),
        list(language)
      ),
      content
    )
  )
}






eval <- function(code, language = "R", id = "", ...) {
  res <- capture.output(
    source(exprs = str2expression(code), echo = TRUE)
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








dta <- rjson::fromJSON(file = "foo.json", simplify = FALSE)

dta$blocks[[6]]






get_block(dta$blocks[[4]])
get_block(dta$blocks[[6]])




default_fun = "eval"

block <- dta$blocks[[4]]
block <- get_block(block)
if (block$language != "R") stop()

fun <- if (exists("fun", block$arguments)) block$arguments$fun else default_fun

do.call(fun, list(code = block$code, id = block$id, language = block$language))








i <- 6
get_arguments(dta$blocks[[i]]$c[[1]][[3]])
 


get_arguments <- function(arguments) {
  sapply(arguments, function(a) {
    val <- a[[2]]
    if (val == "true") { 
      val <- TRUE 
    } else if (val == "false") {
      val <- FALSE
    } else if (grepl("^[0-9]+$", val)) {
      val <- as.numeric(val)
    }
    res <- list(val)
    names(res) <- a[[1]]
    res
  })
}

