# Tab for displaying resin metadata.

resinMetadataTab <- tabPanel( "Resin Metadata",
                              
  sidebarLayout(
    
    sidebarPanel(
      
      wellPanel(
        
        p( "Select the checkbox below to make edits to the table." ),
        
        checkboxInput( "metadata_edit_table_cb", "Edit table" )
      
      ),
      
      wellPanel(
        
        p( "By adding columns to the table (e.g. Supplier, Region), you can select resins by these properties in the other functions of the tool." ),
      
        actionButton( "metadata_add_column_ab", "Add Column", width = "100%" ),
        actionButton( "metadata_delete_column_ab", "Delete Column", width = "100%" )
        
      ),
      
      wellPanel(
        
        p( "All edits must be saved to make them permanent." ),
        
        actionButton( "metadata_save_ab", "Save Edits", width = "100%" )
        
      ),
      
      width = 2
      
    ),
    
    mainPanel(
      
      br(),
      
      span( textOutput( "metadata_dataset_version_to" ), style = "text-align: center" ),
      
      br(),
      
      reactableOutput( "metadata_table_ro" ),
      
      width = 10
      
    )
    
  )
  
)
