# Tab for displaying the ESCR prediction.

ESCRPredictionTab <- tabPanel( "ESCR Prediction",
                    
  sidebarLayout(
    
    sidebarPanel(
     
     radioButtons( "ESCRP_select_model_rb", "Select model:", choices = c( "General", "DSC" ) )
     
    ),
    
    mainPanel(
      
      wellPanel(
        
        selectInput( "ESCRP_select_resin_si", "Select resin:", choices = NULL, width = "100%" )
        
      ),
      
      br(),
      
      fluidRow(
        
        p( "By 'ESCR', we mean the time taken for 50% of the bottles to fail during an ESCR test.", style = paste0( "text-align: center; color: ", text_colour ) )
        
      ),
      
      fluidRow(
        
        # column( 4, plotlyOutput( "ESCRP_SHM_po" ) ),
        
        # column( 4, p( "Based on the SHM, the predicted ESCR is:", style = paste0( "font-size: 30pt; text-align: center; color: ", text_colour ) ) ),
        
        column( 8, offset = 2, plotlyOutput( "ESCRP_ESCR_po" ) )
        
      ),
      
      br(),
      
      fluidRow(
        
        p( "To make this prediction of the ESCR, we first predict the strain hardening modulus (known to correlate with ESCR as both ESCR and SHM depend on the number of tie molecules), and use this value to predict the ESCR. To go from SHM to ESCR, we use the line of best fit seen in the plot below:", style = paste0( "text-align: center; color: ", text_colour ) )
        
      ),
      
      plotOutput( "ESCRP_po", height = 800 ),
      
      br(),
      
      fluidRow(
        
        p( "To predict the SHM, we perform linear regression on all applicable triplets of features, and select the triplet that gives the best model. The triplet of features, and the corresponding plot of predicted SHM vs actual SHM, can be seen below:", style = paste0( "text-align: center; color: ", text_colour ) )
        
      ),
      
      plotOutput( "ESCRP_shm_prediction_po", height = 800 )
    
    )
    
  )
  
)