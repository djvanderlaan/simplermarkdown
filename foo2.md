---
title: Title
---


# Header

- List item 
- Another list item

And some text with `inline code`{.R}.

``` {#codeblock1 .R echo=FALSE results=TRUE}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
```

And some text

``` {.R fun=raw}
md_table(iris[1:20, ], caption = "Sample iris")
```

### And some text

```
Geen R-code
```



```{.R 
  fun=raw}
md_figure({
  plot(iris$Sepal.Width, iris$Petal.Width)
}, "test", caption = "My figure")
```
