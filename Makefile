include Makefile.defs

VERSION := 0.9.6-1
TAR = gapfill_$(VERSION).tar.gz


.PHONY: update-src tar lib \
        test test-local test-package test-examples \
        check check-cran \
	install \
        winbuild winbuild-devel \
        cp rm 

update-src:
	cd gapfill && sed -i -r -- 's/^Version:.*/Version: '$(VERSION)'/g' DESCRIPTION ;      
	cd gapfill && sed -i -r -- 's/^Date:.*/Date: '`date +'%F'`'/g' DESCRIPTION ;
	$(RSCRIPT) -e "Rcpp::compileAttributes(\"gapfill\")"
	$(RSCRIPT) -e "roxygen2::roxygenize(\"gapfill\")"

lib: update-src
	mkdir -p lib
	$(R) CMD INSTALL -l lib gapfill


tar: tar/$(TAR)
tar/$(TAR): update-src
	mkdir -p tar
	$(R) CMD build gapfill
	mv $(TAR) tar/$(TAR)



test: test-package test-examples test-local 

test-local: lib tests-local/*
	make -C tests-local run-localTests.Rout

test-package: update-src
	$(RSCRIPT) -e "devtools::test(\"gapfill/\")"

test-examples: update-src
	$(RSCRIPT) -e "devtools::run_examples(\"gapfill/\", run = FALSE)"
	rm -f Rplots*.pdf

check: update-src
	$(RSCRIPT) -e "devtools::check(\"gapfill\", cran = FALSE)"

check-cran: update-src tar/$(TAR)
	$(R) CMD check --as-cran tar/$(TAR) 

install: tar/$(TAR)	
	$(R) CMD INSTALL tar/$(TAR)

winbuild: update-src
	$(RSCRIPT) -e "devtools::build_win(pkg = \"gapfill\", version = \"R-release\")"

winbuild-devel: update-src
	$(RSCRIPT) -e "devtools::build_win(pkg = \"gapfill\", version = \"R-devel\")"



cp: tar
	mkdir -p ../gapfill
	rm ../gapfill/* -rf
	cp tar/$(TAR) ../gapfill/
	rsync -av --exclude=".git/*" gapfill/* ../gapfill
	rsync -av gapfill/.Rbuildignore ../gapfill/.Rbuildignore

rm:
	rm -fr tar lib tests-local/*.Rout gapfill/src/*.so gapfill/src/*.o gapfill.Rcheck
