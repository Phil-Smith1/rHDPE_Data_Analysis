#===============
# The main object in this file is ui, which is then passed to the shinyApp() function in app.R.
# However, we also use this file to attach packages and source all required additional code.

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
library( openxlsx )
library( reactable.extras )

plan( multisession ) # Related to promises/future functionality.

#===============
# Sources

source( here::here( "App_Files/UserParameters.R" ) ) # File that sets certain parameters depending on the platform the app is running on.
source( here::here( "App_Files/GlobalVariables.R" ) ) # File containing global variables for the app.
source( here::here( "App_Files/ShinyAuthrUsers.R" ) ) # File containing the database for logins.
source( here::here( "App_Files/Utilities.R" ) ) # File containing utility functions.
source( here::here( "App_Files/PythonInstall.R" ) ) # Sets up/installs Python on the platform.
source( here::here( "App_Files/ImportAndInitialise_rHDPE_Data_Analysis_Package.R" ) ) # Imports modules from the rHDPE_Data_Analysis package and initialises parameters.
source( here::here( "App_Files/JS.R" ) ) # File containing JS code and CSS styles.

#===============
# Sources for UI Tabs.

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
  
  reactable.extras::reactable_extras_dependency(),
  
  #===============
  # JS code and CSS styles.
  
  tags$head( tags$style( HTML( CSS_for_read_more ) ) ), # CSS code for 'read more' buttons.
  tags$style( HTML( CSS_for_download_btn ) ), # CSS code for download buttons.
  tags$script( HTML( JS_for_read_more ) ), # JS code that enables 'read more' buttons to work.
  tags$script( HTML( JS_for_session_initialisation ) ), # JS code that sets an input value to say when the session is initialised.
  
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