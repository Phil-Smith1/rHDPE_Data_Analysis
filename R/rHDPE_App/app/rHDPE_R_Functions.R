library( googledrive )
library( googlesheets4 )
library( tidyverse )

authorise_googledrive <- function( directory ) {
  
  options(

    gargle_oauth_email = TRUE,
    gargle_oauth_cache = paste0( directory, ".secrets" )

  )
  
  drive_auth()
  gs4_auth()
  
}

read_csv_from_gd <- function( directory, filename ) {
  
  file_info <- drive_get( filename )
  
  dir.create( paste0( "tmp/", directory ), showWarnings = FALSE, recursive = TRUE )
  
  drive_download( file_info$id, paste0( "tmp/", directory, file_info$name ), overwrite = TRUE )
  
  read_csv( paste0( "tmp/", directory, file_info$name ), col_select = 2:last_col() )
  
}
