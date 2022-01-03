#' Run the code in a markdown file and generate a new markdown file
#'
#' @param fn filename of the markdown file (should use pandoc markdown).
#' @param ofn name of the resulting markdown file.
#' @param cmd1 command used to run pandoc. See details. 
#' @param cmd2 command used to run pandoc. See details. 
#' @param ... ignored
#'
#' @details
#' \code{mdweave} calls pandoc twice. In the first call the markdown file is
#' parsed by pandoc and the parse tree is written to a temporary file. This
#' parse tree is the read by mdweave and any R-code in the tree is executed
#' resulting in a modified parse tree. This file is then stored to a new
#' temporary file. Pandoc is the called a second time to convert the new
#' parse tree to a markdown file. 
#'
#' The arguments \code{cmd1} and \code{cmd2} contain the calls used to run 
#' pandoc. The arguments can be used to, for example pas additional arguments
#' to pandoc. They use positional arguments. In \code{cmd1}, the first argument
#' (\code{%1$s}) is the input file name and the second (\code{%2$s}) the 
#' temporary file containing the parsed tree. In \code{cmd2}, the first argument
#' is the temporary file with the modified parse tree and the second argument
#' the output file.
#'
#' @return
#' Returns the file name of the file generated (\code{ofn}). Called mainly for the
#' side effect of parsing and generating a markdown file (and possibly secondary
#' files such as figures).
#'
#' @export
#' 
mdweave <- function(fn, ofn = file_subs_ext(basename(fn), ".md", FALSE), 
    cmd1 = 'pandoc -s "%1$s" -t json -o "%2$s"', 
    cmd2 = 'pandoc -s "%1$s" -t markdown -o "%2$s"', ...) {
  # Check if output filename does nog conflict with input filename
  if (ofn == fn) stop("Output file (ofn) would overwrite input file (fn). ", 
      "Specify another output filename (ofn).")
  # Convert markdown to a parse tree in json
  tmp_ofn <- tempfile(fileext = ".json")
  cmd1 <- sprintf(cmd1, fn, tmp_ofn)
  run_cmd(cmd1, paste0("Failed to parse the markdown document to JSON (cmd1). ",  
    "This probably means that the input markdown document contains errors. ", 
    "The command was '%3$s'." ))
  # Set environment variable with location of output file
  # Possibly needed for filters to know where to put output
  # files such as figures
  outputdir <- dirname(ofn)
  dir.create(outputdir, recursive = TRUE, showWarnings = FALSE)
  Sys.setenv(MDOUTDIR = outputdir)
  on.exit(Sys.unsetenv("MDOUTDIR"))
  # Filter json (run R code in json) and save result
  dta <- filter_pandoc_json_tree(tmp_ofn)
  tmp_ifn <- tempfile(fileext = ".json")
  writeLines(rjson::toJSON(dta), tmp_ifn)
  # Convert json back to markdown
  cmd2 <- sprintf(cmd2, tmp_ifn, ofn)
  run_cmd(cmd2, paste0("Failed to convert the processed JSON file back to ", 
    "markdown (cmd2). Either on of the output functions contains an error ",
    "or simplermarkdown has written invalid JSON. ",
    "The command was '%3$s'." ))
  # Cleanup; an earlier version used on.exit for this; currrent solution has the 
  # advantage that in case of an error the old file are not deleted and can be
  # used for debugging
  file.remove(tmp_ofn)
  file.remove(tmp_ifn)
  # Return filename of the final file 
  invisible(ofn)
}

run_cmd <- function(cmd, error_msg = "Failed to run '%1$s'; failed with status %2$d") {
  command <- gsub("^([a-zA-Z0-9]+) (.*)$", "\\1", cmd)
  args <- gsub("^([a-zA-Z0-9]+) (.*)$", "\\2", cmd)
  suppressWarnings({
    status <- system2(command, args)
  })
  if (status != 0) {
    if (status == 127) {
      stop("Running '", command, "' had status 127; this generally means that ",
        "'", command, "' could not be found. Make sure '", command, 
        "' in on the path.")
    } else {
      stop(suppressWarnings(sprintf(error_msg, command, status, cmd)))
    }
  }
}

