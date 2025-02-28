library( googledrive )
library( googlesheets4 )
library( tidyverse )

options(
  
  gargle_oauth_email = TRUE,
  gargle_oauth_cache = ".secrets"
  
)

drive_auth()
gs4_auth()

dirs <- drive_ls( "~/Input/CSVs/" )$name

for (name in dirs) {
  
  name2 <- drive_ls( paste0("~/Input/CSVs/", name, "/" ) )$name
  id2 <- drive_ls( paste0("~/Input/CSVs/", name, "/" ) )$id

  for (n in 1:length( name2 )){
    
    name2[n] <- substr(name2[n], 1, nchar( name2[n] ) - 4)
    
  }

  for (i in 1:length( id2 )) {
    
    temp <- tempfile()
    dl <- drive_download(id2[i], path = temp, overwrite = TRUE)
    cv <- read.csv(temp, sep = ",") %>% select(-X)
    write.csv(cv, paste0(temp, ".csv"), row.names = FALSE)
    
    tryCatch({
      drive_mkdir( name, path = "Input/Sheets/", overwrite = FALSE )
    },
    error = function( c ) {
      NA
    })
    
    drive_upload( paste0( temp, ".csv" ), path = paste0( "~/Input/Sheets/", name, "/", name2[i] ), type = "spreadsheet", overwrite = TRUE )
    
  }
  
}
