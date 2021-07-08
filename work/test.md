---
title: Title
---


# Header

1. List item 
2. Another list item
3. And an item `sqrt(10)`{.R}

And *some `code`* text with `round(pi, 2)`{.R} *foo*.

``` {#codeblock1 .R echo=TRUE results=TRUE}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
dta <- iris
```

And some text

``` {.R fun=table caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```

### And `some code` text

```
Geen R-code
```


```{.R fun=figure name="test" caption="My figure" device="pdf" width=8 
  height=6}
warning("FOO")
plot(dta$Sepal.Width, dta$Petal.Width)
```


```{.R fun=raw}
md_figure({
plot(dta$Sepal.Length, dta$Petal.Length)
}, name = "foo")
```
