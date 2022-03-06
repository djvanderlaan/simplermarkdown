
#' Run code and capture the output
#'
#' @param code character vector with the code to run
#' @param echo the code in \code{code} is repeated in the output. 
#' @param results include the results of running the code in the output. 
#' @param output include output that is explicitly written to the output, for 
#'   example using \code{print} statements.
#'
#' @return
#' Returns a list. Each item of the list contains a list with elements
#' \code{input} and \code{output}. \code{input} contains the command/code and
#' \code{output} the corresponding output. These are empty vectors when there is
#' no output or when input and output are suppressed using one of the
#' \code{echo}/\code{results}/\code{output} statements.
#'
#' @export
#' 
run_and_capture <- function(code, echo = TRUE, results = TRUE, output = results) {
  # Setup for running the code
  prompts <- list(prompt = "simplermarkdown1", 
      continue = "simplermarkdown2")
  # Run the code and capture the output
  outp <- utils::capture.output(
    source(textConnection(code), echo = echo, spaced = FALSE,
      print.eval = results, max.deparse.length = Inf, 
      prompt.echo = prompts$prompt,
      continue.echo = prompts$continue)
  )
  # Convert the output to something structured
  # Remove empty first line
  if (length(outp) && outp[1] == "") outp <- utils::tail(outp, -1)
  # Split into separate commands with its output
  regexp <- paste0("^", prompts$prompt)
  outp <- split(outp, cumsum(grepl(regexp, outp)))
  # For each separate command convert to a list with the command and
  # output separated.
  res <- lapply(outp, function(o) {
    regexp <- paste0("^(", prompts$prompt, "|", 
      prompts$continue, ")")
    commands <- grepl(regexp, o)
    input <- gsub(regexp, "", o[commands])
    list(input = input, output = o[!commands])
  })
  # When there are explicit print statements these are still included 
  # in the output; remove
  if (!output) {
    res <- lapply(res, function(o) {
      o$output <- character(0)
      o
    })
  }
  structure(res, code = code)
}

