dta <- rjson::fromJSON(file = "foo.json", simplify = FALSE)

dta$blocks[[6]]


proc_block <- function(block) {
  id <- block$c[[1]][[1]]
  language <- if (length(block$c[[1]][[2]]))
    block$c[[1]][[2]][[1]] else ""
  if (language != "R") return(NULL)
  args1 <- if (length(block$c[[1]][[2]]) > 1) {
    tail(unlist(block$c[[1]][[2]]), -1)
  } else character(0L)
  arguments <- get_arguments(block$c[[1]][[3]])
  code <- block$c[[1]][[2]]
  list(
    id = id,
    language = language,
    arguments_single = args1,
    arguments = arguments,
    code = code
  )
}


proc_block(dta$blocks[[4]])
proc_block(dta$blocks[[6]])


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

