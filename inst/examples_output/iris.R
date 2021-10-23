# table
aggregate(iris[1:4], iris["Species"], mean)

# figure
pal <- hcl.colors(3, "Dark2")
plot(iris$Sepal.Width, iris$Sepal.Length, pch = 20, 
  col = pal[iris$Species], xlab = "Sepal Width", 
  ylab = "Sepal Length", bty = 'n', las = 1)
legend("topright", legend = levels(iris$Species), 
  fill = pal, bty = 'n', border = NA)

# <unlabeled code block>
library(MASS)
m <- lda(Species ~ Sepal.Width + Sepal.Length, data = iris)
p <- predict(m)
predicted_species <- p$class
table(predicted_species, iris$Species)

