
create_mock_response <- function() {
  structure(
    list(
      status_code = 200,
      content = c("test_key" = "value"),
      url = "",
      headers = c("x-prov-corr-id" = "mock-prov-id")
    ),
    class = "response"
  )
}

test_that("ProvenanceCache uses JWT token if available", {
  pc <- ProvenanceCache()
  claim <- jose::jwt_claim("ProvenanceId" = "test-jwt-id")
  token <- jose::jwt_encode_hmac(claim, "secret")
  expect_equal(pc$get_provenance_session_id(token), "test-jwt-id")
})

test_that("ProvenanceCache uses cached ID if available", {
  pc <- ProvenanceCache()
  claim <- jose::jwt_claim()
  token <- jose::jwt_encode_hmac(claim, "secret")
  pc$.cache_response(c("x-prov-corr-id" = "test-cached-id"))
  expect_equal(pc$get_provenance_session_id(token), "test-cached-id")
})

test_that("JWT provenance ID is preferred over cached ID", {
  pc <- ProvenanceCache()
  claim <- jose::jwt_claim("ProvenanceId" = "test-jwt-id")
  token <- jose::jwt_encode_hmac(claim, "secret")
  pc$.cache_response(c("x-prov-corr-id" = "test-cached-id"))
  expect_equal(pc$get_provenance_session_id(token), "test-jwt-id")
})

test_that("ProvenanceCache returns none if nothing available", {
  pc <- ProvenanceCache()
  claim <- jose::jwt_claim()
  token <- jose::jwt_encode_hmac(claim, "secret")
  expect_null(pc$get_provenance_session_id(token))
})


test_that("RawClient initialises with no errors", {
  rc <- RawClient(Environment$DEV)
  expect_true(all(c("get", "put", "post", "delete") %in% names(rc)))
})
