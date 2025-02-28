context("in_dev_mode")

test_that("not_in_dev_mode_when_appropriate_option_is_NULL",{
  options(Bd4bsShinyUtils.dev_mode=NULL)
  expect_false(in_dev_mode())
})

test_that("in_dev_mode_when_appropriate_option_is_set_true",{
  options(Bd4bsShinyUtils.dev_mode=TRUE)
  expect_true(in_dev_mode())
  options(Bd4bsShinyUtils.dev_mode=NULL)
})

test_that("not_in_dev_mode_when_appropriate_option_is_set_false",{
  options(Bd4bsShinyUtils.dev_mode=FALSE)
  expect_false(in_dev_mode())
  options(Bd4bsShinyUtils.dev_mode=NULL)
})

