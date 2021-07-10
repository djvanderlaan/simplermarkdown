

library(tinymarkdown)

# Filter tree; read from srdin
new_dta <- tinymarkdown:::filter_pandoc_json_tree()  

# Write filtered tree to stcout
writeLines(rjson::toJSON(new_dta))

