#' Generate a figure and generate the markdown to include the figure
#'
#' Will evaluate the expressions in \code{expr} and capture the output on the
#' given plotting device in the given file. It will then generate the markdown
#' needed to include that figure in a markdown document.
#'
#' @param expr the expressions to evaluate. Will generally contain plotting 
#'   commands. The expressions are evaluated in the global environment.
#' @param name the name of the figure. 
#' @param caption text of the caption. When omitted no caption is added to the
#'   figure.
#' @param id id of the figure. When omitted or equal to NULL or an empty 
#'   character, no id is added to the figure.
#' @param dir name of the directory in which to store the file. 
#' @param device the graphics device to use for creating the image.
#' @param ... passed on to the graphics device. 
#' @param as_character return the figure as a character vector. If \code{FALSE}
#'   the figure will be written to the standard output. 
#' @param echo the code in \code{code} is repeated in the output. 
#' @param results include the results of running the code in the output. The 
#'   output of code that explicitly writes to standard output is always 
#'   included.
#'
#' @details
#' The image is stored in the file \code{dir/name.device}. 
#'
#' @return
#' When \code{as_character = FALSE} a character vector with the markdown needed
#' to include the generated figure in a markdown file is returned. Otherwise, 
#' nothing is returned; the markdown is written to the console.
#' 
#' @export
#' 
md_figure <- function(expr, name, caption = "", id = "",
    dir = file.path(Sys.getenv("MDOUTDIR", "."), "figures"), 
    device = c("png", "pdf"), ...,
    as_character = FALSE, echo = FALSE, results = FALSE) {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  device <- match.arg(device)
  extension <- ""
  if (device == "png") { 
    fn <- file.path(dir, paste0(name, ".png"))
    grDevices::png(fn, ...)
  } else if (device == "pdf") { 
    fn <- file.path(dir, paste0(name, ".pdf"))
    grDevices::pdf(fn, ...)
  }
  on.exit(grDevices::dev.off())
  # in order to handle both md_figure(plot(1:10) and 
  # md_figure(str2expression("plot(1:10)"))
  expr <- if (is.expression(expr) || is.character(expr)) expr else 
    as.expression(substitute(expr))
  res <- run_and_capture(expr, results = results, echo = echo)
  res <- format_traditional(res)
  res <- paste0(res, collapse="\n")
  # Check if, besides a figure, we also need to add the commands and
  # other output to the output
  if (echo || results) {
    res <- paste0(c("\n```", res, "```\n"), collapse = "\n")
  } else res <- character(0)
  # Generate the markdown for the figure
  id_str <- if (!is.null(id) && id != "") 
    id_str <- paste0("{#", id, "}") else id_str = ""
  res <- paste0(res, "\n![", caption, "](", fn, ")", id_str, "\n")
  if (as_character) {
    res
  } else {
    cat(res)
  }
}

