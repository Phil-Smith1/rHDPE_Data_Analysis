#===============
# Linking to DataLab Filestore.

env <- Environment$ON_PLATFORM
token <- get_auth_token( env, session )
client <- RawClient( env )

# Search DataLab.

results <- search_datalab( client, env, token, input )
show_search_results( results, output )

observeEvent( input$datalab_read_zip_ab, {
  
  label <- input$datalab_label_update_ti
  ext <- "zip"
  
  read_file_from_datalab( client, env, token, list_of_repoids(), label, ext )
  
})

observeEvent( input$datalab_read_ab, {
  
  ext <- input$datalab_ext_update_ti
  label <- input$datalab_label_update_ti
  
  read_file_from_datalab( client, env, token, list_of_repoids(), label, ext )
  
})

observeEvent( input$datalab_update_zip_ab, {
  
  label <- input$datalab_label_update_ti
  
  name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
  description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
  ext <- "zip"
  
  update_file_on_datalab( client, env, token, list_of_repoids(), label, name, description, ext )
  
})

observeEvent( input$datalab_update_ab, {
  
  name <- input$datalab_name_update_ti
  description <- input$datalab_description_update_ti
  ext <- input$datalab_ext_update_ti
  label <- input$datalab_label_update_ti
  
  update_file_on_datalab( client, env, token, list_of_repoids(), label, name, description, ext )
  
})

observeEvent( input$datalab_upload_zip_ab, {
  
  label <- input$datalab_label_upload_ti
  
  name <- paste0( "PCR_Predictor_Tool_", label, ".zip" ) 
  description <- paste0( "PCR Predictor Tool ", label, " Data" ) 
  dir <- "www/Output/"
  filename <- ""
  ext <- "zip"
  
  upload_file_to_datalab( client, env, token, name, description, dir, filename, ext, label, list_of_repoids )
  
})

observeEvent( input$datalab_upload_ab, {
  
  name <- input$datalab_name_upload_ti
  description <- input$datalab_description_upload_ti
  dir <- input$datalab_dir_upload_ti
  filename <- input$datalab_filename_upload_ti
  ext <- input$datalab_ext_upload_ti
  label <- input$datalab_label_upload_ti
  
  upload_file_to_datalab( client, env, token, name, description, dir, filename, ext, label, list_of_repoids )
  
})

observeEvent( input$datalab_upload_ab_lor, {
  
  metadata <- list( Name = jsonlite::unbox( "PCR_Predictor_Tool_List_of_Resins.zip" ), Description = jsonlite::unbox( "List of resins for the PCR Predictor Tool" ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )
  
  if (file.exists( "List_of_Resins.zip" )) {
    
    file.remove( "List_of_Resins.zip" )
    
  }
  
  zip( paste0( "List_of_Resins.zip" ), list.files( pattern = "^List_of_Resins" ) )
  
  req <- client$post( get_datalab_url( env ), token, body = list( file = upload_file( paste0( "List_of_Resins.zip" ), type = "application/zip" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
  
  list_of_repoids( list_of_repoids() %>% add_row( Identifier = "Resins", RepoID = req$RepoID, Directory = "", Filename = "" ) )
    
  write.csv( list_of_repoids(), "List_of_RepoIDs.csv", row.names = FALSE )
  
  update_file_on_datalab( client, env, token, list_of_repoids(), "Repos", "PCR_Predictor_Tool_List_of_Repos.csv", "List of repos for the PCR Predictor Tool", "csv" )
  
})

observeEvent( input$datalab_upload_ab_dv, {
  
  metadata <- list( Name = jsonlite::unbox( "PCR_Predictor_Tool_Dataset_Versions.xlsx" ), Description = jsonlite::unbox( "Dataset versions for the PCR Predictor Tool" ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )
  
  req <- client$post( get_datalab_url( env ), token, body = list( file = upload_file( paste0( "Dataset_Versions.xlsx" ), type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )
  
  list_of_repoids( list_of_repoids() %>% add_row( Identifier = "Datasets", RepoID = req$RepoID, Directory = "", Filename = "Dataset_Versions.xlsx" ) )
  
  write.csv( list_of_repoids(), "List_of_RepoIDs.csv", row.names = FALSE )
  
  update_file_on_datalab( client, env, token, list_of_repoids(), "Repos", "PCR_Predictor_Tool_List_of_Repos.csv", "List of repos for the PCR Predictor Tool", "csv" )
  
})