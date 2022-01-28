<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to simplermarkdown}
-->
---
title: simplermarkdown
css: "style.css"
---

Introduction to simplermarkdown
--------------------------------------

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
library(simplermarkdown)

example1 <- system.file("examples/example1.md", package = "simplermarkdown")

mdweave(example1, "example1_woven.md")

system("pandoc example1_woven.md -o example1.pdf")
```

The package also includes the functions `mdweave_to_pdf`, `mdweave_to_html` and
`mdweave_to_tex`, that combine these last two function calls. Therefore, the
example above could also have been written as:

```
library(simplermarkdown)
example1 <- system.file("examples/example1.md", package = "simplermarkdown")
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
the code are shown in the generated new code block. In the output file this
will result in

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

### Figures
To generate a figure use the `output_figure` function. The function will run
the code, capture any output on the specified device and generate a markdown
image include.

`````
```{.R #myfigure fun=output_figure name="test" caption="My figure" 
  device="pdf" width=8 height=6}
plot(dta$Sepal.Width, dta$Petal.Width)
```
`````

`output_figure` accepts the options `caption` (default none), `device` (possible
values are `"png"` and `"pdf"`), `echo` (default `FALSE`; echo the commands to
the output) and `results` (default `FALSE`; show output of the command (other
than the figure) in the output).  Additional arguments such as `width` and
`height` are passed on to the device (in this case `pdf()`). When an id is given
for the code block (as `#myfigure` above) this is also added to the figure.

The figures are saved in the folder `figures` in the current folder. This can be
controlled by the `dir` argument. 

### Tables
To generate a table, we tell it to pass the code in the code block to the
function `output_table` from the `simplermarkdown` package. This function will
take the final result and generate a markdown table from that. Any additional
arguments of the code block are passed on to the `output_table` function.

`````
```{.R #mytable fun=output_table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```
`````

`output_table` only accepts the `caption` argument. Unfortunately, pandoc does
not yet support adding id's to tables at the moment without the
[pandoc crossref filter](https://github.com/lierdakil/pandoc-crossref).
Therefore, simplermarkdown also doesn't add the id to the resulting table as
this would interfere with regular pandoc use. Should you want to add an id to
the table in order to use it with the crossref filter: you can either do

````
: Sample iris {#mytable}

```{.R fun=output_table}
iris[1:5, ]
```
````
or 

````
```{.R fun=output_table caption="Sample iris {#mytable}"}
iris[1:5, ]
```
````



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

To use simplermarkdown as an engine for your R-package vignettes you will need to do the following:

#### Specify simplermarkdown as your vignette builder in your `DESCRIPTION` file:

```
VignetteBuilder: simplermarkdown
```

#### Add simplermarkdown as a dependency of your package. 
If your package doesn't use simplermarkdown otherwise you can add it to your
`Suggests` field in the `DESCRIPTION` file:

```
Suggests: 
    simplermarkdown
```

#### Use the extension `.md` for your vignette.
Create the vignette in the `vignettes` directory in your package source.

#### Specify the vignette engine in your vignette. 

You have to add the following line to your vignette:

```
%\VignetteEngine{simplermarkdown::mdweave_to_html}
```

Instead of `mdweave_to_html` you can also use `mdweave_to_pdf` to generate a
vignette in PDF format. It is easiest to do this in a comment section in your
markdown file. For example, start your markdown file with:

```
<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
---

[And the contents of your vignette]
```

### Custom styling
By default the default templates and styling of the pandoc installation on your
machine will be used.  However, you can also specify custom styling in the
header of your markdown file. See the
[documentation of Pandoc](https://pandoc.org/MANUAL.html) for more information.
For example, if you generate HTML output and you want to use a custom
CSS-stylesheet, you can place the stylesheet in the `vignettes` directory and
refer to the stylesheet in the header:

```
<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
css: custom_styling.css
---
```

## A note about paths and working directories
`simplermarkdown` tries to assume as little as possible about possible
workflows. However, this also means that you, the user, are responsible for some
things where other packages might make assumptions.  One of the places where
this is the case is for paths and working directories. And this is especially
relevant when including figures and when generating figures using R.

As an example take the following project directory:
`````
report/
   report.md
   figures/
     figure1.png
report/output/
`````

The report contains the following code:
`````
![Figure caption](figures/figure1.png)

```{.R fun=output_figure name="figure2" caption="Caption", device="png"}
plot(1:10)
```
`````

Assume the current working directory is the root of the project directory 
and that we run `mdweave` as:

`````
mdweave("report/report.md", "report/output/report.md")
`````
Figures are by default created in the directory `figures` in the 
target directory. Therefore the directory structure after running
`mdweave` is:

`````
report/
   report.md
   figures/
     figure1.png
   ouput/
     report.md
     figures/
       figure2.png
`````
And the resulting markdown file will contain the following markdown:
`````
![Figure caption](figures/figure1.png)

![Caption](report/output/figures/figure2.png)
`````

As you can see, we now have two locations with figures. When running 
`pandoc` from the root directory of the project to create the 
final output:
`````
pandoc report/output/report.md -s -o report/output/report.html
`````
`pandoc` will not be able to find the first figure. It will find the 
second figure.  When you would run the final `pandoc` command from 
the `report/output` directory. `pandoc` will not be able to find 
any of the figures.


There are several possible solutions for the example above:

- When working on linux or mac, you could create a symbolic link from
  `report/output/figures` to `report/figures`. 
- Copy `report/figures` to `report/output/figures`. 
- Path of least resistance: run `mdweave` and `pandoc` from the
  `report` directory and also put the output in the same directory.
- And probably others. 

Note that the same issues occur when referencing stylesheets etc. in the 
meta block of the markdown file.
