context("destroy_local_filestore")

setup_filestore_for_testing <- function(root_dir){
  session <- structure(list(token="mytoken"), class=c("ShinySession", "R6"))
  setup_local_filestore(session, root_dir)
}

test_that("filestore_is_destroyed_after_calling_destroy_local_filestore_function",{
  file_store_location <- setup_filestore_for_testing(root_dir=file.path(tempdir(), "dlf1"))
  expect_true("mytoken" %in% list.files(dirname(file_store_location)))
  destroy_local_filestore(file_store_location)
  expect_false("mytoken" %in% list.files(dirname(file_store_location)))
})

test_that("if_filestore_does_not_exist_then_destroying_it_returns_0_like_unlink_function",{
  expect_equal(destroy_local_filestore("my_location"), 0)
})
