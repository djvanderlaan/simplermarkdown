
#' @importFrom rjson fromJSON
#' @export
#' 
filter_pandoc_json_tree <- function(con) {
  if (missing(con)) {
    con <- file("stdin")
    input <- readLines(con, warn = FALSE)
    close(con)
    dta <- rjson::fromJSON(input, simplify = FALSE)
  } else {
    dta <- rjson::fromJSON(file = con, simplify = FALSE)
  }
  default_fun <- "eval"
  verbosity   <- 1
  # Go over all of the blocks in the tree; check if they contain R code and
  # evaluate the code
  dta$blocks <- parse_blocks(dta$blocks, default_fun = default_fun, 
    verbosity = verbosity)
  dta
}


evaluate_inline_code <- function(block, verbosity = 1) {
  b <- get_block(block)
  if (!is.null(b) && b$language == "R") {
    id <- if (b$id == "") "<unlabeled inline block>" else b$id
    if (verbosity > 0) message("Evaluating code in inline block '", id, "'.")
    block <- do.call(str, list(code = b$code, id = b$id, language = b$language))
  }
  block
}

evaluate_code_block <- function(block, default_fun = "eval", verbosity = 1) {
  b <- get_block(block)
  if (!is.null(b) && b$language == "R") {
    id <- if (b$id == "") "<unlabeled code block>" else b$id
    if (verbosity > 0) message("Evaluating code in block '", id, "'.")
    if (exists("fun", b$arguments)) {
      fun <- b$arguments$fun 
      b$arguments$fun <- NULL
    } else {
      fun <- default_fun
    }
    res <- do.call(fun, c(
      list(code = b$code, id = b$id, language = b$language), b$arguments))
    block <- if (is.character(res)) raw_block(res) else res
  }
  block
}



parse_blocks <- function(blocks, verbosity = 1, default_fun = "eval") {
  # The following type can all be handled the same way
  basic_types <- c("Emph", "Para", "Plain", "BlockQuote")
  # In the following types of content we will not look for code blocks and these
  # will nog be processed further
  types_to_ignore <- c("Str", "Space", "Str", "Strong", "Link", "Image", 
    "Table", "SoftBreak")
  # Loop over the blocks and depending on the type process further; when we have
  # a block of R-code we will evaluate the code within it
  for (i in seq_along(blocks)) {
    block <- blocks[[i]]
    if (block$t == "Code") {
      block <- evaluate_inline_code(block, verbosity = verbosity)
    } else if (block$t == "CodeBlock") {
      block <- evaluate_code_block(block, verbosity = verbosity, 
        default_fun = default_fun)
    } else if (block$t == "Header") {
      block$c[[3]] <- parse_blocks(block$c[[3]], verbosity)
    } else if (block$t == "BulletList") {
      for (j in seq_along(block$c)) 
        block$c[[j]] <- parse_blocks(block$c[[j]], verbosity)
    } else if (block$t == "OrderedList") {
      for (j in seq_along(block$c[[2]])) 
        block$c[[2]][[j]] <- parse_blocks(block$c[[2]][[j]], verbosity)
    } else if (block$t == "Div") {
      block$c[[2]] <- parse_blocks(block$c[[2]], verbosity)
    } else if (block$t %in% basic_types) {
      block$c <- parse_blocks(block$c, verbosity)
    } else if (block$t %in% types_to_ignore) {
      # do nothing
    } else {
      # also do nothing but report
      if (verbosity > 1)
        warning("Ignoring unsupported block type '", block$t, "'.");
    }
    blocks[[i]] <- block
  }
  blocks
}

