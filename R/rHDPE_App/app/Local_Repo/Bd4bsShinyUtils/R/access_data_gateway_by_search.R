#'Function to access the seach API of the BD4BS Shiny sidecar
#'@description This function bypasses the extract modules and allows direct access to the platform. Therefore,
#'it is your responsibility to ensure errors thrown by this function are caught by the Shiny App.
#'@param session The R shiny session object
#'@param query - the text to search for in the search api call
#'@param tags - vector of tags for the call to the search api - set to list() if no tags
#'@param key_value_query - list of key values for search (see key_value.R and key_value_filter.R for more details)
#'@param page - the API returns 1000 records per page and this argument defines which
#'       page of results we would like to return.
#'@param dataset_search should the search be for datasets (TRUE) or data files (FALSE - default). If this is set to TRUE then
#'       the include_obsolete argument must be FALSE.
#'@param convert_from_json should the function return the json of the response (TRUE) or convert it to R object using
#'\code{jsonlite::fromJSON} (FALSE)
#'@param include_obsolete - whether to return obsolete files (defaults to FALSE).
#'       In dev-mode the include_obsolete parameter to the search endpoint is ignored
#'@return the content of the response (JSON or converted to R objects depending on value of convert_from_json parameter).
#'The function throws an error if unsuccessful
#'@export
access_data_gateway_by_search <- function(session, query, tags, key_value_query=list(), page=1, dataset_search=FALSE, convert_from_json=!dataset_search, include_obsolete=FALSE){

  #generate the url and parameters for the request
  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY"), if(dataset_search) "/dataset" else "" ,"/search")

  if(include_obsolete && dataset_search){
    stop("Cannot include obsolete argument with dataset search")
  }

  if(!dataset_search){
    url <- paste0(url, "?includeObsolete=",include_obsolete)
  }

  body <- jsonlite::toJSON(list(SearchTerm=jsonlite::unbox(query), Page=unbox(page),
                                Tags=tags, KeyValueFacets=key_value_query))

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, body=body, request_type="POST",
                                      headers=c("Content-Type"="application/json"))

  if(httr::status_code(r) != 200 && httr::status_code(r) != 201){
    stop(paste("Cannot perform search:", httr::http_status(r)$message))
  }

  #return the content as JSON
  response_content <- httr::content(r, "text", encoding = "UTF-8")
  if(convert_from_json){
    response_content <- jsonlite::fromJSON(response_content)
  }

  return(response_content)
}
