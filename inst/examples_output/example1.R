# codeblock1
a <- 1+1
b <- mean(a) + 10
# Dit is commentaat
c <- a+b
c
dta <- iris

# <unlabeled code block>
dta$foo <- dta$Sepal.Width/dta$Sepal.Length
dta[1:20, ]

# <unlabeled code block>
warning("FOO")
plot(dta$Sepal.Width, dta$Petal.Width)

# <unlabeled code block>
md_figure({
plot(dta$Sepal.Length, dta$Petal.Length)
}, name = "foo")

# nooutput1
a <- 1+1
a

# nooutput2
a <- 1+1
a

# dontrun
stop("Dit is een error")

