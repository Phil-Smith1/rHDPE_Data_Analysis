emulate_search_endpoint <- function(){
  r <- tryCatch({
    file_names <- list.files(getOption("Bd4bsShinyUtils.dev_dir"))

    if(length(file_names) > 0){
      number_files <- length(file_names)

      results <-lapply(file_names, function(file_name){
        list(RepoID=unbox("dev_mode"),
        Name=unbox(file_name),
        Description=unbox("dev_mode"),
        Tags=c("dev_mode"),
        KeyValueFields=list(list(Key=unbox("Key1"), Value=unbox("Value1"), Type=unbox("STRING")),
                            list(Key=unbox("Key2"), Value=unbox(1556236800000), Type=unbox("DATE"))),
        DataID=unbox(file_name))
      })
      text <- list("next"=jsonlite::unbox(FALSE),
                   results=results)
      text <- jsonlite::toJSON(text)
    }
    else{
      text <- jsonlite::toJSON(list("next"=unbox(FALSE), results=list()))
    }
    create_response(200, content=charToRaw(text))
  },
  warning=function(cond) create_response(400),
  error=function(cond) create_response(400)
  )

  return(r)
}
