# Tab for saving data.

saveTab <- tabPanel( "Save",
                    
  fluidPage(
    
    br(),
    
    p( "A 'quick save' saves only the data that has changed in this session." ),
    
    wellPanel( fluidRow( column( 12, input_task_button( "save_quick_itb", "Quick Save", label_busy = "Saving...", auto_reset = FALSE ), align = "center" ) ) ),
    
    br(),
    
    p( "A 'full save' saves all data, even if it has not changed in this session." ),
    
    wellPanel( fluidRow( column( 12, input_task_button( "save_full_itb", "Full Save", label_busy = "Saving...", auto_reset = FALSE ), align = "center" ) ) )
    
  )
  
)