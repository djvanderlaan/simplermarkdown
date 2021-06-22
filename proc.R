
con <- file("stdin")
input <- readLines(con, warn = FALSE)
close(con)
# dta <- rjson::fromJSON(file = "foo.json", simplify = FALSE)
dta <- rjson::fromJSON(input, simplify = FALSE)
new_dta <- dta

code <- list()
ncode <- 0

for (i in seq_along(dta$blocks)) {
  if (dta$blocks[[i]]$t == "CodeBlock") {
    id <- dta$blocks[[i]]$c[[1]][[1]]

    language <- if (length(dta$blocks[[i]]$c[[1]][[2]]))
      dta$blocks[[i]]$c[[1]][[2]][[1]] else ""
    if (language == "R") {
      ncode <- ncode+1
      code[[ncode]] <- dta$blocks[[i]]$c[[2]]
      
      # Evaluate code
      res <- capture.output(
        source(exprs = str2expression(code[[ncode]]), echo = TRUE)
      )
      res <- paste0(res, collapse="\n")
      new_dta$blocks[[i]]$c[[2]] <- res
    }
  }
}

writeLines(rjson::toJSON(new_dta))



# 
# code[[1]]
# 
# 
# res < capture.output(
#   source(exprs = str2expression(code[[1]]), echo = TRUE)
# )
# res <- paste0(res, collapse="\n")
# 
# 
# capture.output(code[[1]])
# 
# 
# 
# tmp <- rjson::fromJSON(file = "test.json", simplify = FALSE)
# writeLines(rjson::toJSON(tmp), con = "test2.json")
# write_json(tmp, "test2.json")
# readLines("test.json")
# readLines("test2.json")
# 
# tmp <- read_json("test.json")
# write_json(tmp, "test2.json", auto_unbox = TRUE)
# readLines("test.json")
# readLines("test2.json")
# 
# tmp
