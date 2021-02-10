#require(testthat);

library("gapfill", lib.loc = "../lib")
load("maskstudy.rda")
load("maskstudy_out.rda")
data <- data_array_masked20[1:15,1:15,1:2,1:6]

context("test-local-Gapfill")

test_that("Gapfill-base",{
  expect_equal(Gapfill(data = data)$fill, ref)
})

test_that("Gapfill-iMax",{
  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 14L,
                 nPredict = 1,
                 clipRange = c(0,1),
                 dopar = FALSE)
  expect_equal(out$fill, ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 0L,
                 nPredict = 1,
                 clipRange = c(0, 1),
                 dopar = FALSE)
  expect_equal(out$fill, ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 0L,
                 nPredict = 1,
                 clipRange = c(0, 1),
                 dopar = FALSE,
                 initialSize = c(0L, 0L, 1L, 6L))
  expect_equal(out$fill, data)
})

test_that("Gapfill-nPredict",{
  out <- Gapfill(data = data_array_masked20[1:15,1:15,1:2,1:6],
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 2,
                 clipRange = c(0, 1),
                 dopar = FALSE)
  expect_equal(out$fill[,,,,1], ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 3,
                 clipRange = c(0, 1),
                 dopar = FALSE)
  expect_equal(out$fill[,,,,1], ref)
})

test_that("Gapfill-subset",{
    subset <- array(rep(c(TRUE, FALSE), length(data) / c(2, 2)),
                     dim(data))
    out <- Gapfill(data = data, subset = subset)
    expect_equal(out$fill[subset&is.na(data)], ref[subset&is.na(data)])
    
})

test_that("Gapfill-clipRange",{
  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 1,
                 clipRange = c(.5, .55),
                 dopar = FALSE)
  alt <- ref
  alt[alt < .5] <- .5
  alt[alt > .55] <- .55
  expect_equal(out$fill, alt)
})

test_that("Gapfill dopar",{
  if(!require(doParallel))
      skip("package \"doPrallel\" is not installed.")
  registerDoParallel(4)

  expect_equal(Gapfill(data = data, dopar = TRUE)$fill, ref)

  ## iMax
  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 14L,
                 nPredict = 1,
                 clipRange = c(0,1),
                 dopar = TRUE)
  expect_equal(out$fill, ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 0L,
                 nPredict = 1,
                 clipRange = c(0, 1),
                 dopar = TRUE)
  expect_equal(out$fill, ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = 0L,
                 nPredict = 1,
                 clipRange = c(0, 1),
                 dopar = TRUE,
                 initialSize = c(0L, 0L, 1L, 6L))
  expect_equal(out$fill, data)

  #nPredict
  out <- Gapfill(data = data_array_masked20[1:15,1:15,1:2,1:6],
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 2,
                 clipRange = c(0, 1),
                 dopar = TRUE)
  expect_equal(out$fill[,,,,1], ref)

  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 3,
                 clipRange = c(0, 1),
                 dopar = TRUE)
  expect_equal(out$fill[,,,,1], ref)

  ## subset
  subset <- array(rep(c(TRUE, FALSE), length(data) / c(2, 2)),
                     dim(data))
  out <- Gapfill(data = data, subset = subset)
  expect_equal(out$fill[subset&is.na(data)], ref[subset&is.na(data)])

  ## clipRange
  out <- Gapfill(data = data,
                 fnSubset = Subset,
                 fnPredict = Predict,
                 subset = "missings",
                 iMax = Inf,
                 nPredict = 1,
                 clipRange = c(.5, .55),
                 dopar = TRUE)
  alt <- ref
  alt[alt < .5] <- .5
  alt[alt > .55] <- .55
  expect_equal(out$fill, alt)
})

## arg verbose is not tested
