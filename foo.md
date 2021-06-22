---
title: Title
---


# Header

- List item 
- Another list item

And some text

``` {#codeblock1 .R foo=bar}
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
```

And some text

``` {.R foo=bar raw=true .flierp}
md_table(iris[1:20, ], caption = "Sample iris")
```

### And some text

```{foo=bar}
Geen R-code
```



```{.R raw=true}
md_figure({
  plot(iris$Sepal.Width, iris$Petal.Width)
}, "test", caption = "My figure")
```
