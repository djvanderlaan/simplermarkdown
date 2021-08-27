library(devtools)
document()
load_all()

system("pandoc -s work/test.md -t json > work/test.json")
dta <- filter_pandoc_json_tree("work/test.json")
writeLines(rjson::toJSON(dta), "work/test_proc.json")

system("pandoc -s work/test_proc.json -o work/test_proc.md")
system("pandoc -s work/test_proc.md -o work/test_proc.pdf")





tmp <- rjson::fromJSON(file = "work/test.json", simplify = FALSE)

default_fun <- "eval"
verbosity   <- 1
# Go over all of the blocks in the tree; check if they contain R code and
# evaluate the code
parse_blocks(tmp$blocks, default_fun = default_fun, 
  verbosity = verbosity, eval_block = gather_code)


fn <- "inst/examples/iris.md"
tmp_ofn <- tempfile(fileext = ".json")
cmd = 'pandoc %3$s -s "%1$s" -o "%2$s"'
extra_arguments = ""
ofn <- "work/test.R"
cmd <- sprintf(cmd, fn, tmp_ofn, extra_arguments)
system(cmd)

code <- mdtangle(tmp_ofn)

file.remove(tmp_ofn)



mdtangle <- function(fn, ofn = paste0(fn, ".md"), 
    extra_arguments = "", cmd = 'pandoc %3$s -s "%1$s" -o "%2$s"') {
  tmp_ofn <- tempfile(fileext = ".json")
  on.exit(file.remove(tmp_ofn))
  cmd <- sprintf(cmd, fn, tmp_ofn, extra_arguments)
  system(cmd)
  dta <- rjson::fromJSON(file = tmp_ofn, simplify = FALSE)
  default_fun <- "eval"
  verbosity   <- 1
  code <- character(0)
  gather_code <- function(block, default_fun = "eval", verbosity = 1) {
    b <- get_block(block)
    if (!is.null(b) && b$language == "R") {
      id <- if (b$id == "") "<unlabeled code block>" else b$id
      if (verbosity > 0) message("Evaluating code in block '", id, "'.")
      code <<- c(code, paste("#", id), b$code, "")
    }
    block
  }
  ignore_inline <- function(block, verbosity = 1)  {
    block
  }
  # Go over all of the blocks in the tree; check if they contain R code and
  # evaluate the code
  dta$blocks <- parse_blocks(dta$blocks, default_fun = default_fun, 
    verbosity = verbosity, eval_block = gather_code, eval_inline = ignore_inline)
  writeLines(code, con = ofn)
}



writeLines(mdtangle("work/test.json"))

writeLines(code)
code



fn <- "inst/examples/iris.md"

fn_path <- dirname(fn)
fn_base   <- basename(tools::file_path_sans_ext(fn))
fn_ext  <- tools::file_ext(fn)


