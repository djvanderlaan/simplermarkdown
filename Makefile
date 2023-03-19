


.PHONY: build check document install

build: document
	cd work && R CMD build ../

build_firsttime: document
	cd work && R CMD build --no-build-vignettes ../

check: build
	cd work && R CMD check --as-cran `ls simplermarkdown_* | sort | tail -n 1`

document:
	R -e "roxygen2::roxygenise()"

install: build
	R CMD INSTALL `ls work/simplermarkdown_* | sort | tail -n 1` 

readme: 
	R -e 'simplermarkdown::mdweave("vignettes/intro.md", "README.md", cmd2 = "pandoc %1$$s -t gfm -o %2$$s")'

test_reference:
	cd inst/examples_output && R -e 'library(simplermarkdown);mdweave("../examples/iris.md", "iris.md")'
	cd inst/examples_output && R -e 'library(simplermarkdown);mdweave("../examples/iris_copypaste.md", "iris_copypaste.md")'
	cd inst/examples_output && R -e 'library(simplermarkdown);mdtangle("../examples/iris.md", "iris.R")'
	cd inst/examples_output && R -e 'library(simplermarkdown);mdweave("../examples/example1.md", "example1.md")'
	cd inst/examples_output && R -e 'library(simplermarkdown);mdtangle("../examples/example1.md", "example1.R")'

reverse_dependencies: build
	cd work && rm -r -f revdep && mkdir revdep
	cd work && cp `ls simplermarkdown_* | sort | tail -n 1` revdep
	cd work && R -s -e "out <- tools::check_packages_in_dir('revdep',reverse=list(which='most'),Ncpus=3); print(summary(out)); saveRDS(out, file='revdep/output.RDS')"
