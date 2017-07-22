library(regr)
data("panel_data")

context("Test that reg produces the correct results.")

test_that("reg matches results", {
  expect_equal(round(reg(y ~ x, panel_data)[[1, 2]], 4), 0.0297)
  expect_equal(round(reg(y ~ x, panel_data)[[2, 2]], 4), 1.0348)
  expect_equal(round(reg(y ~ x, panel_data)[[1, 3]], 4), 0.0284)
  expect_equal(round(reg(y ~ x, panel_data)[[2, 3]], 4), 0.0286)
})

test_that("reg robust matches results", {
  expect_equal(round(reg(y ~ x, panel_data, robust = TRUE)[[1, 2]], 4), 0.0297)
  expect_equal(round(reg(y ~ x, panel_data, robust = TRUE)[[2, 2]], 4), 1.0348)
  expect_equal(round(reg(y ~ x, panel_data, robust = TRUE)[[1, 3]], 4), 0.0284)
  expect_equal(round(reg(y ~ x, panel_data, robust = TRUE)[[2, 3]], 4), 0.0284)
})

test_that("reg cluster firmid matches results", {
  expect_equal(round(reg(y ~ x, panel_data, cluster = "firmid")[[1, 2]], 4), 0.0297)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "firmid")[[2, 2]], 4), 1.0348)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "firmid")[[1, 3]], 4), 0.0670)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "firmid")[[2, 3]], 4), 0.0506)
})

test_that("reg cluster year matches results", {
  expect_equal(round(reg(y ~ x, panel_data, cluster = "year")[[1, 2]], 4), 0.0297)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "year")[[2, 2]], 4), 1.0348)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "year")[[1, 3]], 4), 0.0234)
  expect_equal(round(reg(y ~ x, panel_data, cluster = "year")[[2, 3]], 4), 0.0334)
})

test_that("reg cluster firmid and year matches results", {
  expect_equal(round(reg(y ~ x, panel_data, cluster = c("firmid", "year"))[[1, 2]], 4), 0.0297)
  expect_equal(round(reg(y ~ x, panel_data, cluster = c("firmid", "year"))[[2, 2]], 4), 1.0348)
  expect_equal(round(reg(y ~ x, panel_data, cluster = c("firmid", "year"))[[1, 3]], 4), 0.0651)
  expect_equal(round(reg(y ~ x, panel_data, cluster = c("firmid", "year"))[[2, 3]], 4), 0.0536)
})
