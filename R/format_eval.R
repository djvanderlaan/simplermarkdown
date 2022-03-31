
format_traditional <- function(x) {
  res <- lapply(x, function(o) {
    if (length(o$input)) {
      f <- rep("+ ", length(o$input))
      f[1] <- "> "
      input <- paste0(f, o$input)
    } else input <- character(0)
    output <- o$output
    c(input, output)
  }) 
  paste0(unlist(res), collapse="\n")
}


format_copypaste <- function(x) {
  res <- lapply(x, function(o) {
    input <- if (length(o$input)) o$input else character(0)
    output <- if (length(o$output))  
      output <- paste0("## ", o$output) else character(0)
    c(input, output)
  }) 
  paste0(unlist(res), collapse="\n")
}

