emulate_groups_endpoint <- function(){
  output <- jsonlite::toJSON(list(group1=jsonlite::unbox("dev-group1"), group2=jsonlite::unbox("dev-group2")))
  create_response(200, content=charToRaw(output))
}
