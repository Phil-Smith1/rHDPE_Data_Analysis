##' Function to write dataset files to BD4BS file store
##' @param session The Shiny session object
##' @param name The name of the dataset
##' @param description The description of the dataset
##' @param tags vector of tags for the dataset
##' @param custom_metadata_key_values list of custom meta data fields for the dataset or (default) list() if no fields
##' Each key-value is a list of the form:
##' Key=unbox("key"), CategoryPath=character(0), Value=unbox("value"), Type=unbox(<<"STRING"|"NUMBER"|"BOOLEAN"|"DATE">>)
##' where value is a string, number, boolean (true/false) or date (in format as.numeric(as.POSIXct("2014-01-01")) *1000)
##' see vignette (section about writing files to the platform) for further information
##' @param access_groups A vector of AD groups for the dataset.
##' Note the AD groups of the current user can be retrieved using the "get_ad_groups" function.
##' @param datasetID if NULL (default) then the dataset is created using POST and creates a new dataset, otherwise it updates
##' a dataset referenced by datasetID.
##' @param child_repo_ids a vector of repoIds to be added into the dataset (note NOT dataIDs)
##' @param child_dataset_ids a vector of datasetIds to be added into the dataset
##' @param child_repo_ids_to_remove a vector of repoIds already in the dataset to be removed (if datasetID is NULL)
##' @param child_dataset_ids_to_remove a vector of datasetIds already in the dataset to be removed (if datasetID is NULL)
##' @return The datasetID of the created/updated dataset
##' @export
access_data_gateway_dataset_write <- function(session, name, description="", tags=character(0),
                                      access_groups, custom_metadata_key_values=list(), datasetID=NULL,
                                      child_repo_ids=list(), child_dataset_ids=list(),
                                      child_repo_ids_to_remove=list(), child_dataset_ids_to_remove=list()){


  data <- list(dataset=list(Name=jsonlite::unbox(name),
                   Description=jsonlite::unbox(description),
                   Tags=tags, KeyValueFields=custom_metadata_key_values,
                   AccessGroups=access_groups),
               repoIds=list(added=child_repo_ids, removed=child_repo_ids_to_remove),
               datasetIds=list(added=child_dataset_ids, removed=child_dataset_ids_to_remove))

  body <- tryCatch(jsonlite::toJSON(data),
    error=function(cond){
      stop(paste("Could not create request:", cond$message))
    })

  request_type <- if(is.null(datasetID)) "POST" else "PUT"

  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY") ,"/dataset/", datasetID)

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type=request_type, body=body,
                                      headers=c("Content-Type" = "application/json"))

  if(httr::status_code(r) != 200 && httr::status_code(r) != 201){
    stop(paste("Cannot perform dataset write:", httr::http_status(r)$message))
  }

  #return the id
  return(httr::content(r)$id)
}
