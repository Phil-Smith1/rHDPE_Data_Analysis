# Tab for DataLab.

datalabTab <- tabPanel( "DataLab",
                        
  tabsetPanel( id = "datalab_tp",
               
    tabPanel( "Search DataLab",
              
      textInput( "datalab_search_ti", "Search term" ),
      
      actionButton( "datalab_search_ab", "Search DataLab" ),
      
      reactableOutput( "datalab_search_ro" ),
              
    ),
    
    tabPanel( "Update",
              
      p( "Operations on this tab update existing repositories on DataLab with the corresponding files held locally on the server." ),
              
      textInput( "datalab_label_update_ti", "Label" ),
      
      actionButton( "datalab_read_zip_ab", "Read zip file from DataLab" ),
      
      actionButton( "datalab_update_zip_ab", "Update zip file on DataLab" ),
      
      textInput( "datalab_name_update_ti", "Name" ),
      
      textInput( "datalab_description_update_ti", "Description" ),
      
      textInput( "datalab_dir_update_ti", "Dir" ),
      
      textInput( "datalab_filename_update_ti", "Filename" ),
      
      textInput( "datalab_ext_update_ti", "Ext" ),
      
      actionButton( "datalab_read_ab", "Read file from DataLab" ),
      
      actionButton( "datalab_update_ab", "Update file on DataLab" )
              
    ),
    
    tabPanel( "Upload",
              
      p( "Operations on this tab upload to new depositories on DataLab." ),
              
      textInput( "datalab_label_upload_ti", "Label" ),
      
      actionButton( "datalab_upload_zip_ab", "Upload zip file to DataLab" ),
      
      textInput( "datalab_name_upload_ti", "Name" ),
      
      textInput( "datalab_description_upload_ti", "Description" ),
       
      textInput( "datalab_dir_upload_ti", "Dir" ),
      
      textInput( "datalab_filename_upload_ti", "Filename" ),
      
      textInput( "datalab_ext_upload_ti", "Ext" ),
      
      actionButton( "datalab_upload_ab", "Upload file to DataLab" ),
      
      actionButton( "datalab_upload_ab_lor", "Upload list of resins "),
      
      actionButton( "datalab_upload_ab_dv", "Upload dataset versions ")
              
    ),
               
  )
  
)