library(devtools)
document()
load_all()

system("pandoc -s work/test.md -t json > work/test.json")
dta <- filter_pandoc_json_tree("work/test.json")
writeLines(rjson::toJSON(dta), "work/test_proc.json")

system("pandoc -s work/test_proc.json -o work/test_proc.md")
system("pandoc -s work/test_proc.md -o work/test_proc.pdf")


