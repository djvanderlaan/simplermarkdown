
#' @export
#' 
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
