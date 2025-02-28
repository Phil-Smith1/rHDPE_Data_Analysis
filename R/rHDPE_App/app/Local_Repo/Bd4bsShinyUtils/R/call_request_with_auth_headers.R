#function to perform a http call with the authentication required by BD4BS
#url - the url for the get
#request_type - the HTTP request to be used
#query - list of parameters for the request (e.g list(q="query_string"))
#body - the body of the request
#headers - a named vector of headers required for the request
#dev_mode_HTTR_function - function to use
#return the result of the request
call_request_with_auth_headers <- function(url, session, request_type, query=NULL,
                                           body=NULL, headers=NULL, dev_mode_HTTR_function=dev_mode_HTTR){

  if(in_dev_mode()){
    dev_mode_HTTR_function(url, query=query, body=body, request_type=request_type)
  }
  else{
    request_function <- switch(request_type,
                               GET=httr::GET,
                               POST=httr::POST,
                               PUT=httr::PUT,
                               stop("Invalid request type"))

    if(is.na(as.character(session$request$HEADERS["x-auth-jwt"]))){ #if running inside RStudio on BD4BS
      request_function(url, query=query,body=body, httr::add_headers(headers))
    }
    else{
      request_function(url, query=query,body=body, httr::add_headers(headers),
        httr::add_headers("X-AUTH-SUBJECT"=as.character(session$request$HEADERS["x-auth-subject"]),
                        "X-AUTH-JWT"=as.character(session$request$HEADERS["x-auth-jwt"]),
                        "X-AUTH-GROUPS"= as.character(session$request$HEADERS["x-auth-groups"])) )
    }
  }
}
