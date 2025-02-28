context("access_data_gateway_by_id_invalid_arguments")

test_that("error_thrown_if_session_argument_not_session_object",{
  expect_error(access_data_gateway_by_id(uid="temp", session="hello", filestore_location="/"),
               "The R Shiny session or session_proxy object should be passed into the access_data_gateway_by_id function")
})

test_that("error_thrown_if_zero_or_two_of_uid_and_repoID_are_not_NULL",{
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  expect_error(access_data_gateway_by_id(uid="temp", session=session, filestore_location="/", repoID = "temp"),
               "Exactly one of uid and repoID must be NULL")
  expect_error(access_data_gateway_by_id(uid=NULL, session=session, filestore_location="/", repoID = NULL),
               "Exactly one of uid and repoID must be NULL")
})

test_that("error_thrown_if_file_descriptor_is_NULL",{
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  expect_error(access_data_gateway_by_id(uid="temp", session=session, filestore_location="/", file_descriptor = NULL),
    paste("file_descriptor argument cannot be NULL",
      "it should be a description of the file being extracted so that meaningful error messages can be given to users"))
})
