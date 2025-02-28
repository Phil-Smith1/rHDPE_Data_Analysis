context("access_local_filestore")

setup_filestore_for_testing <- function(root_dir){
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  file_store_location <- setup_local_filestore(session, root_dir)
  writeLines("Testing file", file.path(file_store_location, "test.txt"))
  file_store_location
}

test_that("can_read_file_from_filestore_using_default file_read_function_if_file_exists",{
  file_store_location <- setup_filestore_for_testing(root_dir=file.path(tempdir(), "alf1"))
  text <- access_local_filestore(file_store_location, file_name="test.txt")
  expect_equal(text, "Testing file")
  destroy_local_filestore(file_store_location)
})

test_that("error_thrown_if_trying_to_read_a_file_which_does_not_exist",{
  file_store_location <- setup_filestore_for_testing(root_dir=file.path(tempdir(), "alf2"))
  expect_error(expect_warning(access_local_filestore(file_store_location, file_name="invalid.txt")))
  destroy_local_filestore(file_store_location)
})

test_that("can_use_custom_read_functions_to_read_file_in_filestore",{
  my_read_function <- function(...) readLines(...)
  file_store_location <- setup_filestore_for_testing(root_dir=file.path(tempdir(), "alf3"))
  text <- access_local_filestore(file_store_location, file_name="test.txt", file_read_function = my_read_function)
  expect_equal(text, "Testing file")
  destroy_local_filestore(file_store_location)
})

test_that("error_thrown_if_invalid_custom_read_function_used_to_read_file_in_filestore",{
  invalid_read_function <- function(...) stop("this is an error")
  file_store_location <- setup_filestore_for_testing(root_dir=file.path(tempdir(), "alf4"))
  expect_error(access_local_filestore(file_store_location, file_name="test.txt", file_read_function = invalid_read_function))
  destroy_local_filestore(file_store_location)
})
