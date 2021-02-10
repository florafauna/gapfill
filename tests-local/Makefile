include ../Makefile.defs

testFiles = test*.R
testData = *.rda

run-localTests.Rout: run-localTests.R $(testFiles) 
	$(RBATCH) run-localTests.R
	cat run-localTests.Rout

