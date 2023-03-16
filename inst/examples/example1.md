---
title: Title
---


# Header

- List item 
- Another list item

And some text with `inline code`.

``` {#codeblock1 .R echo=TRUE results=TRUE additionalargument=42}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
dta <- iris
```

And some text

``` {.R fun=output_table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```

### And some text

The mean of `Sepal.Width` is `m<-round(mean(dta$Sepal.Width), 2)`{.R}. 
This is `ifelse(m>2, "larger", "smaller")`{.R} than 2.

```
Geen R-code
```


```{.R fun=output_figure name="test" caption="My figure" device="pdf" width=8 
  height=6}
warning("FOO")
plot(dta$Sepal.Width, dta$Petal.Width)
```


```{.R fun=output_raw}
md_figure({
plot(dta$Sepal.Length, dta$Petal.Length)
}, name = "foo")
```


# Some regresion like tests

Following should result in no code block.

```{.R #nooutput1 results=FALSE echo=FALSE}
a <- 1+1
a
```

Following should result in an empty code block.

```{.R #nooutput2 results=FALSE echo=FALSE drop_empty=FALSE}
a <- 1+1
a
```

Following code should not be run

```{.R #dontrun eval=FALSE}
stop("Dit is een error")
```

