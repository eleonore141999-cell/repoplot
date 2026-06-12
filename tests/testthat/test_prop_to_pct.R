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
  props <- prop.table(c(A = 3, B = 1, C = 1))
  pct <- prop_to_pct(props)

  expect_equal(pct, setNames(as.numeric(props) * 100, names(props)))
})