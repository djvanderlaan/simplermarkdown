
get_block <- function(block) {
  if (block$t != "CodeBlock" && block$t != "Code") return(NULL)
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


