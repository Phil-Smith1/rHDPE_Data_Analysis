#'Create the filestore for this session's files
#'@param session The R Shiny session object
#'@param root_dir The directory in which /tmp/file_store/<<unique session token>>
#'is to be stored. When running a Shiny App on BD4BS this should be set to
#'the directory where the server.R/app.R file is located which by default will be the
#'working directory
#'@return returns path to filestore if successful
#'throws error if cannot create store
#'@details
#'The following code should be added to server.R:
#'\code{filestore_location <- setup_local_filestore(session)
#'onSessionEnded(function(){
#'  destroy_local_filestore(filestore_location)
#'})}
#'@export
setup_local_filestore <- function(session, root_dir=getwd()){

  if(!"ShinySession" %in% class(session)){
    stop("The R Shiny session object should be passed into the setup_local_filestore function")
  }

  if(length(root_dir) != 1 || !is.character(root_dir) || nchar(root_dir) == 0){
    stop("invalid root_dir argument")
  }

  filestore_location <- file.path(root_dir, "tmp", "file_store", session$token)
  if(!dir.create(filestore_location, recursive=TRUE)){
    stop("Could not create local file store")
  }
  return(filestore_location)
}
