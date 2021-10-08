# mdweave a couple of documents and check if the output is the
# same as the corresponding reference documents


# We only want to check if the output of mdweave matches the reference if the
# pandoc version matches that which generated the reference. Otherwise there
# is a large chance that the output does not match
pandoc_version <- system("pandoc --version", intern = TRUE)
correct_pandoc_version <- c("pandoc 2.5",
  "Compiled with pandoc-types 1.17.5.4, texmath 0.11.2.2, skylighting 0.7.7")
is_correct_pandoc_version <- all(pandoc_version[1:2] == correct_pandoc_version)

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

message("Check if result generated")
stopifnot(file.exists(md))

if (is_correct_pandoc_version) {
  message("Compare to reference")
  lines <- readLines(md)
  fn_ref <- system.file(file.path("examples_output", md), 
    package = "tinymarkdown")
  lines_ref <- readLines(fn_ref)
  print(all.equal(lines, lines_ref))
  system(paste0("diff ", md, " ", fn_ref))
  writeLines(lines)
  stopifnot(isTRUE(all.equal(lines, lines_ref)))
}

message("Check images")
# We don't check if the images are exactly the same; this probably 
# depends on the exact output device used; versions etc.
stopifnot(file.exists("figures/iris.png"))

message("Cleanup")
#unlink(md)
unlink("figures")

# =============================================================================
message("Checking example1.md")
md <- "example1.md"

message("Weave file")
fn <- system.file(file.path("examples", md), package = "tinymarkdown")
mdweave(fn)

message("Check if result generated")
stopifnot(file.exists(md))

if (is_correct_pandoc_version) {
  message("Compare to reference")
  lines <- readLines(md)
  fn_ref <- system.file(file.path("examples_output", md), 
    package = "tinymarkdown")
  lines_ref <- readLines(fn_ref)
  print(all.equal(lines, lines_ref))
  system(paste0("diff ", md, " ", fn_ref))
  stopifnot(isTRUE(all.equal(lines, lines_ref)))
}

message("Check images")
# We don't check if the images are exactly the same; this probably 
# depends on the exact output device used; versions etc.
stopifnot(file.exists("figures/foo.png"))
stopifnot(file.exists("figures/test.pdf"))

message("Cleanup")
unlink(md)
unlink("figures")


Sys.setenv("R_TESTS" = old_env)

