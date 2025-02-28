#function which takes a vector of its and the location of the files
#(filestore_location) and extracts the files from BD4BS data store
#copying them into the app's local store with a progress bar
#showing the number of files so far extracted
extract_selected_files <- function(file_ids, session, filestore_location){
  number_files <- length(file_ids)

  withProgress(message = "Extracting file from BD4BS", detail=paste("file 1 of", number_files), value = 0,{
    for(i in seq_along(file_ids)){
      file_id <- file_ids[i]
      incProgress(1/number_files, detail = paste("file", i, "of", number_files))
      access_data_gateway_by_id(file_id, session, filestore_location)
    }
  })
}
