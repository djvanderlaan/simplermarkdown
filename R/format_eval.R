

#' Format the result of running a block of code
#'
#' @param x the result of running the code. See 'details' for the format.
#'
#' @details
#' The input vector \code{x} should be a list. Each element of this list should
#' be a list with two elements: \code{input} and \code{output}. \code{input}
#' should contain the evaluated expression; this can be more than one line.
#' \code{output} should contain the output of the evaluation. When there is no
#' output this is character vector of length 0.
#'
#' @return
#' A character vector of length 1 with the formatted code.
#' 
#' @export
#' @rdname format
#'
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


#' @export
#' @rdname format
#'
format_copypaste <- function(x) {
  res <- lapply(x, function(o) {
    input <- if (length(o$input)) o$input else character(0)
    output <- if (length(o$output))  
      output <- paste0("## ", o$output) else character(0)
    c(input, output)
  }) 
  paste0(unlist(res), collapse="\n")
}

