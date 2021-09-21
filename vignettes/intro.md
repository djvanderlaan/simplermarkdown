<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to tinymarkdown}
-->
---
title: tinymarkdown
css: "dark.min.css"
---

Introduction
-------------------------

First write a markdown file using 
[pandoc markdown](https://pandoc.org/MANUAL.html#pandocs-markdown).  The package uses pandoc to
parse the markdown and runs any code blocks tagged as being R-code. The result a new markdown file
that can be further processed using pandoc and compiled to, for example, PDF or HTML.

To process your markdown file you can use the `mdweave` function:

```
mdweave("mydocument.md", "mydocument_woven.md")
```

The resulting document `mydocument_woven.md` can then be processes further using
pandoc. 

Below is a ready to run example using an example document in the package:

```
library(tinymarkdown)

example1 <- system.file("examples/example1.md", package = "tinymarkdown")

mdweave(example1, "example1_woven.md")

system("pandoc example1_woven.md -o example1.pdf")
```


## Writing markdown


An example of a basic code block tagged as being R-code is shown below. 
The id/label if the block is `codeblock1`.  

`````
```{#codeblock1 .R}
a <- 1+1
a
```
`````

By default the code in the code block is run and both the code and the output of
the code are shown in the generated new code block. In the resulting output file 
this wil result in

```{#codeblock1 .R}
a <- 1+1
a
```


