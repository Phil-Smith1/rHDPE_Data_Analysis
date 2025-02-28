#function which takes a character vector (length 1) and
#removes white spaces around commas and returns a vector so if the input was
# "x ,  foo bar ,, foo" then the output will be c("x","foo bar","foo")
format_tag_list <- function(search_tags){
  list_of_tags <- trimws(unlist(strsplit(search_tags, ",")))
  #remove empty tags and white space in tags
  list_of_tags[list_of_tags != ""]
}
