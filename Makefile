


.PHONY: build check document install

build: document
	cd work && R CMD build ../

check: build
	cd work && R CMD check --as-cran `ls tinymarkdown_* | sort | head -n 1`

document:
	R -e "roxygen2::roxygenise()"

install: build
	R CMD INSTALL `ls work/tinymarkdown_* | sort | head -n 1` 

gen_test: install
	Rscript work/generate_test_reference.R

readme: 
	R -e 'tinymarkdown::mdweave("vignettes/intro.md", "README.md", cmd2 = "pandoc %1$$s -o %2$$s")'
 
