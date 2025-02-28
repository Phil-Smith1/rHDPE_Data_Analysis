#'Function which retrieves the AD group names for the user of the app
#'@description This function gets the AD group names the current user has access to.
#'@param session - the R Shiny session argument
#'@return vector of user group names for example c("BD4BS-PROD-PUBLIC"). In dev mode this
#'returns c("dev-group1", "dev-group2")
#'@export
get_ad_groups <- function(session){

  if(!"ShinySession" %in% class(session) && !"session_proxy" %in% class(session)){
    stop("The R Shiny session or session_proxy object should be passed into the get_ad_groups function")
  }

  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY"), "/groupnames")

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type="GET")

  if(httr::status_code(r) != 200 && httr::status_code(r) != 201){
    stop(paste("Cannot retrieve AD groups of user:", httr::http_status(r)$message))
  }

  #return the array of AD groups for the user
  groups <- unlist(jsonlite::fromJSON(httr::content(r, "text", encoding = "UTF-8")))
  names(groups) <- NULL
  return(groups)
}
