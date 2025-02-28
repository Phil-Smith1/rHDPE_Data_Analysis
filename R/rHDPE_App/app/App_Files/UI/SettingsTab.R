# Tab for settings.

settingsTab <- tabPanel( "Settings",
                    
  fluidPage(
    
    selectInput( "settings_dataset_version_si", "Select the version of the dataset to use", choices = NULL ),
    
    actionButton( "settings_new_dataset_version_ab", "Create new dataset version" ),
    
    actionButton( "settings_delete_dataset_version_ab", "Delete a dataset version" )
    
  )
  
)