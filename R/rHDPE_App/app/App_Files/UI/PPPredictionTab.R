# Tab for performing PP content predictions.

PPPredictionTab <- tabPanel( "PP% Prediction (FTIR)",
          
  sidebarLayout(
    
    sidebarPanel(
     
     selectInput( "PP_select_resin_si", "Select resin:", choices = NULL )
     
    ),
    
    mainPanel(
     
      plotlyOutput( "PP_percentage_po" ),
      plotOutput( "PP_by_specimens_po" ),
      plotOutput( "PP_by_wavenumber_po" ),
      plotOutput( "PP_boxplot_po" ),
      
      fluidRow( 
        
        column( 12, align = "center", h3( "Summary Statistics of Predictions" ) ),
        column( 12, align = "center", tableOutput( "PP_summary_to" ) )
        
      ),
    
      plotOutput( "PP_heatmap_po" )
    
    )
    
  )
  
)
