# Tab for performing content analysis.

contentAnalysisTab <- tabPanel( "Content Analysis",
                                
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput( "CA_select_resin_si", "Select resin:", choices = NULL )
      
    ),
    
    mainPanel(
      
      plotlyOutput( "CA_PP_po" ),
      plotlyOutput( "CA_PET_po" )
      
    )
    
  )
  
)
