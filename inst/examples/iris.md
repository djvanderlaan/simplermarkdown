---
title: An analysis of iris
---

Introduction
-------------------------

From the help page of the iris data set:

> This famous (Fisher's or Anderson's) iris data set gives the
> measurements in centimeters of the variables sepal length and
> width and petal length and width, respectively, for 50 flowers
> from each of 3 species of iris.  The species are _Iris setosa_,
> _versicolor_, and _virginica_.


Descriptives
--------------------------

The table below shows for each of the iris species the mean value of the colums in the data set. 

```{.R #table fun=output_table caption="Mean values for each of the properties for each of the iris species."}
aggregate(iris[1:4], iris["Species"], mean)
```


```{.R #figure fun=output_figure 
  caption="Relation between sepal length and width for the different iris species." 
  name="iris" height=6 width=8 units="in" res=150 echo=TRUE}
pal <- hcl.colors(3, "Dark2")
plot(iris$Sepal.Width, iris$Sepal.Length, pch = 20, 
  col = pal[iris$Species], xlab = "Sepal Width", 
  ylab = "Sepal Length", bty = 'n', las = 1)
legend("topright", legend = levels(iris$Species), 
  fill = pal, bty = 'n', border = NA)
```



Species prediction
---------------------------------

```{.R}
library(MASS)
m <- lda(Species ~ Sepal.Width + Sepal.Length, data = iris)
p <- predict(m)
predicted_species <- p$class
table(predicted_species, iris$Species)
```

This model predicts in `round(mean(predicted_species==iris$Species)*100)`{.R}% of the
cases the correct species. However, this is mainly for *setosa* for the other species the
model predicts the correct species only for
`sel<-iris$Species!="setosa";round(100*mean(predicted_species[sel] == iris$Species[sel]))`{.R}% of
the records.



