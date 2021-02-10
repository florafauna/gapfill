rm(list = ls())
library("gapfill", lib.loc = "../lib/")
citation("gapfill")



data("test_data", package="gapfill")
Image(ndvi)

example(Image)
Gapfill(ndvi)
