
library(simplermarkdown)


example1 <- system.file("examples/example1.md", package = "simplermarkdown")

weave(example1, "example1_woven.md")

system("pandoc example1_woven.md -o example1.pdf")


