---
title: Title
---


# Header

1. List item 
2. Another list item
3. And an item `sqrt(10)`{.R}

And *some `code`* text with `round(pi, 2)`{.R #round} **foo** and _bar_.

``` {#codeblock1 .R echo=TRUE results=TRUE}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
dta <- iris
print(Sys.getenv("MDOUTPUTDIR"))
```

And some text with [An url](http://somwhere.com) and some more text.

![An image](bar)


``` {.R fun=tab caption="Sample iris"}
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]
```

### And `some code` text

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


Table: a pretty table

|Bla | Bla | Bla |
|----|-----|-----|
| 1  | 2   | 3   |
| 1  | 2   | 3   |
| 1  | 2   | 3   |
| 1  | 2   | 3   |
| 1  | 2   | 3   |
| 1  | 2   | 3   |


:::::: WARNING ::::::::

> A block quote with some text and also some code `mean(1:3)`{.R} which should
> be evaluated. 
>
> > An even nested quotes with code `mean(1:4)`{.R} which should also be evaluated.
>
>      And even some code
>      1+1
>      1+3

::::::

