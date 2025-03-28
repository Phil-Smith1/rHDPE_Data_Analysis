# Tab for performing PP content predictions.

PPPredictionTab <- tabPanel( "PP% Prediction (FTIR)",
                             
  tabsetPanel(
    
    tabPanel( "Single resin",
              
      sidebarLayout(
    
        sidebarPanel(
         
         selectInput( "PP_select_resin_si", "Select resin:", choices = NULL )
         
        ),
        
        mainPanel(
         
          plotlyOutput( "PP_percentage_po" ),
          
          p( "The above value is calculated from 6n predictions, where n is the number of repeats (specimens) of the FTIR experiment. The distribution of these 6n predictions is summarised in the boxplot below.", style = "color: white" ),
          
          fluidRow( column( 12, align = "center", tableOutput( "PP_summary_to" ) ) ),
          
          plotOutput( "PP_boxplot_po" ),
          
          br(),
          
          p( "The predictions for each individual repeat (specimen) of the FTIR experiment are shown in the barchart below.", style = "color: white" ),
          
          plotOutput( "PP_by_specimens_po" ),
          
          br(),
          
          p( "The prediction for each specimen is an average across 6 predictions that are made based on the peaks at 6 characteristic wavenumbers. The mean prediction over all specimens at each wavenumber is shown below.", style = "color: white" ),
          
          plotOutput( "PP_by_wavenumber_po" ),
          
          br(),
          
          p( "The 6n predictions that the model makes (at 6 wavenumbers for each of the n specimens) are shown in the heatmap below. These 6n predictions are the predictions from which the boxplot towards the top is created.", style = "color: white" ),
          
          plotOutput( "PP_heatmap_po" ),
          
          br(),
          
          p( "How do we go from these 6n predictions to the final value?", style = "color: white" ),
          p( "Taking the 6 predictions made for each specimen, we discard the highest and lowest prediction (in an attempt to remove anomalies), and then take the mean of the remaining four predictions. This gives us a prediction for each of the n specimens.", style = "color: white" ),
          p( "Taking the n predictions (one for each specimen), we again discard the highest and lowest prediction (in an attempt to remove anomalies), and then take the mean of the remaining n - 2 predictions to get our final value. If there are 5 of less specimens, we do not discard the highest and lowest values.", style = "color: white" ),
        
        )
        
      )
              
    ),
    
    tabPanel( "Compare multiple resins",
    
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
          
            reactableOutput( "PP_table_ro" ),
            
            actionButton( "PP_compare_ab", "Compare", width = "100%" )
            
          ),
          
          wellPanel(
            
            downloadButton( "PP_export_db", "Export Data", class = "download" )
            
          ),
          
        ),
        
        mainPanel(
          
          plotlyOutput( "PP_compare_po" )
          
        )
        
      )
              
    )
    
  )
  
)
