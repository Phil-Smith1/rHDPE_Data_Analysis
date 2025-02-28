#===============
# Libraries

library( shiny )
library( ggplot2 )
library( ggnewscale )
library( reticulate )
library( shinyauthr )
library( tidyverse )
library( plotly )
library( thematic )
library( waiter )
library( readxl )
library( magrittr )
library( shinyfilter )
library( reactable )
library( scroller )
library( shinyWidgets )
library( reshape2 )
library( ggrepel )
library( shinyvalidate )
library( shinyToastify )
library( writexl )
library( shinyjs )
library( shinyBS )
library( bslib )
library( cowplot )
library( httr )
# library( jsonlite ) Package is loaded but not attached as an unhelpful conflict was present.
library( promises )
library( future )
library( parallel )

plan( multisession ) # Related to promises/future functionality.

#===============
# Sources

source( here::here( "App_Files/WorkQueue.R" ) )

source( here::here( "App_Files/CustomWorkQueue.R" ) )

source( here::here( "App_Files/UserParameters.R" ) )

if (app_user != "shiny") { # Load DataLab libraries and functions, but not if on shinyapps as some packages are stored only locally on DataLab.
  
  source( here::here( "DataLab_Files/DataLab.R" ) )
  
}

source( here::here( "rHDPE_R_Functions.R" ) )

source( here::here( "App_Files/Utilities.R" ) )

source( here::here( "App_Files/GlobalVariables.R" ) )

source( here::here( "App_Files/ShinyAuthrUsers.R" ) )

source( here::here( "App_Files/PythonInstall.R" ) )

source( here::here( "App_Files/PackageImportsAndParameterSetting.R" ) )

source( here::here( "App_Files/UI/HomeTab.R" ) )

source( here::here( "App_Files/UI/PPPredictionTab.R" ) )

source( here::here( "App_Files/UI/ESCRPredictionTab.R" ) )

source( here::here( "App_Files/UI/PCATab.R" ) )

source( here::here( "App_Files/UI/ContentAnalysisTab.R" ) )

source( here::here( "App_Files/UI/FeatureCorrelationsTab.R" ) )

source( here::here( "App_Files/UI/ESCRRiskAssessmentTab.R" ) )

source( here::here( "App_Files/UI/VisualisationTab.R" ) )

source( here::here( "App_Files/UI/ResinMetadataTab.R" ) )

source( here::here( "App_Files/UI/FileDataTab.R" ) )

source( here::here( "App_Files/UI/UploadTab.R" ) )

source( here::here( "App_Files/UI/SaveTab.R" ) )

source( here::here( "App_Files/UI/SettingsTab.R" ) )

source( here::here( "App_Files/UI/DataLabTab.R" ) )

source( here::here( "App_Files/UI/DevTab.R" ) )

#===============
# UI

ui <- fluidPage(
  
  #===============
  # JS code that sets an input value to say when the session is initialised.
  
  tags$script(
    
    HTML( "$( document ).on( 'shiny:sessioninitialized', function( event ) {
    
       Shiny.setInputValue( 'js_initialised', true );
       
    });" )
  
  ),
  
  #===============
  # Shinyjs for JavaScript operations.
  
  useShinyjs(),
  
  #===============
  # ShinyToastify for user feedback.
  
  useShinyToastify(),
  
  #===============
  # Scroller for scrolling automatically to outputs.
  
  scroller::use_scroller( animationLength = 100 ),
  
  #===============
  # Waiter for spinners for user feedback.
  
  waiter::autoWaiter( html = spin_pixel(), color = transparent( 0.05 ) ),
  waiterPreloader( html = spin_pixel() ),
  
  #===============
  # Sets the theme for the app.
  
  theme = app_theme,
  
  #===============

  titlePanel( "Welcome to the PCR Predictor Tool" ),
  
  if (include_login) {
    
    div( class = "float-right", shinyauthr::logoutUI( id = "logout" ) )
    
    shinyauthr::loginUI( id = "login" )
    
  },
  
  div( id = "tabsetPanel",

    tabsetPanel( id = "tabs_tp",
                 
      #===============
      # Tab for Home.
       
      homeTab,
      
      #===============
      # Tab for performing PP content predictions.
      
      PPPredictionTab,
      
      #===============
      # Tab for displaying the ESCR prediction.
      
      ESCRPredictionTab,
      
      #===============
      # Tab for performing PCA.
      
      PCATab,
      
      #===============
      # Tab for performing content analysis.
      
      contentAnalysisTab,
      
      #===============
      # Tab for displaying pairwise feature correlations.
      
      featureCorrelationsTab,
      
      #===============
      # Tab for displaying the ESCR risk assessment.
      
      ESCRRiskAssessmentTab,
      
      #===============
      # Tab for data visualisation.
      
      visualisationTab,
      
      #===============
      # Tab displaying the resin metadata.
      
      resinMetadataTab,
      
      #===============
      # Tab displaying the file data.
      
      fileDataTab,
      
      #===============
      # Tab for uploading data.
      
      uploadTab,
      
      #===============
      # Tab for saving data.
      
      saveTab,
      
      #===============
      # Tab for settings.
      
      settingsTab,
      
      #===============
      # Tab for uploading and reading from DataLab.
      
      datalabTab,
      
      #===============
      # Tab for assisting with development.
      
      devTab
      
    )
  
  )
  
)