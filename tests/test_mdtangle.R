# mdtangle a couple of documents and check if the output is the
# same as the corresponding reference documents

library(simplermarkdown)

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
r <- "iris.R"

message("Tangle file")
fn <- system.file(file.path("examples", md), package = "simplermarkdown")
mdtangle(fn)

message("Compare to reference")
lines <- readLines(r)
fn_ref <- system.file(file.path("examples_output", r), 
  package = "simplermarkdown")
lines_ref <- readLines(fn_ref)
stopifnot(isTRUE(all.equal(lines, lines_ref)))

message("Cleanup")
unlink(r)

# =============================================================================
message("Checking example1.md")
md <- "example1.md"
r <- "example1.R"

message("Tangle file")
fn <- system.file(file.path("examples", md), package = "simplermarkdown")
mdtangle(fn)

message("Compare to reference")
lines <- readLines(r)
fn_ref <- system.file(file.path("examples_output", r), 
  package = "simplermarkdown")
lines_ref <- readLines(fn_ref)
stopifnot(isTRUE(all.equal(lines, lines_ref)))

message("Cleanup")
unlink(r)


Sys.setenv("R_TESTS" = old_env)

