context("format_tag_list")

test_that("empty_vector_gives_empty_vector",{
  expect_equal(length(format_tag_list("")), 0)
})

test_that("string_without_commas_has_whitespace_trimmed",{
  expect_equal(length(format_tag_list("  ")), 0)
  expect_equal(format_tag_list(" hello\n"), "hello")
  expect_equal(format_tag_list("\tboo "), "boo")
})

test_that("string_without_commas_does not_have_internal_whitespace_trimmed",{
  expect_equal(format_tag_list(" foo bar "), "foo bar")
})

test_that("string_without_whitespace_is_unchanged",{
  expect_equal(format_tag_list("foo-bar"), "foo-bar")
  expect_equal(format_tag_list("foo,bar"), c("foo","bar"))
})

test_that("string_with_only_whitespace_between_commas_has_comma_removed",{
  expect_equal(format_tag_list("foo,  ,bar"), c("foo","bar"))
  expect_equal(format_tag_list("foo,,bar"), c("foo","bar"))
})

test_that("string_with_whitespace_adjacent_to_commas_has_this_whitespace_removed",{
  expect_equal(format_tag_list("foo , bar "), c("foo","bar"))
  expect_equal(format_tag_list("foo , bar, foo bar\t\n    , bar "), c("foo","bar","foo bar","bar"))
})
