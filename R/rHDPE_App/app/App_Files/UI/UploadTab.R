# Tab for uploading data.

uploadTab <- tabPanel( "Upload",
                    
  fluidPage(
    
    sidebarLayout(
      
      sidebarPanel(
        
        wellPanel( actionButton( "upload_select_files_ab", "Select Files to Upload", width = "100%" ) ),
        
        wellPanel( actionButton( "upload_change_metadata_ab", "Edit Metadata of Files to Upload", width = "100%" ) ),
        
        wellPanel( fluidRow( column( 12, input_task_button( "upload_itb", "Upload Files", label_busy = "Uploading..." ), align = "center" ) ) )
        
      ),
      
      mainPanel(
        
        wellPanel(
          
          textOutput( "upload_experiment_to" ),
          
          br(),
          
          p( "The files to be uploaded are:" ),
          
          tableOutput( "upload_info_to" )
          
        ),
        
      )
      
    )
    
    # wellPanel( fluidRow( column( 12, bsButton( "upload_ab", "Upload Files" ), align = "center" ) ) )
    
  )
  
)