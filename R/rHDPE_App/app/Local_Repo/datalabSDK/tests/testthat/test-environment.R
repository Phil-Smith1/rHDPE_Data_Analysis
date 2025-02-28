
test_that("get_public_api_url returns correct url with no extra slash", {
  env <- Environment$DEV
  expect_equal(get_public_api_url(env, "test"), "https://datalab-dev.unilever.com/public/test")
})

test_that("get_public_api_url returns correct url with leading slash", {
  env <- Environment$DEV
  expect_equal(get_public_api_url(env, "/test"), "https://datalab-dev.unilever.com/public/test")
})

test_that("get_public_api_url returns correct url with leading and trailing slash", {
  env <- Environment$DEV
  expect_equal(get_public_api_url(env, "/test/"), "https://datalab-dev.unilever.com/public/test")
})

test_that("get_public_api_url returns correct url with empty field", {
  env <- Environment$DEV
  expect_equal(get_public_api_url(env, ""), "https://datalab-dev.unilever.com/public")
})

test_that("get_public_api_url returns correct url when passed a slash", {
  env <- Environment$DEV
  expect_equal(get_public_api_url(env, "/"), "https://datalab-dev.unilever.com/public")
})

test_that("get_mme_api_url returns correct url with no extra slash", {
  env <- Environment$DEV
  expect_equal(get_mme_api_url(env, "test"), "https://datalab-dev.unilever.com/public/mme/test")
})

test_that("get_mme_api_url returns correct url with a leading slash", {
  env <- Environment$DEV
  expect_equal(get_mme_api_url(env, "/test"), "https://datalab-dev.unilever.com/public/mme/test")
})

test_that("get_mme_api_url returns correct url with a leading and trailing slash", {
  env <- Environment$DEV
  expect_equal(get_mme_api_url(env, "/test/"), "https://datalab-dev.unilever.com/public/mme/test")
})

test_that("get_mme_api_url returns correct url with empty field", {
  env <- Environment$DEV
  expect_equal(get_mme_api_url(env, ""), "https://datalab-dev.unilever.com/public/mme")
})

test_that("get_mme_api_url returns correct url when passed a slash", {
  env <- Environment$DEV
  expect_equal(get_mme_api_url(env, "/"), "https://datalab-dev.unilever.com/public/mme")
})

test_that(".get_platform_url returns url when environment variable is not set", {
  env <- Environment$ON_PLATFORM
  expect_equal(env$base_url, "http://localhost:8011")
})

test_that("get_headers returns correctly formatted token when not on platform", {
  env <- Environment$DEV
  expect_equal(get_headers(env, "token"), c("Authorization" = "Bearer token"))
})

test_that("get_headers returns correctly formatted token when on platform", {
  env <- Environment$ON_PLATFORM
  expect_equal(get_headers(env, "token"), c("x-auth-jwt" = "token"))
})
