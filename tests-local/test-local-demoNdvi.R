#require(testthat);
library("gapfill", lib.loc = "../lib/")
context("test-Gapfill-ndvi")
load("demoNDVIfilled.rda")

test_that("Gapfill demo",{
              
    expect_message(fill <- Gapfill(data = ndvi)$fill,
                  "data has 7056 values: 5453 \\(77%\\) observed
                      1603 \\(23%\\) missing
                      1603 \\(23%\\) to predict")

    expect_equal(fill, ndviFilled, tolerance=1e-4)
})

