library(simplermarkdown)

# -----------------------------------------------------------------------------
src <- "a <- 1"

r <- run_and_capture(src)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 1)
stopifnot(isTRUE(all.equal(r[[1]]$input, src)))
stopifnot(length(r[[1]]$output) == 0)

r <- run_and_capture(src, echo = FALSE)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 0)

# -----------------------------------------------------------------------------
src <- "a <- 1\na"

r <- run_and_capture(src)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 2)
stopifnot(isTRUE(all.equal(r[[1]]$input, "a <- 1")))
stopifnot(length(r[[1]]$output) == 0)
stopifnot(isTRUE(all.equal(r[[2]]$input, "a")))
stopifnot(isTRUE(all.equal(r[[2]]$output, "[1] 1")))

r <- run_and_capture(src, echo = FALSE)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 1)
stopifnot(isTRUE(all.equal(r[[1]]$input, character(0))))
stopifnot(isTRUE(all.equal(r[[1]]$output, "[1] 1")))

r <- run_and_capture(src, results = FALSE)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 2)
stopifnot(isTRUE(all.equal(r[[1]]$input, "a <- 1")))
stopifnot(length(r[[1]]$output) == 0)
stopifnot(isTRUE(all.equal(r[[2]]$input, "a")))
stopifnot(length(r[[2]]$output) == 0)

r <- run_and_capture(src, echo = FALSE, results = FALSE)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(length(r) == 0)
stopifnot(is.list(r))

# -----------------------------------------------------------------------------
src <- ""
r <- run_and_capture(src)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(is.list(r) && length(r) == 0)

# -----------------------------------------------------------------------------
src <- character(0)
r <- run_and_capture(src)
stopifnot(isTRUE(all.equal(attr(r, "code"), src)))
stopifnot(is.list(r) && length(r) == 0)

