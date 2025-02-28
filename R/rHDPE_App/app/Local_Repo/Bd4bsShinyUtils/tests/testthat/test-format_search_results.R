context("format_search_results")

test_that("content_without_results_object_returns_an_error",{
  request_content_from_JSON <- list(more=FALSE)
  expect_error(format_search_results(request_content_from_JSON))
})

test_that("content->results_being_empty_list_returns_data_frame_with_no_rows",{
  request_content_from_JSON <- list(more=FALSE, results=list())
  formatted_results <- format_search_results(request_content_from_JSON)
  expect_equal(class(formatted_results), "data.frame")
  expect_equal(nrow(formatted_results), 0)
})

test_that("content->results_being_a_vector_throws_an_error",{
  request_content_from_JSON <- list(more=FALSE, results=c(45,45,23))
  expect_error(format_search_results(request_content_from_JSON))
})

test_that("content->results_with_invalid_columns_throws_error",{
  request_content_from_JSON <- list(more=FALSE, results=data.frame(invalid=c(3,4,5),wrong=c(6,5,3)))
  expect_error(format_search_results(request_content_from_JSON))
})

test_that("format_search_results_with_valid_content_returns_data_frame_with_one_row_per_result_with_appropriate_columns",{

  #This is how fromJSon in JSONlite returns the response (a list inside a dataframe is just wrong...)
  request_content_from_JSON <- list(more=FALSE,
    results=data.frame(RepoID=c("w","x","y"), Name=c("A","B","C"), Description=c("A","BB","C"),
                       DataID=c("ww","xx", "yy")))
  request_content_from_JSON$results$Tags <- list(c("A", "B"), c("s"), character(0))
  request_content_from_JSON$results$KeyValueFields <- list(list(),data.frame(Key=c("key1"), Value=c("val1"), Type=c("STRING")),
                                                           data.frame(Key=c("key1", "key2"), Value=c("val1", 45), Type=c("STRING", "NUMBER")))
  formatted_results <- format_search_results(request_content_from_JSON)

  expect_equal(class(formatted_results), "data.frame")
  expect_equal(nrow(formatted_results),3)
  expect_equal(colnames(formatted_results), c("Name", "Description", "Tags" ,"Id", "RepoId", "Key-Values"))
  expect_equal(formatted_results$Name, factor(c("A", "B", "C")))
  expect_equal(formatted_results$Description, factor(c("A", "BB", "C")))
  expect_equal(formatted_results$Tags, c("A, B", "s", ""))
  expect_equal(formatted_results$Id, factor(c("ww","xx","yy")))
  expect_equal(formatted_results$RepoId, factor(c("w","x","y")))
})
