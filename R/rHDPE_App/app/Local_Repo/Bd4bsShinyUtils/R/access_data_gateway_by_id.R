#'Function which retrieves the data from the data access gateway and stores it locally for the shiny app
#'@description This function bypasses the extract modules and allows direct access to the platform. Therefore,
#'it is your responsibility to ensure errors thrown by this function are caught by the Shiny App.
#'Setting 'uid' to a valid file uid will bring the file into the filestore and give it the name of the uid, otherwise
#'setting 'repoID' to a valid repoID will bring the latest file for the given repoID into the file store, and it will be
#'given the name of the repoID. See the vignette for further details.
#'@param uid - the id of the file to retrieve (or NULL if repoid is not NULL)
#'@param session - the R Shiny session argument
#'@param filestore_location - the path to the filestore
#'@param file_descriptor - variable to make any errors more understandable at higher levels, if uid is NULL then this
#' should be set and the default value not used
#'@param repoID - if not NULL then get latest file from this repo id - note exactly one of uid and repoid should be non-NULL
#'@return TRUE if successful - throw error if not
#'@export
access_data_gateway_by_id <- function(uid, session, filestore_location, file_descriptor=uid, repoID=NULL){

  if(!xor(is.null(uid), is.null(repoID))){
    stop("Exactly one of uid and repoID must be NULL")
  }
  if(!"ShinySession" %in% class(session) && !"session_proxy" %in% class(session)){
    stop("The R Shiny session or session_proxy object should be passed into the access_data_gateway_by_id function")
  }
  if(is.null(file_descriptor)){
    stop(paste("file_descriptor argument cannot be NULL",
         "it should be a description of the file being extracted so that meaningful error messages can be given to users"))
  }

  path <- if(is.null(repoID)) paste0("/id/", uid) else paste0("/latest/", repoID)

  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY"), path)

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type="GET")

  if(r$status_code != 200 && r$status_code != 201){
    stop(paste("Cannot retrieve", file_descriptor, "file:", httr::http_status(r)$message))
  }

  #extract content
  bin <- httr::content(r, "raw")

  file_name <- if(is.null(repoID)) uid else repoID

  #write to file
  tryCatch(
    writeBin(bin, file.path(filestore_location, file_name)),
    error=function(cond){
      stop(paste("Cannot write file", file_descriptor, "to filestore", cond$message))
    }
  )

  return(TRUE)
}
