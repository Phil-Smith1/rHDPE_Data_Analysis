##' Function to write file to BD4BS file store
##' @param file The path to the file being uploaded to the platform
##' @param session The Shiny session object
##' @param name The name of the file as referred to in the file store
##' @param description The description of the file for the file store
##' @param tags Vector of tags for the file
##' @param custom_metadata_key_values list of custom meta data fields for the file or (default) list() if no fields
##' Each key-value is a list of the form:
##' Key=unbox("key"), CategoryPath=character(0), Value=unbox("value"), Type=unbox(<<"STRING"|"NUMBER"|"BOOLEAN"|"DATE">>)
##' where value is a string, number, boolean (true/false) or date (in format as.numeric(as.POSIXct("2014-01-01")) *1000)
##' see vignette for further information
##' @param access_groups A vector of AD groups for the file.
##' Note the AD groups of the current user can be retrieved using the "get_ad_groups" function.
##' @param file_type the file type being uploaded (default 'text/plain') if unsure can use the function mime::guess_type()
##' @param repoID if NULL (default) then the file is uploaded using POST and creates a new data repository, otherwise it updates
##' a data entry within the data repository referenced by repoID. See the package vignette for more details
##' @return A named list containing Name, Description, Tags, DataID (the hash of the uploaded file),
##' RepoID and AccessGroups. If request was not successful then an error is thrown
##' @export
access_data_gateway_write <- function(file, session, name, description="", tags=character(0),
                                      access_groups, custom_metadata_key_values=list(), file_type="text/plain", repoID=NULL){

  metadata <- list(Name=jsonlite::unbox(name),
                   Description=jsonlite::unbox(description),
                   Tags=tags, KeyValueFields=custom_metadata_key_values,
                   AccessGroups=access_groups)

  body <- tryCatch(
            list(
              file = httr::upload_file(file, type = file_type),
              metadata =  jsonlite::toJSON(metadata)
            ),
            error=function(cond){
              stop(paste("Could not create request:", cond$message))
          })

  request_type <- if(is.null(repoID)) "POST" else "PUT"

  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY") ,"/", repoID)

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type=request_type, body=body,
                                      headers=c("Content-Type" = "multipart/form-data"))

  if(r$status_code != 200 && r$status_code != 201){
    stop(paste("Cannot perform write:", httr::http_status(r)$message))
  }

  #return the content as JSON
  result <- tryCatch({
    content <- jsonlite::fromJSON(httr::content(r, "text", encoding = "UTF-8"))
    expected_values <- c("Name", "Description", "DataID", "RepoID", "Tags", "AccessGroups")
    if(any(!expected_values %in% names(content))){
      stop("expected entries not found")
    }
    content},
    error=function(cond){
      stop(paste("Invalid JSON response", cond$message))
  })

  return(result)
}
