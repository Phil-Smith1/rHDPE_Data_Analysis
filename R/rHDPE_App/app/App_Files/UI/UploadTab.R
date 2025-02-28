# Tab for uploading data.

uploadTab <- tabPanel( "Upload",
                    
  fluidPage(
    
    wellPanel(
      
      textOutput( "upload_experiment_to" ),
      
      textOutput( "upload_select_files_to" ),
      
      br(),
      
      actionButton( "upload_select_files_ab", "Change Files to Upload" ),
      
      actionButton( "upload_change_metadata_ab", "Change Metadata of Files to Upload" ),
      
      br(),
      
      p( "The files to be uploaded are:" ),
      
      tableOutput( "upload_info_to" )
      
    ),
    
    br(),
    
    wellPanel( fluidRow( column( 12, input_task_button( "upload_itb", "Upload Files", label_busy = "Uploading..." ), align = "center" ) ) )
    
    # wellPanel( fluidRow( column( 12, bsButton( "upload_ab", "Upload Files" ), align = "center" ) ) )
    
  )
  
)