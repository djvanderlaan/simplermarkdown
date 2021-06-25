simplermarkdown
===============================================================================

## Prerequisites

- Working installation of pandoc with pandoc available in the path. 
- When compiling to pdf, a working installation of LaTeX.
- And, of course, `simplermarkdown` installed.


## Usage

First write a markdown file using pandoc markdown.  The package uses pandoc to
parse the markdown and runs any code blocks tagged as being R-code. The result a
new markdown file that can be further processed using pandoc and compiled to,
for example, PDF or HTML.

To process your markdown file do:

```
weave("mydocument.md", "mydocument_woven.md")
```

The resulting document `mydocument_woven.md` can then be processes further using
pandoc. 

Below is a ready to run example using an example document in the package:

```
library(simplermarkdown)

example1 <- system.file("examples/example1.md", package = "simplermarkdown")

weave(example1, "example1_woven.md")

system("pandoc example1_woven.md -o example1.pdf")
```



## Writing markdown


An example of a basic code block tagged as being R-code is shown below. Note
that I use the `~` here to make it easier to write this example; the `` ` `` 
would also be valid.  The id/label if the block is `codeblock1`.  

```
~~~{#codeblock1 .R}
a <- 1+1
~~~
```

By default the code in the code block is run and both the code and the output of
the code are shown in the generated new code block. Arguments can be used to
suppress either showing the code or the output:

```
~~~{#codeblock1 .R echo=FALSE results=TRUE}
a <- 1+1
~~~
```


### Tables

To generate a table, we tell it to pass the code in the code block to the
function `table` from the `simplermarkdown` package. This function will take the
final result and generate a markdown table from that. Any arguments are passed
on to the `table` function.

```
~~~ {.R fun=table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
~~~
```


### Figures

To generate a figure use the `figure` function. The function will run the code,
capture any output on the specified device and generate a markdown image
include.

```
~~~{.R fun=figure name="test" caption="My figure" device="pdf" width=8 
  height=6}
plot(dta$Sepal.Width, dta$Petal.Width)
~~~
```

### Other output

By using the `raw` filter, any other output can be generated. This function will
run the code, capture any output and put that directly into the resulting
markdown document. For example, to generate a figure you can also use:


```
~~~{.R fun=raw}
md_figure({
plot(dta$Sepal.Length, dta$Petal.Length)
}, name = "foo")
~~~
```

Or you can write your own filter function. This function will get the code in
the code block as character vector as it's first argument, the language of the
code block, and the id of the code block and any other arguments given. 

For example:

```
hello_world <- function(code, language = "R", id = "", ...) {
  cat("\n**HELLO WORLD!**\n")
}
```

This function can be used in your markdown document as:

```
~~~{.R fun=hello_world}
# Any code is ignored
~~~
```


