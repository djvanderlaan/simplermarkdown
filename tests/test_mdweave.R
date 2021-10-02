# mdweave a couple of documents and check if the output is the
# same as the corresponding reference documents

library(tinymarkdown)

# Create tempdir
dir <- tempdir()
dir.create(dir, recursive = TRUE, showWarnings = FALSE)
setwd(dir)

# When running tests the environment variable R_TESTS is set. This
# causes issues when running a second R instance as mdweave does. Therefore
# we unser it.
old_env <- Sys.getenv("R_TESTS")
Sys.setenv("R_TESTS" = "")

# =============================================================================
message("Checking iris.md")
md <- "iris.md"

message("Weave file")
fn <- system.file(file.path("examples", md), package = "tinymarkdown")
mdweave(fn)

message("Compare to reference")
lines <- readLines(md)
fn_ref <- system.file(file.path("examples_output", md), 
  package = "tinymarkdown")
lines_ref <- readLines(fn_ref)
stopifnot(isTRUE(all.equal(lines, lines_ref)))

message("Check images")
# We don't check if the images are exactly the same; this probably 
# depends on the exact output device used; versions etc.
stopifnot(file.exists("figures/iris.png"))

message("Cleanup")
unlink(md)
unlink("figures")

# =============================================================================
message("Checking example1.md")
md <- "example1.md"

message("Weave file")
fn <- system.file(file.path("examples", md), package = "tinymarkdown")
mdweave(fn)

message("Compare to reference")
lines <- readLines(md)
fn_ref <- system.file(file.path("examples_output", md), 
  package = "tinymarkdown")
lines_ref <- readLines(fn_ref)
stopifnot(isTRUE(all.equal(lines, lines_ref)))

message("Check images")
# We don't check if the images are exactly the same; this probably 
# depends on the exact output device used; versions etc.
stopifnot(file.exists("figures/foo.png"))
stopifnot(file.exists("figures/test.pdf"))

message("Cleanup")
unlink(md)
unlink("figures")


Sys.setenv("R_TESTS" = old_env)

