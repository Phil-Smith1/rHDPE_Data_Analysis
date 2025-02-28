emulate_write_endpoint <- function(url, query, body, request_type){

  if(request_type == "POST" && url != "/"){
    return(create_response(400))
  }

  r <- tryCatch({
    destination_filename <- jsonlite::fromJSON(body$metadata)$Name
    destination_location <- file.path(getOption("Bd4bsShinyUtils.dev_dir"), destination_filename)

    if(request_type == "PUT" && !file.exists(destination_location)){
      return(create_response(404))
    }

    file.copy(from=body$file$path, to=destination_location)
    text <- jsonlite::toJSON(list(Name=jsonlite::unbox(destination_filename), Description=jsonlite::unbox("example"),
                DataID=jsonlite::unbox(destination_filename), RepoID=jsonlite::unbox("dev-mode"),
                Tags=c("example", "test"),KeyValueFields=list(list(Key=jsonlite::unbox("example_key"),
                  CategoryPath=character(0),Value=jsonlite::unbox("example_value"), Type=unbox("STRING"))),AccessGroups="test"))
    create_response(200, content=charToRaw(text))
  },
  warning=function(cond) create_response(400),
  error=function(cond) create_response(400))

  return(r)
}
