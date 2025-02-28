#'Function which reads file from the local file store
#'@param filestore_location the path to the filestore
#'@param file_name the name of the file
#'@param file_read_function the function used to read in the file
#'@param ... additional arguments to the read function
#'@return the file, or throw an error if cannot read file
#'@export
access_local_filestore <- function(filestore_location, file_name, file_read_function=readLines, ...){

  file_location <- file.path(filestore_location, file_name)

  file_contents <- tryCatch(
    file_read_function(file_location, ...),
    error=function(cond){
      stop(paste("Cannot read file", file_name, cond$message))
    }
  )
  return(file_contents)
}
