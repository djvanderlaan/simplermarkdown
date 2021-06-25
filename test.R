
library(simplermarkdown)


pandoc_to_pdf <- function(fn, ofn = paste0(fn, ".pdf")) {
  cmd <- sprintf('pandoc "%s" -o "%s"', fn, ofn)
  system(cmd)
}

weave("foo2.md", "foo2_woven.md")
pandoc_to_pdf("foo2_woven.md", "foo2.pdf")


