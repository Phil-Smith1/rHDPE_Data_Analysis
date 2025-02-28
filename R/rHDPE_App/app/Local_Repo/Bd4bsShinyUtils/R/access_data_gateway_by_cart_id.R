# function to access the /cart endpoint of the BD4BS Shiny sidecar
# cart_uid - the uid of the cart to be called
# return the JSON output of the response or error if failure
access_data_gateway_by_cart_id <- function(session, cart_uid){

  #generate the url and parameters for the request
  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY") ,"/cart/", cart_uid)

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type="GET")

  if(r$status_code != 200 && r$status_code != 201){
    stop(paste("Cannot perform search:", httr::http_status(r)$message))
  }

  #return the content as JSON
  return(jsonlite::fromJSON(httr::content(r, "text", encoding = "UTF-8")))
}
