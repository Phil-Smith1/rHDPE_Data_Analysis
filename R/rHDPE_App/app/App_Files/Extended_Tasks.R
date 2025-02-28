read_zip_from_gd <- function( directory, label ) {
  
  authorise_googledrive( "" )
  
  shiny_directory <- "shiny/www/Output/"
  filename <- paste0( "~/", shiny_directory, label, ".zip" )
  
  file_info <- drive_get( filename )
  
  drive_download( file_info$id, paste0( directory, file_info$name ), overwrite = TRUE )
  
  unzip( paste0( directory, file_info$name ), exdir = directory )
  
  print( paste0( "Completed download of ", label ) )
  
  return( TRUE )
  
}

save_zip_file_to_gd <- function( directory, label ) {
    
  authorise_googledrive( "" )
  
  setwd( directory )
  
  if (file.exists( paste0( label, ".zip" ) )) {
    
    file.remove( paste0( label, ".zip" ) )
    
  }
  
  zip( paste0( label, ".zip" ), list.files( label, recursive = TRUE, full.names = TRUE ) )
  
  drive_upload( paste0( label, ".zip" ), "shiny/www/Output/", overwrite = TRUE )
  
  setwd( Sys.getenv( "ORIGINALWD" ) )
  
  print( paste0( "Completed saving of ", label ) )
  
  return( TRUE )
  
}

