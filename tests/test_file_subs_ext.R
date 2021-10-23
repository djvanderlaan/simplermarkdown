library(simplermarkdown)

expect_equal <- function(a, b) {
  stopifnot(isTRUE(all.equal(a,b)))
}

expect_equal(
  file_subs_ext("foo.x", "y"), 
  "foo.y")

expect_equal(
  file_subs_ext(c("foo.x", "bar.z"), "y"), 
  c("foo.y", "bar.y"))

expect_equal(
  file_subs_ext(c(".x", "foo/.bar.z"), "y"), 
  c(".x.y", "foo/.bar.y"))

expect_equal(
  file_subs_ext("", "y"), 
  ".y")
