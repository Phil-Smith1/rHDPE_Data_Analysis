# Resin metadata tab server code.

show_metadata_modal_add_column <- function() {
    
  showModal(
    
    modalDialog( title = "Column Title",
                          
      textInput( "metadata_modal_add_column_column_title_ti", "Input the column title" ),
      
      footer = tagList( actionButton( "metadata_modal_add_column_submit", "Submit" ), modalButton( "Dismiss" ) )
    
    )
                          
  )
  
}

show_metadata_modal_delete_column <- function() {
  
  column_names <- names( resin_data_r_copy$copy2 )
  
  column_names <- column_names[column_names %in% c( "Identifier", "Name", "Label", "Class", "Supplier", "Notes", "FTIR", "DSC", "TGA", "Rheology", "Colour", "TT", "SHM", "TLS", "ESCR", "GCMS" ) == FALSE]  
    
  showModal(
    
    modalDialog( title = "Delete Column",
                          
      selectizeInput( "metadata_modal_delete_column_si", "Select the column to delete", choices = column_names, options = list( placeholder = "Please select an option below" ) ),
      
      footer = tagList( actionButton( "metadata_modal_delete_column_submit", "Submit" ), modalButton( "Dismiss" ) )
    
    )
                          
  )
  
}

output$metadata_dataset_version_to <- renderText( paste0( "The current version of the dataset is '", input$settings_dataset_version_si, "'. If you wish to change the dataset version, go to settings." ) ) 

output$metadata_table_ro <- renderReactable({
  
  if (!input$metadata_edit_table_cb) {
    
    reactable( data = resin_data_r(), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
               showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE,
               columns = list( Name = colDef( width = 300 ), Supplier = colDef( width = 300 ), Notes = colDef( show = FALSE ) ) )
    
  } else {
    
    column_names <- names( resin_data_r_copy$copy1 )
    
    column_names <- column_names[column_names %in% c( "Identifier", "Name", "Class", "Supplier", "Notes", "FTIR", "DSC", "TGA", "Rheology", "Colour", "TT", "SHM", "TLS", "ESCR", "GCMS" ) == FALSE]
    
    coldefs <- list()
    
    if (length( column_names ) >= 1) {
      
      coldefs <- lapply( 4:(3 + length( column_names )), function( x ) colDef( cell = text_extra( id = paste0( "metadata_", as.character( x ), "_te" ) ) ) )
      
      names( coldefs ) <- column_names
      
    }
    
    reactable( data = resin_data_r_copy$copy1, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
               showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE,
               columns = c( list( Name = colDef( cell = text_extra( id = "metadata_1_te" ), width = 300 ), Class = colDef( cell = dropdown_extra( id = "metadata_2_de", unique( resin_data_r()$Class ), class = "dropdown-extra" ) ), Supplier = colDef( cell = text_extra( id = "metadata_3_te" ), width = 300 ), Notes = colDef( show = FALSE ) ), coldefs ) )
    
  }
  
})

resin_data_r_copy <- reactiveValues( copy1 = NULL, copy2 = NULL )

observeEvent( resin_data_r(), { 
  
  resin_data_r_copy$copy1 <- resin_data_r()
  resin_data_r_copy$copy2 <- resin_data_r()
  
} )

lapply( 1:14, function( x ) {
  
  observeEvent( input[[paste0( "metadata_", as.character( x ), "_te" )]], {
    
    resin_data_r_copy$copy2[input[[paste0( "metadata_", as.character( x ), "_te" )]]$row, input[[paste0( "metadata_", as.character( x ), "_te" )]]$column] <- input[[paste0( "metadata_", as.character( x ), "_te" )]]$value
    
  })
  
})

observeEvent( input$metadata_add_column_ab, {
  
  show_metadata_modal_add_column()
  
})

observeEvent( input$metadata_delete_column_ab, {
  
  show_metadata_modal_delete_column()
  
})

observeEvent( input$metadata_modal_add_column_submit, {
  
  removeModal()
  
  resin_data_r_copy$copy1 <- add_column( resin_data_r_copy$copy1, !!input$metadata_modal_add_column_column_title_ti := NA, .before = "FTIR" )
  resin_data_r_copy$copy2 <- add_column( resin_data_r_copy$copy2, !!input$metadata_modal_add_column_column_title_ti := NA, .before = "FTIR" )
  
})

observeEvent( input$metadata_modal_delete_column_submit, {
  
  removeModal()
  
  resin_data_r_copy$copy1 <- resin_data_r_copy$copy1[, !(names( resin_data_r_copy$copy1 ) %in% c( input$metadata_modal_delete_column_si ))]
  resin_data_r_copy$copy2 <- resin_data_r_copy$copy2[, !(names( resin_data_r_copy$copy2 ) %in% c( input$metadata_modal_delete_column_si ))]
  
})

observeEvent( input$metadata_save_ab, {
  
  if (current_dataset() == "") showNotification( "The resin metadata of the original dataset version cannot be modified. Create a new dataset version or select a different dataset version in Settings." )
  
  req( current_dataset() != "" )
  
  resin_data_r( resin_data_r_copy$copy2 )
  
  write_xlsx( resin_data_r(), paste0( directory, "List_of_Resins", current_dataset(), ".xlsx" ) )
  
  initial_files$save <- TRUE
  
  perform_save_of_data()
  
})

