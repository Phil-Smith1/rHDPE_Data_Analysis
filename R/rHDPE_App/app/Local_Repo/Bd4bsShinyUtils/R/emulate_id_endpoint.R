emulate_id_endpoint <- function(url_path){
  r <- tryCatch({
    file_name <- file.path(getOption("Bd4bsShinyUtils.dev_dir"), url_path[length(url_path)])
    con <- file(file_name, "rb")
    content <- readBin(con, "raw", file.info(file_name)$size)
    close(con)
    create_response(200, content)
  },
  warning=function(cond) create_response(404),
  error=function(cond) create_response(404))

  return(r)
}
