#library("testthat");
library("doParallel"); registerDoParallel(80)
library("gapfill", lib.loc = "../lib")
load("issue_juras.rda")
context("test-local-issue-juras")

test_that("test-local-issue-juras",{
    expect_error(data_issue_juras_out <- Gapfill(data = data_issue_juras, dopar=TRUE), NA)
    expect_warning(data_issue_juras_out <- Gapfill(data = data_issue_juras, dopar=FALSE) , NA)
    expect_equal(data_issue_juras_out$fill, data_issue_juras)
})
