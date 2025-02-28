library( datalabSDK )

get_auth_token <- function( env, session ) {

  on_platform <- identical( env, Environment$ON_PLATFORM )

  deployed <- !is.null( session ) && "x-auth-jwt" %in% names( session$request$HEADERS )

  if (on_platform) {

    if (deployed) {

      return( PlatformAuth()$get_token( session ) )

    } else {

      return ( "" )

    }

  } else {

    return ( SimplePersistedToken()$get_token( env, "temp.auth" ) )

  }

}

get_datalab_url <- function( env, suffix = "" ) {

  return( paste0( env$base_url, "/", suffix ) )

}

search_datalab <- function( client, env, token, input ) {
  
  error_message <- reactiveVal()
  results <- reactiveVal()
  
  observeEvent( input$datalab_search_ab, {
    
    error_message( NULL )
    results( NULL )
    
    tryCatch(
      
      withProgress( message = paste0( "Searching ", env$name ), value = 1, {
        
        body <- list( SearchTerm = input$datalab_search_ti, Page = 1 )
        
        search_results <- client$post( get_datalab_url( env, "search?includeObsolete=false" ), token, body )
        
        data_id <- unlist( lapply( search_results$results, function( x ) {x$DataID} ) )
        repo_id <- unlist( lapply( search_results$results, function( x ) {x$RepoID} ) )
        name <- unlist( lapply( search_results$results, function( x ) {x$Name} ) )
        description <- unlist( lapply( search_results$results, function( x ) {x$Description} ) )
        results( data.frame( repo_id, data_id, name, description ) )
        
      }),
      
      error = function( cond ) {
        
        print( cond$message )
        error_message( cond$message )
        
      }
      
    )
    
    if (is.null( error_message() )) {
      
      showNotification( "Search complete" )
      
    } else {
      
      showNotification( error_message(), type = "error" )
      
    }
    
  })
  
  return( results )
  
}

show_search_results <- function( results, output ) {
  
  observeEvent( results(), {
    
    if (is.null( results() )) {
      
      showNotification( "No search results", type = "error" )
      
    } else {
      
      output$datalab_search_ro <- renderReactable({
        
        reactable( data = results(), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
                   showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
        
      })
      
    }
    
  })
}