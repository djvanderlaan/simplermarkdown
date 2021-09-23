
library(tinymarkdown)


setwd("inst/examples_output")

mdweave("../examples/iris.md", "iris.md")
mdtangle("../examples/iris.md", "iris.R")

mdweave("../examples/example1.md", "example1.md")
mdtangle("../examples/example1.md", "example1.R")






