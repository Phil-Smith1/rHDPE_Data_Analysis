context("dev_mode_HTTR")

test_that("invalid_query_returns_status_code_400",{
  options(Bd4bsShinyUtils.dev_dir=getwd())
  #id + cart require /<<id>> in API call
  for(url in c("test/invalid", "/id", "/cart", "/search/wrong" )){
    r <- dev_mode_HTTR(url, query =NULL)
    expect_equal(r$status_code, 404)
  }

  options(Bd4bsShinyUtils.dev_dir=NULL)
})

test_that("error_thrown_if_dev_directory_not_set",{
  options(Bd4bsShinyUtils.dev_dir=NULL)
  #Note the ?includeObsolete is ignored in dev mode
  expect_error(dev_mode_HTTR("/search?includeObsolete=TRUE", body=NULL))
})

test_that("404_status_code_if_non-existent_file_is_attempted_to_be_read_queried",{
  temp_location <- file.path(tempdir(), "1")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)

  r <- dev_mode_HTTR("/id/non-existent-file.txt", query =NULL)
  expect_equal(r$status_code, 404)

  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})

test_that("can_read_file_using_/id_endpoint",{
  temp_location <- file.path(tempdir(), "2")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)
  file_name <- file.path(temp_location, "results.txt")
  writeLines("Hello", con = file_name )

  r <- dev_mode_HTTR("/id/results.txt", query =NULL)
  expect_equal(r$status_code, 200)
  expect_equal(r$content, readBin(file_name,"raw", file.info(file_name)$size))
  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})


test_that("latest_produces_same_results_as_id_in_dev_mode",{
  temp_location <- file.path(tempdir(), "2a")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)
  file_name <- file.path(temp_location, "results.txt")
  writeLines("Hello", con = file_name )

  r_id <- dev_mode_HTTR("/id/results.txt", query=NULL)
  r_latest <- dev_mode_HTTR("/latest/results.txt", query=NULL)
  expect_equal(r_id, r_latest)

  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})

test_that("cart_produces_same_results_as_search_in_dev_mode",{
  temp_location <- file.path(tempdir(), "3")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)
  r_search <- dev_mode_HTTR("/search?includeObsolete=TRUE", body = NULL, request_type="POST")
  r_cart <-  dev_mode_HTTR("/cart/results.txt", query =NULL)
  expect_equal(r_search, r_cart)

  file_name <- file.path(temp_location, "results.txt")
  writeLines("Hello", con = file_name )
  r_search <- dev_mode_HTTR("/search?includeObsolete=TRUE", body = NULL, request_type="POST")
  r_cart <-  dev_mode_HTTR("/cart/results.txt", query =NULL)
  expect_equal(r_search, r_cart)

  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})


test_that("if_dev_mode_directory_is_empty_then_search_endpoint_has_empty_results_array_and_next_set_to_false",{
  temp_location <- file.path(tempdir(), "4")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)
  r <- dev_mode_HTTR("/search?includeObsolete=TRUE", body = NULL, request_type="POST")

  expect_equal(r$status_code, 200)
  expect_equal(rawToChar(r$content), '{"next":false,"results":[]}')
  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})


test_that("search_endpoint_returns_files_in_dev_mode_directory_in_appropriate_format",{
  temp_location <- file.path(tempdir(), "5")
  dir.create(temp_location)

  options(Bd4bsShinyUtils.dev_dir=temp_location)

  file_name <- file.path(temp_location, "results.txt")
  writeLines("Hello", con = file_name )
  file_name <- file.path(temp_location, "results2.txt")
  writeLines("Hello", con = file_name )

  r <- dev_mode_HTTR("/search?includeObsolete=TRUE", body = NULL, request_type="POST")

  expect_equal(r$status_code, 200)

  expected_ans <- paste0('{"next":false,"results":[{"RepoID":"dev_mode","Name":"results.txt",',
                   '"Description":"dev_mode","Tags":["dev_mode"],"KeyValueFields":[{"Key":"Key1","Value":',
                   '"Value1","Type":"STRING"},{"Key":"Key2","Value":1556236800000,"Type":"DATE"}],"DataID":"results.txt"},',
                  '{"RepoID":"dev_mode","Name":"results2.txt","Description":"dev_mode","Tags":["dev_mode"],',
                  '"KeyValueFields":[{"Key":"Key1","Value":"Value1","Type":"STRING"},{"Key":"Key2","Value":1556236800000,"Type":"DATE"}],',
                  '"DataID":"results2.txt"}]}')


  expect_equal(rawToChar(r$content), expected_ans)
  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})


test_that("post_endpoint_must_be_/_or_search",{
  temp_location <- file.path(tempdir(), "6")
  dir.create(temp_location)

  options(Bd4bsShinyUtils.dev_dir=temp_location)
  r <- dev_mode_HTTR("/test", request_type="POST")
  expect_equal(r$status_code, 400)
  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)
})


test_that("post_endpoint_adds_file_into_filestore",{
  temp_location <- file.path(tempdir(), "7")
  dir.create(temp_location)
  options(Bd4bsShinyUtils.dev_dir=temp_location)

  temp_file <- tempfile()
  writeLines("Hello this is some content", temp_file)

  metadata <- list(Name=jsonlite::unbox("test.txt"),
                   Description=jsonlite::unbox("testing description"),
                   Tags=c("t1", "t2"),
                   AccessGroups=c("A", "B"))

  r <- dev_mode_HTTR("/", request_type="POST", body=list(
    file = httr::upload_file(temp_file, type = "text/plain"),
    metadata =  jsonlite::toJSON(metadata)
  ))

  content <- jsonlite::fromJSON(httr::content(r, type="text", encoding="UTF-8"))
  expect_equal(names(content), c("Name", "Description", "DataID", "RepoID", "Tags", "KeyValueFields", "AccessGroups"))
  expect_equal(content$Name, "test.txt")
  expect_equal(content$Description, "example")
  expect_equal(content$DataID, "test.txt")
  expect_equal(content$RepoID, "dev-mode")
  expect_equal(content$Tags, c("example", "test"))

  expect_equal(list.files(temp_location), "test.txt")
  options(Bd4bsShinyUtils.dev_dir=NULL)
  unlink(temp_location)

})


test_that("error_if_request_type_is_not_GET_POST_OR_PUT",{
  expect_error(dev_mode_HTTR(url="/", request_type ="DELETE"))
  expect_error(dev_mode_HTTR(url="/", request_type ="get"))
  expect_error(dev_mode_HTTR(url="/", request_type ="foo bar"))
})

test_that("get_ad_groups_in_dev_mode_returns_dummy_AD_groups",{
  options(Bd4bsShinyUtils.dev_dir=".")

  r <- dev_mode_HTTR("/groupnames", request_type="GET")
  output <- httr::content(r, type="text", encoding = "UTF-8")
  expect_equal(output, '{"group1":"dev-group1","group2":"dev-group2"}')
  options(Bd4bsShinyUtils.dev_dir=NULL)

})
