# Tab for displaying the ESCR risk assessment.

ESCRRiskAssessmentTab <- tabPanel( "ESCR Risk Assessment",
                    
  sidebarLayout(
    
    sidebarPanel(
     
      selectInput( "ESCRRA_select_resin_si", "Select resin:", choices = NULL )
     
    ),
    
    mainPanel(
      
      fluidRow(
        
        column( 6, plotlyOutput( "ESCRRA_PP_po" ) ),
        column( 6, uiOutput( "ESCRRA_PP_ui" ) )
        
      ),
      
      fluidRow(
        
        column( 6, plotlyOutput( "ESCRRA_MW_po" ) ),
        column( 6, uiOutput( "ESCRRA_MW_ui" ) )
        
      ),
      
      fluidRow(
        
        column( 6, plotlyOutput( "ESCRRA_SHM_po" ) ),
        column( 6, uiOutput( "ESCRRA_SHM_ui" ) )
        
      )
    
    )
    
  )
  
)