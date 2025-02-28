# Tab for assisting with development.

devTab <- tabPanel( "Dev",
                    
  selectInput( "dev_dataset_version_to_read_si", "Select the dataset version to read data from", choices = NULL ),
  
  selectInput( "dev_dataset_version_to_write_si", "Select the dataset version to write data to", choices = NULL ),
                    
  selectInput( "dev_generate_data_si", "Select dataset to regenerate data", choices = output_directories ),
  
  actionButton( "dev_generate_data_ab", "Regenerate Data" ),
  
  br(),
  br(),
                    
  textInput( "dev_ti", "" ),
                    
  actionButton( "dev_ab", "Action Button" ),
  
  actionButton( "dev_ab2", "Action Button 2" ),
  
  actionButton( "dev_ab3", "Action Button 3" ),
  
  actionButton( "dev_ab4", "Test" ),
  
  input_task_button( "dev_itb", "Input Task Button", auto_reset = FALSE ),
                    
  verbatimTextOutput( "dev_print_to" )
  
)