# Resin metadata tab server code.

output$metadata_dataset_version_to <- renderText( paste0( "The current version of the dataset is: ", input$settings_dataset_version_si, "\nIf you wish to change the dataset version, go to settings." ) ) 

output$metadata_table_ro <- renderReactable({
  
  reactable( data = metadata_r$metadata_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE,
             columns = list( Name = colDef( width = 300 ) ) )
  
})

