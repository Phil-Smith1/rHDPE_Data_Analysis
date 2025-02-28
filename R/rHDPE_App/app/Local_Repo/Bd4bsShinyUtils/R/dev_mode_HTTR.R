dev_mode_HTTR <- function(url, query, body, request_type="GET"){

  if(is.null(getOption("Bd4bsShinyUtils.dev_dir"))){
    stop("options('Bd4bsShinyUtils.dev_dir') must be set when running in dev_mode")
  }

  if(!request_type %in% c("GET", "POST", "PUT")){
    stop("request type must be GET, POST or PUT")
  }

  url_path <- strsplit(url, "/")[[1]]

  #handle PUT and POST first
  if(request_type %in% c("POST", "PUT")){
    extract_endpoint <- strsplit(tail(url_path,1), "\\?")[[1]]
    if(request_type == "POST" && length(extract_endpoint)>0 && extract_endpoint[1] == "search"){
      return(emulate_search_endpoint())
    }
    return(emulate_write_endpoint(url, query, body, request_type))
  }
  ######

  # Handle GET requests here

  #find out which api call it is - note cart GET and search POST behave
  #the same in this mock as do id and latest
  if(length(url_path)==2 && all(url_path==c("", "groupnames"))){
    api_type <- "groups"
  }
  else{
    api_type <- switch(url_path[length(url_path)-1],
      id="id",
      cart="search",
      latest="id",
      "unknown"
    )
  }



  if(api_type=="id"){
    return(emulate_id_endpoint(url_path))
  }else if(api_type=="search"){
    return(emulate_search_endpoint())
  }else if(api_type== "groups"){
    return(emulate_groups_endpoint())
  }
  else{
    return(create_response(404))
  }
}
