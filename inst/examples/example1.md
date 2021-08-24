---
title: Title
---


# Header

- List item 
- Another list item

And some text with `inline code`.

``` {#codeblock1 .R echo=TRUE results=TRUE}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
dta <- iris
```

And some text

``` {.R fun=tab caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```

### And some text

The mean of `Sepal.Width` is `m<-round(mean(dta$Sepal.Width), 2)`{.R}. 
This is `ifelse(m>2, "larger", "smaller")`{.R} than 2.

```
Geen R-code
```


```{.R fun=fig name="test" caption="My figure" device="pdf" width=8 
  height=6}
warning("FOO")
plot(dta$Sepal.Width, dta$Petal.Width)
```


```{.R fun=raw}
md_figure({
plot(dta$Sepal.Length, dta$Petal.Length)
}, name = "foo")
```
