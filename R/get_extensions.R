
#' Get the extensions that are needed when converting from json to markdown by 
#' pandoc.
#'
#' @return 
#' Returns a character vector of the form \code{"+extension1-extension2"} with
#' the extensions that are to be enabled (\code{+}) or disables (\code{-}).
#' The function calls \code{pandoc} to check which extensions are available.
#'
#' @export
get_extensions <- function() {
  extensions <- character(0)
  # Get the list of extensions supported by the installed pandoc
  supported_extensions <- system("pandoc --list-extensions", intern = TRUE)
  # when converting from json to markdown we need to disable the raw_attribute
  # extension. Some of the output functions write raw markdown. With this
  # extension this raw markdown is put into a
  # ```{=markdown}
  # markdown
  # ```
  # block. This is not recognised when converting to other formats.
  has_raw <- any(grepl("^[+-]raw_attribute", supported_extensions))
  if (has_raw) {
    extensions <- paste0(extensions, "-raw_attribute")
  }
  extensions
}

