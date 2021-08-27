
#' Replace file extension by another file extension
#'
#' @param fn character vector with file names
#' @param new_ext character vector of length one with the new extension (when
#'   it does not start with a period a period is added).
#' @param check check if the new file name is not equal to the original 
#'   filename. If so, generate an error.
#'
#' @export
file_subs_ext <- function(fn, new_ext, check = TRUE) {
  if (substr(new_ext, 1, 1) != ".") new_ext <- paste0(".", new_ext)
  newfn <- paste0(tools::file_path_sans_ext(fn), new_ext);
  if (check && any(newfn == fn))
    stop("fn already has extension '", new_ext, "'.")
  newfn
}

