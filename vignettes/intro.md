<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to tinymarkdown}
-->
---
title: tinymarkdown
css: "style.css"
---

Introduction
-------------------------

First write a markdown file using [pandoc
markdown](https://pandoc.org/MANUAL.html#pandocs-markdown).  The package uses
pandoc to parse the markdown and runs any code blocks tagged as being R-code.
The result a new markdown file that can be further processed using pandoc and
compiled to, for example, PDF or HTML.

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
`mdweave_to_tex`, that combine that last two function calls. Therefore, the
example above could also have been written as:

```
library(tinymarkdown)
example1 <- system.file("examples/example1.md", package = "tinymarkdown")
mdweave_to_pdf(example1, "example1.pdf")
```

Although it is possible to pass additional arguments to `pandoc` through the
`mdweave_to_...` functions, it is probably just as easy to call `pandoc`
directly. 


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

Note that the `.R` needs to be the first argument starting with a `.` for the
codeblock. For example ` ```{#codeblock .foo .R foo=bar} ` won't be evaluated,
while ` ```{#codeblock foo=bar .R .foo} ` will.

By default the code in the code block is run and both the code and the output of
the code are shown in the generated new code block. Arguments can be used to
suppress either showing the code or the output:

`````
```{#codeblock1 .R echo=FALSE results=TRUE}
a <- 1+1
```
`````

Inline code is also supported. Again it should be tagged with `{.R}`:

```
The average value of `Sepal.Width` is `mean(iris$Sepal.Width)`{.R} and 
that of `Petal.Width` is `mean(iris$Petal.Width)`{.R}.
```

The final result of the inline code will always be included as text into the
resulting markdown document. In case of code blocks the code is passed on to a
function. Depending on the function used this can result in a code blocks with
the evaluated code (the default), tables, figures and you can also specify your
own functions.

### Tables

To generate a table, we tell it to pass the code in the code block to the
function `output_table` from the `tinymarkdown` package. This function will
take the final result and generate a markdown table from that. Any additional
arguments of the code block are passed on to the `output_table` function.

`````
```{.R fun=output_table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```
`````


### Figures

To generate a figure use the `output_figure` function. The function will run
the code, capture any output on the specified device and generate a markdown
image include.

`````
```{.R fun=output_figure name="test" caption="My figure" device="pdf" width=8 
  height=6}
plot(dta$Sepal.Width, dta$Petal.Width)
```
`````

The figures are saved in the folder `figures` in the current folder. 


### Other output

By using the `output_raw` filter, any other output can be generated. This
function will run the code, capture any output and put that directly into the
resulting markdown document. For example, let's print a list with all of the
iris species:

`````
```{.R fun=output_raw}
writeLines(paste("-", levels(iris$Species)))
```
`````

Or you can write your own filter function. This function will get the code in
the code block as character vector as it's first argument, the language of the
code block, and the id of the code block and any other arguments given. 

For example:

```
print_in_bold <- function(code, language = "R", id = "", ...) {
  cat("\n**", code, "**\n", sep = "")
}
```

This function could for example be defined in a block in the markdown file.
Afterwards, this function can be used in your markdown document as:

`````
```{.R fun=print_in_bold}
Hello World!
```
`````




Using as a vignette engine
-----------------------------------------------------------------------


To use tinymarkdown as an engine for your R-package vignettes you will need to do the following:

#### Specify tinymarkdown as your vignette builder in your `DESCRIPTION` file:

```
VignetteBuilder: tinymarkdown
```

#### Add tinymarkdown as a dependency of your package. 

If your package doesn't use tinymarkdown otherwise
you can add it to your `Suggests` field in the `DESCRIPTION` file:

```
Suggests: 
    tinymarkdown
```

#### Use the extension `.md` for your vignette.

Create the vignette in the `vignettes` directory in your 
package source.

#### Specify the vignette engine in your vignette. 

You have to add the following line to your vignette:

```
%\VignetteEngine{tinymarkdown::mdweave_to_html}
```

Instead of `mdweave_to_html` you can also use `mdweave_to_pdf` to generate a vignette in PDF format. 
It is easiest to do this in a comment section in your markdown file. For example, start your 
markdown file with:

```
<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
---

[And the contents of your vignette]
```


### Custom styling

By default the default templates and styling of the pandoc installation on your machine 
will be used.  However, you can also specify custom styling in the header of your markdown
file. See the [documentation of Pandoc](https://pandoc.org/MANUAL.html) for more 
information. For example, if you generate HTML output and you want to use a curstom
CSS-stylesheet, you can place the stylesheet in the `vignettes` directory and 
refer to the stylesheet in the header:

```
<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
css: custom_styling.css
---
```


