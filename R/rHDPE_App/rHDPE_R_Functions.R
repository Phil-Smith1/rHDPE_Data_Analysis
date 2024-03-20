library( googledrive )
library( googlesheets4 )

authorise_googledrive <- function( directory ) {
  
  options(
    
    gargle_oauth_email = TRUE,
    gargle_oauth_cache = paste0( directory, ".secrets" )
    
  )
  
  drive_auth()
  gs4_auth()
  
}

read_googlesheet <- function( filename ) {
  
  sheet_id <- drive_get( filename )$id
  
  read_sheet <- range_speedread(sheet_id)
  
}
