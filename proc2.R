
  
get_arguments <- function(arguments) {
  sapply(arguments, function(a) {
    val <- a[[2]]
    if (val == "true") { 
      val <- TRUE 
    } else if (val == "false") {
      val <- FALSE
    } else if (grepl("^[0-9]+$", val)) {
      val <- as.numeric(val)
    }
    res <- list(val)
    names(res) <- a[[1]]
    res
  })
}


md_table <- function(tab, caption) {
  res <- vector("list", ncol(tab))
  for (i in seq_along(res)) {
    t <- format(tab[[i]])
    t <- format(c(names(tab)[i], t))
    nc <- max(nchar(t))
    line <- paste0(rep("-", nc), collapse ="")
    t <- c(t[1], line, tail(t, -1))
    res[[i]] <- t
  }
  res <- do.call(paste, c("", res, "", sep = "|"))
  if (!missing(caption) && !is.null(caption)) {
    res <- c(paste0(": ", caption), "", res)
  }
  writeLines(res)
}

md_figure <- function(expr, name, caption = "", dir = "figures") {
  fn <- file.path(dir, paste0(name, ".png"))
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  png(fn)
  on.exit(dev.off())
  expr
  cat("\n![", caption, "](", fn, ")\n", sep = "")
}


?str2expression

foo <- function(expr) {
  s <- substitute(expr)
  if (s[[1]] == 
}

q <- foo({
  1+1
  # COMMENT
  a <- 1+2
  if (a == 3) {
    print(a)
  }
})

deparse(expression({
  a <- 1
  # FOO
  b <- 1+a
}))

md_code_example <- function(expr, 
    output = c("code", "code_result", "result", "console")) {
      
}

sexpr <- c(
  "a <- 1+1", "a", "b <- a+1", "b", "head(iris, 5)")

expr <- str2expression(sexpr)  
res <- capture.output(
  source(exprs = expr, echo = FALSE, print.eval = TRUE)
)

writeLines(c("\n```{.R}", sexpr, "```\n"))

writeLines(c("\n```{.R}", paste0("## ", res), "```\n"))


# Script ------------------------------------------------------------------



con <- file("stdin")
input <- readLines(con, warn = FALSE)
close(con)
dta <- rjson::fromJSON(input, simplify = FALSE)

#dta <- rjson::fromJSON(file = "foo.json", simplify = FALSE)

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
      
      
      arguments <- get_arguments(dta$blocks[[i]]$c[[1]][[3]])
      
      if (!is.null(arguments$raw) && arguments$raw) {
        res <- capture.output(
          source(exprs = str2expression(code[[ncode]]), echo = FALSE)
        )
        res <- paste0(res, collapse="\n")
        new_dta$blocks[[i]] <- list(
          t = "RawBlock", 
          c = list("markdown", res)
        )
      } else {
        # Evaluate code
        res <- capture.output(
          source(exprs = str2expression(code[[ncode]]), echo = TRUE)
        )
        res <- paste0(res, collapse="\n")
        new_dta$blocks[[i]]$c[[2]] <- res
      }
    }
  }
}

writeLines(rjson::toJSON(new_dta))

