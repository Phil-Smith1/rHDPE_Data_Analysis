#===============
# Code relating to Bd4bsShinyUtils that is now redundant. Following steps outlined in writing-shiny-apps-for-bd4bs.Rmd found in vignettes directory in the downloaded package.

library( "Bd4bsShinyUtils" )

options( Bd4bsShinyUtils.dev_mode = TRUE )
options( Bd4bsShinyUtils.dev_dir = "File_Store" )

# In UI:

actionButton( "extract_button", "Extract data from DataLab" )

actionButton( "write_button", "Write data to DataLab" )

actionButton( "search_button_2", "Search DataLab" )

# In server:

filestore_location <- Bd4bsShinyUtils::setup_local_filestore( session )
onSessionEnded( function() Bd4bsShinyUtils::destroy_local_filestore( filestore_location ) )

observeEvent( input$extract_button, {

  showModal( Bd4bsShinyUtils::extract_platform_UI( "extract_ui", default_value = "", title = "Extract file" ) )

})

extracted_file <- callModule( Bd4bsShinyUtils::extract_platform, "extract_ui", filestore_location )

observeEvent( input$write_button, {

  access_data_gateway_write( paste0( "www/Output/FTIR/Sandbox/PP_Percentage_Analysis/Features/PP_Predictions", current_dataset(), ".csv" ), session, "PP_Predictions_Test_Upload.csv", access_groups = get_ad_groups( session ), file_type = "text/csv" )

})

observeEvent( input$search_button_2, {

  result <- access_data_gateway_by_search( session, "PP_Predictions_Test_Upload.csv", tags = NULL )

  access_data_gateway_by_id( result$results$DataID[1], session, filestore_location )

  access_local_filestore( filestore_location, "PP_Predictions_Test_Upload.csv", file_read_function = readr::read_csv )

})

#===============
# DataLab alternative code for achieving the same outcomes.

# In server (e.g. in an observeEvent):

# For writing a file.

metadata <- list( Name = jsonlite::unbox( 'R test' ), Description = jsonlite::unbox( 'Test upload in R' ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )

data <- tempfile()
writeLines( "Hello this is my file", data )

req <- POST( get_datalab_url( env ), body = list( file = upload_file( data, type = "text/plain" ), metadata = jsonlite::toJSON( metadata ) ),
             add_headers( c( get_headers( env, token ), "Content-Type" = "multipart/form-data" ) ), verbose() )

# Above but with client$post.

metadata <- list( Name = jsonlite::unbox( 'R test' ), Description = jsonlite::unbox( 'Test upload in R' ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )

data <- tempfile()
writeLines( "Hello this is my file", data )

req <- client$post( get_datalab_url( env ), token, body = list( file = upload_file( data, type = "text/plain" ), metadata = jsonlite::toJSON( metadata ) ), encode = "multipart" )

# For searching DataLab.

search.term <- input$datalab_search_text

body <- jsonlite::toJSON( list( SearchTerm = jsonlite::unbox( search.term ), Page = jsonlite::unbox( 1 ) ) )

search_url <- datalabSDK::get_public_api_url( env, "search?includeObsolete=false" )

r <- POST( search_url, body = body, add_headers( c( get_headers( env, token ), "Content-Type" = "application/json" ) ) )

res <- content( r )

print( paste0( "Repo ID is: ", res$results[[1]]$RepoID ) )

# Another alternative search of DataLab.

search.term <- input$datalab_search_text

body <- list( SearchTerm = search.term, Page = 1 )

r <- POST( get_datalab_url( env, "search?includeObsolete=false" ), body = body, add_headers( get_headers( env, token ) ), encode = "json" )

res <- content( r )

data.r <- GET( get_datalab_url( env, paste0( "id/", res$results[[1]]$DataID ) ), add_headers( get_headers( env, token ) ) )

size <- headers( data.r )$`Content-Length`

showNotification( paste0( "Search 2: ", res$results[[1]]$RepoID, "/", result$Name, " size = ", size ), type = "message" )

# Overwriting a file, PUT.

search.term <- input$datalab_search_text

body <- list( SearchTerm = search.term, Page = 1 )

r <- client$post( get_datalab_url( env, "search?includeObsolete=false" ), token, body = body )

res <- r

result <- res$results[[1]]

repoid <- result$RepoID

data <- tempfile()
writeLines( "Hello this is my updated file", data )

metadata <- list( Name = jsonlite::unbox( 'R test' ), Description = jsonlite::unbox( 'Test upload in R' ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )

req <- PUT( get_datalab_url( env, repoid ), body = list( file = upload_file( data, type = "text/plain" ), metadata =  jsonlite::toJSON( metadata ) ), add_headers( c( get_headers( env, token ), "Content-Type" = "multipart/form-data" ) ), verbose() )

# Overwriting a file, client$put.

search.term <- input$datalab_search_text

body <- list( SearchTerm = search.term, Page = 1 )

r <- client$post( get_datalab_url( env, "search?includeObsolete=false" ), token, body = body )

res <- r

result <- res$results[[1]]

repoid <- result$RepoID

metadata <- list( Name = jsonlite::unbox( 'R test custom' ), Description = jsonlite::unbox( 'Custom Test upload in R' ), Tags = 'httr', AccessGroups = 'BD4BS-PROD-Public' )

req <- client$put( get_datalab_url( env, repoid ), token, body = list( file = upload_file( "www/Output/FTIR/Sandbox/PP_Percentage_Analysis/Features/PP_Predictions.csv", type = "text/csv" ), metadata =  jsonlite::toJSON( metadata ) ), encode = "multipart" )