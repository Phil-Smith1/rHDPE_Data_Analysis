#'Recursively deletes files from given location
#'@param filestore_location the path (from the location of the shiny app) to the
#'filestore location
#'@return 0 for success, 1 for failure, invisibly. See unlink function documentation
#'for further details
#'@details
#'This function should be called when shiny session ends to
#'delete the local file store for the given session.
#'The following code should be added to server.R:
#'\code{filestore_location <- setup_local_filestore(session)
#'onSessionEnded(function(){
#'  destroy_local_filestore(filestore_location)
#'})}
#'@export
destroy_local_filestore <- function(filestore_location){
  unlink(filestore_location, recursive = TRUE)
}
