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
#' @param id id of the figure. When omitted or equal to NULL or an empry 
#'   character, no id is added to the figure.
#' @param dir name of the directory in which to store the file. 
#' @param device the graphics device to use for creating the image.
#' @param as_character return the figure as a character vector. If \code{FALSE}
#'   the figure will be written to the standard output. 
#' @param ... passed on to the graphics device. 
#'
#' @details
#' The image is stored in the file \code{dir/name.device}. 
#'
#' @return
#' Then \code{as_character = FALSE} a character vector with the markdown needed
#' to include the generated figure in a markdown file is returned. Otherwise, 
#' nothing is returned; the markdown is then written to the console.
#' 
#' @export
#' 
md_figure <- function(expr, name, caption = "", id = "",
    dir = file.path(Sys.getenv("MDOUTDIR", "."), "figures"), 
    device = c("png", "pdf"), as_character = FALSE, ...) {
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
  res <- utils::capture.output(
    source(exprs = expr, echo = FALSE)
  )
  id_str <- if (!is.null(id) && id != "") 
    id_str <- paste0("{#", id, "}") else id_str = ""
  if (as_character) {
    paste0("\n![", caption, "](", fn, ")", id_str, "\n")
  } else {
    cat("\n![", caption, "](", fn, ")", id_str, "\n", sep = "")
  }
}

