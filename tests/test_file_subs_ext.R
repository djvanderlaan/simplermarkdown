
library(simplermarkdown)


stopifnot(file_subs_ext("foo.R", "pdf") == "foo.pdf")
stopifnot(file_subs_ext("foo.R", ".pdf") == "foo.pdf")
stopifnot(file_subs_ext("foo.R.foo", ".pdf") == "foo.R.pdf")
stopifnot(file_subs_ext("c:/foo/bar/foo.R", ".pdf") == "c:/foo/bar/foo.pdf")
stopifnot(file_subs_ext("foo", "pdf") == "foo.pdf")
stopifnot(file_subs_ext("", "pdf") == ".pdf")
stopifnot(file_subs_ext(c("foo.R", "foo", "bar/foo.bar"), "pdf") == c("foo.pdf", "foo.pdf", "bar/foo.pdf"))

# Replace with same extension
err <- TRUE
try({
  res <- file_subs_ext("foo.R", ".R")
  err <- FALSE
}, silent = TRUE)
stopifnot(err)
stopifnot(file_subs_ext("foo.R", ".R", check = FALSE) == "foo.R")




