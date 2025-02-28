# Tab for displaying file data.

fileDataTab <- tabPanel( "File Data",
                         
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput( "filedata_select_dataset_si", "Select resin:", choices = experiments ),
      
      actionButton( "filedata_hide_ab", "Hide" ),
      
      actionButton( "filedata_unhide_ab", "Unhide" ),
      
      actionButton( "filedata_delete_data_ab", "Delete Data" )
      
    ),
    
    mainPanel(
      
      reactableOutput( "filedata_minus_hidden_ro" ),
      
      p( "Entries that are hidden:" ),
      
      reactableOutput( "filedata_hidden_entries_ro" ),
      
    )
    
  )
  
)
