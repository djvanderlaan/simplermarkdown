tinymarkdown
===============================================================================

A experiment using the filter functionality present in pandoc to run
R-code present in a markdown file and generate a new markdown file containing
the result of the R-code.

## Prerequisites

- Working installation of pandoc with pandoc available in the path. 
- When compiling to pdf, a working installation of LaTeX.
- And, of course, `tinymarkdown` installed.


## Usage

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

The package also includes the functions `mdweave_to_pdf`, `mdweave_to_html` and 
`mdweave_to_tex`, that combines that last two function calls. Therefore, the example
above could also have been written as:

```
library(tinymarkdown)
example1 <- system.file("examples/example1.md", package = "tinymarkdown")
mdweave_to_pdf(example1, "example1.pdf")
```

Although it is possible to pass additional arguments to `pandoc` through the `mdweave_to_...`
functions, it is probably just as easy to call `pandoc` directly. 


## Writing markdown


An example of a basic code block tagged as being R-code is shown below. Note
that I use the `~` here to make it easier to write this example; the `` ` `` 
would also be valid.  The id/label if the block is `codeblock1`.  

```
~~~{#codeblock1 .R}
a <- 1+1
~~~
```

Note that the `.R` needs to be the first argument starting with a `.` for the 
codeblock. For example ` ```{#codeblock .foo .R foo=bar} ` won't be evaluated, while
` ```{#codeblock foo=bar .R .foo} ` will.

By default the code in the code block is run and both the code and the output of
the code are shown in the generated new code block. Arguments can be used to
suppress either showing the code or the output:

```
~~~{#codeblock1 .R echo=FALSE results=TRUE}
a <- 1+1
~~~
```

Inline code is also supported. 

```
The average value of `Sepal.Width` is `mean(iris$Sepal.Width)`{.R} and 
that of `Petal.Width` is `mean(iris$Petal.Width)`{.R}.
```

The final result of inline code will always be included as text into the resulting markdown
document. In case of code blocks the code is passed on to a function. Depending on the function used
this can result in a code blocks with the evaluated code (the default), tables, figures and you can
also specify your own functions.

### Tables

To generate a table, we tell it to pass the code in the code block to the
function `output_table` from the `tinymarkdown` package. This function will take the
final result and generate a markdown table from that. Any arguments are passed
on to the `table` function.

```
~~~{.R fun=output_table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
~~~
```


### Figures

To generate a figure use the `output_figure` function. The function will run the code,
capture any output on the specified device and generate a markdown image
include.

```
~~~{.R fun=output_figure name="test" caption="My figure" device="pdf" width=8 
  height=6}
plot(dta$Sepal.Width, dta$Petal.Width)
~~~
```

### Other output

By using the `output_raw` filter, any other output can be generated. This function will
run the code, capture any output and put that directly into the resulting
markdown document. For example, to generate a figure you can also use:


```
~~~{.R fun=output_raw}
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


