


.PHONY: build check document install

build: document
	cd work && R CMD build ../

check: build
	cd work && R CMD check `ls work/tinymarkdown_* | sort | head -n 1`

document:
	R -e "roxygen2::roxygenise()"

install: build
	R CMD INSTALL `ls work/tinymarkdown_* | sort | head -n 1` 

gen_test: install
	Rscript work/generate_test_reference.R

