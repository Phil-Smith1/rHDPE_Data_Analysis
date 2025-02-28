context("setup_local_filestore")

test_that("error_thrown_if_session_object_has_incorrect_class",{
  session <- structure(list(token="mytoken"), class="notShinySession")
  expect_error(setup_local_filestore(session))
})

test_that("file_store_is_created_empty_in_working_directory/tmp/filestore/<<token>>_if_default_root_dir_argument_used",{
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  file_store_location <- setup_local_filestore(session, root_dir=file.path(tempdir(), "slf1"))
  expect_equal(list.files(dirname(file_store_location)), "mytoken")
  expect_equal(list.files(file_store_location), character(0))
  destroy_local_filestore(file_store_location)
})

test_that("error_thrown_if_creating_filestore_which_already_exists",{
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  file_store_location <- setup_local_filestore(session, root_dir=file.path(tempdir(), "slf2"))
  #get warning from dir.create and then error from setup_local_filestore
  expect_error(expect_warning(setup_local_filestore(session, root_dir=file.path(tempdir(), "slf2"))))
  destroy_local_filestore(file_store_location)
})

test_that("can_create_multiple_filestores_each_with_different_tokens",{
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  file_store_location <- setup_local_filestore(session, root_dir=file.path(tempdir(), "slf3"))
  session <- structure(list(token="mytoken2"), class=c("ShinySession", "R6"))
  file_store_location2 <- setup_local_filestore(session, root_dir=file.path(tempdir(), "slf3"))
  expect_equal(list.files(dirname(file_store_location)), c("mytoken", "mytoken2"))
  destroy_local_filestore(file_store_location)
  destroy_local_filestore(file_store_location2)
})

test_that("error_thrown_if_invalid_root_dir_argument",{
  session <- structure(list(token="mytoken"), class="ShinySession")
  expect_error(setup_local_filestore(session, root_dir=""))
  expect_error(setup_local_filestore(session, root_dir=100))
  expect_error(setup_local_filestore(session, root_dir=c(getwd(), getwd())))
})
