# tests/testthat/test_prop_to_pct.R
# Unit test for the helper used in the barplot script.
# This test defines the function locally so the script itself does not need to be changed.

library(testthat)

prop_to_pct <- function(x, scale = 100, round_digits = NULL) {
  vals <- as.numeric(x)
  res <- vals * scale
  names(res) <- names(x)
  if (!is.null(round_digits)) res <- round(res, round_digits)
  res
}

test_that("prop_to_pct converts proportions to percentages", {
  counts <- c(A = 3, B = 1, C = 1)
  props <- prop.table(counts)
  pct <- prop_to_pct(props)

  expect_equal(names(pct), names(props))
  expect_equal(pct, as.numeric(props) * 100)
})

test_that("prop_to_pct supports rounding and custom scale", {
  x <- c(a = 0.12345, b = 0.87655)
  pct <- prop_to_pct(x, scale = 100, round_digits = 2)

  expect_equal(pct["a"], 12.35)
  expect_equal(pct["b"], 87.66)
})

test_that("prop_to_pct preserves names for named input", {
  x <- c(foo = 0.25, bar = 0.75)
  pct <- prop_to_pct(x)
  expect_named(pct, c("foo", "bar"))
})

test_that("prop_to_pct returns unnamed output for unnamed input", {
  x <- c(0.2, 0.8)
  pct <- prop_to_pct(x)
  expect_null(names(pct))
  expect_equal(pct, c(20, 80))
})
