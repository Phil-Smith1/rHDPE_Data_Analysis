#constructor for request response in dev-mode
create_response <- function(status_code, content=""){
  #note with url="" omitted httr::content(r, "text", encoding = "UTF-8") fails on Linux but works on Windows
  structure(list(status_code=status_code, content=content, url=""), class="response")
}