read_initial_files_gd_et <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    authorise_googledrive( "" )
    
    file_info <- drive_get( "~/shiny/Dataset_Versions.xlsx" )
    drive_download( file_info$id, paste0( directory, file_info$name ), overwrite = TRUE )
    
    file_info <- drive_get( "~/shiny/List_of_Resins.zip" )
    drive_download( file_info$id, paste0( directory, file_info$name ), overwrite = TRUE )
    
    unzip( paste0( directory, file_info$name ), exdir = directory )
    
    print( "Completed download of initial files" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_initial_files_gd_et <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    authorise_googledrive( "" )
    
    setwd( directory )
    
    drive_upload( "Dataset_Versions.xlsx", "shiny/", overwrite = TRUE )
    
    if (file.exists( "List_of_Resins.zip" )) {
      
      file.remove( "List_of_Resins.zip" )
      
    }
    
    zip( paste0( "List_of_Resins.zip" ), list.files( pattern = "^List_of_Resins" ) )
    
    drive_upload( "List_of_Resins.zip", "shiny/", overwrite = TRUE )
    
    setwd( Sys.getenv( "ORIGINALWD" ) )
    
    print( "Completed saving of initial files" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_ftir <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    return( read_zip_from_gd( directory, "FTIR" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_ftir <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "FTIR" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_dsc <- ExtendedTask$new( function( directory ) {
    
  future_promise({
    
    return( read_zip_from_gd( directory, "DSC" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_dsc <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "DSC" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_tga <- ExtendedTask$new( function( directory ) {
    
  future_promise({
    
    return( read_zip_from_gd( directory, "TGA" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_tga <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "TGA" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_rheo <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "Rheology" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_rheo <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "Rheology" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_colour <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "Colour" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_colour <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "Colour" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_tt <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "TT" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_tt <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "TT" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_shm <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "SHM" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_shm <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "SHM" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_tls <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "TLS" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_tls <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "TLS" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_escr <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "ESCR" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_escr <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "ESCR" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_gcms <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "GCMS" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_gcms <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "GCMS" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_global <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "Global" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_global <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "Global" )
    
  }, queue = custom_work_queue )
  
})

read_zip_from_gd_et_raw_data <- ExtendedTask$new( function( directory ) {
  
  future_promise({
      
    return( read_zip_from_gd( directory, "Raw_Data" ) )
    
  }, queue = custom_work_queue )
  
})

save_zip_file_to_gd_et_raw_data <- ExtendedTask$new( function( directory ) {
  
  future_promise({
    
    save_zip_file_to_gd( directory, "Raw_Data" )
    
  }, queue = custom_work_queue )
  
})

upload_file_to_datalab <- function( client, env, token, name, description, dir, filename, ext, label, list_of_repoids ) {
  
  metadata <- list( Name = jsonlite::unbox( name ), Description = jsonlite::unbox( description ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )
  
  if (ext == "csv") {
    
    if (token != "") {
      
      req <- client$post( get_datalab_url( env ), token, body = list( file = upload_file( paste0( dir, filename ), type = "text/csv" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
      
    }
    
  }
  
  if (ext == "zip") {
    
    setwd( dir )
    
    if (file.exists( paste0( label, ".zip" ) )) {
      
      file.remove( paste0( label, ".zip" ) )
      
    }
    
    zip( paste0( label, ".zip" ), list.files( label, recursive = TRUE, full.names = TRUE ) )
    
    setwd( Sys.getenv( "ORIGINALWD" ) )
    
    if (token != "") {
      
      req <- client$post( get_datalab_url( env ), token, body = list( file = upload_file( paste0( dir, label, ".zip" ), type = "application/zip" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
      
    }
    
  }
  
  if (token != "") {
    
    list_of_repoids( list_of_repoids() %>% add_row( Identifier = label, RepoID = req$RepoID, Directory = dir, Filename = filename ) )
    
    write.csv( list_of_repoids(), "List_of_RepoIDs.csv", row.names = FALSE )
    
  } else {
    
    list_of_repoids( list_of_repoids() %>% add_row( Identifier = label, RepoID = label, Directory = dir, Filename = filename ) )
    
    write.csv( list_of_repoids(), "List_of_RepoIDs_Offline.csv", row.names = FALSE )
    
  }
  
  update_file_on_datalab( client, env, token, list_of_repoids(), "Repos", "PCR_Predictor_Tool_List_of_Repos.csv", "List of repos for the PCR Predictor Tool", "csv" )
  
}

read_file_from_datalab <- function( client, env, token, list_of_repoids, identifier, ext ) {
  
  repoid <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( RepoID )
  
  dir <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( Directory )
  
  filename <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( Filename )
  
  if (ext == "csv") {
    
    if (token != "") {
      
      r <- client$get( get_datalab_url( env, paste0( "latest/", repoid ) ), token, parse_response = FALSE )
      
      writeBin( content( r, "raw" ), paste0( dir, filename ) )
      
    }
    
  }
  
  if (ext == "zip") {
    
    if (token != "") {
      
      r <- client$get( get_datalab_url( env, paste0( "latest/", repoid ) ), token, parse_response = FALSE )
      
      writeBin( content( r, "raw" ), paste0( "tmp/", identifier, ".zip" ) )
      
      if (dir == "") {
        
        unzip( paste0( "tmp/", identifier, ".zip" ) )
        
      } else {
        
        unzip( paste0( "tmp/", identifier, ".zip" ), exdir = dir )
        
      }
      
    }
    
  }
  
}

update_file_on_datalab <- function( client, env, token, list_of_repoids, identifier, name, description, ext ) {
  
  repoid <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( RepoID )
  
  dir <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( Directory )
  
  filename <- list_of_repoids %>% filter( Identifier == identifier ) %>% pull( Filename )
  
  metadata <- list( Name = jsonlite::unbox( name ), Description = jsonlite::unbox( description ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )
  
  if (ext == "csv") {
    
    if (token != "") {
      
      req <- client$put( get_datalab_url( env, repoid ), token, body = list( file = upload_file( paste0( dir, filename ), type = "text/csv" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
      
    }
    
  }
  
  if (ext == "xlsx") {
    
    if (token != "") {
      
      req <- client$put( get_datalab_url( env, repoid ), token, body = list( file = upload_file( paste0( dir, filename ), type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
      
    }
    
  }
  
  if (ext == "zip") {
    
    setwd( dir )
    
    if (file.exists( paste0( identifier, ".zip" ) )) {
      
      file.remove( paste0( identifier, ".zip" ) )
      
    }
    
    zip( paste0( identifier, ".zip" ), list.files( identifier, recursive = TRUE, full.names = TRUE ) )
    
    setwd( Sys.getenv( "ORIGINALWD" ) )
    
    if (token != "") {
      
      req <- client$put( get_datalab_url( env, repoid ), token, body = list( file = upload_file( paste0( dir, identifier, ".zip" ), type = "application/zip" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
      
    }
    
  }
  
}

read_initial_files_datalab_et <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "Resins", "zip" )
    read_file_from_datalab( client, env, token, list_of_repoids, "Datasets", "csv" )
    
    print( "Completed download of initial files" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_initial_files_datalab_et <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    update_file_on_datalab( client, env, token, list_of_repoids, "Datasets", "PCR_Predictor_Tool_Dataset_Versions.xlsx", "Dataset versions for the PCR Predictor Tool", "xlsx" )
    
    if (file.exists( "List_of_Resins.zip" )) {
      
      file.remove( "List_of_Resins.zip" )
      
    }
    
    zip( paste0( "List_of_Resins.zip" ), list.files( pattern = "^List_of_Resins" ) )
    
    repoid <- list_of_repoids %>% filter( Identifier == "Resins" ) %>% pull( RepoID )
    
    metadata <- list( Name = jsonlite::unbox( "PCR_Predictor_Tool_List_of_Resins.zip" ), Description = jsonlite::unbox( "List of resins for the PCR Predictor Tool" ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )
    
    client$put( get_datalab_url( env, repoid ), token, body = list( file = upload_file( "List_of_Resins.zip", type = "application/zip" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
    
    print( "Completed saving of initial files" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_ftir <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "FTIR", "zip" )
    
    print( "Completed download of FTIR" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_ftir <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "FTIR"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of FTIR" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_dsc <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "DSC", "zip" )
    
    print( "Completed download of DSC" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_dsc <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "DSC"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of DSC" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_tga <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "TGA", "zip" )
    
    print( "Completed download of TGA" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_tga <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "TGA"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of TGA" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_rheo <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "Rheology", "zip" )
    
    print( "Completed download of Rheology" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_rheo <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "Rheology"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of Rheology" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_colour <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "Colour", "zip" )
    
    print( "Completed download of Colour" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_colour <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "Colour"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of Colour" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_tt <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "TT", "zip" )
    
    print( "Completed download of TT" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_tt <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "TT"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of TT" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_shm <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "SHM", "zip" )
    
    print( "Completed download of SHM" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_shm <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "SHM"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of SHM" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_tls <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "TLS", "zip" )
    
    print( "Completed download of TLS" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_tls <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "TLS"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of TLS" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_escr <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "ESCR", "zip" )
    
    print( "Completed download of ESCR" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_escr <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "ESCR"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of ESCR" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_gcms <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "GCMS", "zip" )
    
    print( "Completed download of GCMS" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_gcms <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "GCMS"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of GCMS" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_global <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "Global", "zip" )
    
    print( "Completed download of Global" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_global <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "Global"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of Global" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

read_file_from_datalab_et_raw_data <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    read_file_from_datalab( client, env, token, list_of_repoids, "Raw_Data", "zip" )
    
    print( "Completed download of Raw Data" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})

save_file_to_datalab_et_raw_data <- ExtendedTask$new( function( client, env, token, list_of_repoids ) {
  
  future_promise({
    
    label <- "Raw_Data"
    name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
    description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
    ext <- "zip"
    
    update_file_on_datalab( client, env, token, list_of_repoids, label, name, description, ext )
    
    print( "Completed saving of Raw Data" )
    
    return( TRUE )
    
  }, queue = custom_work_queue )
  
})