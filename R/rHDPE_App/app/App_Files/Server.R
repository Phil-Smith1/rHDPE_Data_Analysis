#===============
# The main object in this file is server, which is then passed to the shinyApp() function in app.R.

#===============
# Server

server <- function( input, output, session ) {

  #===============
  # Using thematic package.

  thematic::thematic_shiny()

  #===============
  # Setting theme for reactables.

  options( reactable.theme = reactableTheme( color = "hsl( 233, 9%, 87% )", backgroundColor = "rgb( 44, 45, 53 )", borderColor = "hsl( 233, 9%, 22% )", stripedColor = "hsl( 233, 12%, 22% )",
  highlightColor = "hsl( 233, 12%, 24% )", inputStyle = list( backgroundColor = "hsl( 233, 9%, 25% )" ), selectStyle = list( backgroundColor = "hsl( 233, 9%, 25% )" ),
  pageButtonHoverStyle = list( backgroundColor = "hsl( 233, 9%, 25% )" ), pageButtonActiveStyle = list( backgroundColor = "hsl( 233, 9%, 28% )" ),
  style = list( "input[type='checkbox']" = list( display = "flex" ), "input[type='checkbox']:checked::after" = list( content = "'✓'", position = "relative",
  color = "white", width = "13px", height = "13px", backgroundColor = bs_primary, borderRadius = "1px", fontSize = "12px", textAlign = "center", lineHeight = "15px" ) ),
  rowSelectedStyle = list( backgroundColor = secondary_colour, "&:hover, &:focus" = list( backgroundColor = secondary_colour_light ) ) ) )

  #===============
  # Login server code.

  if (include_login) {

    credentials <- loginServer( id = "login", data = user_base, user_col = user, pwd_col = password, sodium_hashed = TRUE, log_out = reactive( logout_init() ) )

    logout_init <- logoutServer( id = "logout", active = reactive( credentials()$user_auth ) )

  }

  #===============
  # App launch process server code.

  source( here::here( "App_Files/Server/App_Launch_Process.R" ), local = TRUE )

  #===============
  # Update resin data and dependencies server code.

  source( here::here( "App_Files/Server/Resin_Data.R" ), local = TRUE )
  
  #===============
  # Initiate data reading server code.
  
  source( here::here( "App_Files/Server/Initiate_Data_Reading.R" ), local = TRUE )
  
  #===============
  # Home tab server code.
  
  source( here::here( "App_Files/Server/Home.R" ), local = TRUE )
  
  #===============
  # PP% tab server code.
  
  source( here::here( "App_Files/Server/PP_Prediction.R" ), local = TRUE )
  
  #===============
  # ESCR prediction server code.
  
  source( here::here( "App_Files/Server/ESCR_Prediction.R" ), local = TRUE )

  #===============
  # PCA tab server code.

  source( here::here( "App_Files/Server/PCA.R" ), local = TRUE )

  #===============
  # Content analysis tab server code.

  source( here::here( "App_Files/Server/Content_Analysis.R" ), local = TRUE )

  #===============
  # Feature correlation tab server code.

  source( here::here( "App_Files/Server/Feature_Correlations.R" ), local = TRUE )

  #===============
  # ESCR risk assessment server code.

  source( here::here( "App_Files/Server/ESCR_Risk_Assessment.R" ), local = TRUE )

  #===============
  # Visualisation tab server code.

  # FTIR Visualisation.

  source( here::here( "App_Files/Server/FTIR_Visualisation.R" ), local = TRUE )

  # DSC Visualisation.

  source( here::here( "App_Files/Server/DSC_Visualisation.R" ), local = TRUE )

  # TGA Visualisation.

  source( here::here( "App_Files/Server/TGA_Visualisation.R" ), local = TRUE )

  # Rheology Visualisation.

  source( here::here( "App_Files/Server/Rheology_Visualisation.R" ), local = TRUE )

  # Colour Visualisation.

  source( here::here( "App_Files/Server/Colour_Visualisation.R" ), local = TRUE )

  # TT Visualisation.

  source( here::here( "App_Files/Server/TT_Visualisation.R" ), local = TRUE )

  # SHM Visualisation.

  source( here::here( "App_Files/Server/SHM_Visualisation.R" ), local = TRUE )

  # TLS Visualisation.

  source( here::here( "App_Files/Server/TLS_Visualisation.R" ), local = TRUE )

  # ESCR Visualisation.

  source( here::here( "App_Files/Server/ESCR_Visualisation.R" ), local = TRUE )

  # GCMS Visualisation.

  source( here::here( "App_Files/Server/GCMS_Visualisation.R" ), local = TRUE )

  #===============
  # Resin metadata tab server code.

  source( here::here( "App_Files/Server/Resin_Metadata.R" ), local = TRUE )
  
  #===============
  # File data tab server code.
  
  source( here::here( "App_Files/Server/File_Data.R" ), local = TRUE )

  #===============
  # Upload tab server code.

  source( here::here( "App_Files/Server/Upload.R" ), local = TRUE )
  
  #===============
  # Save tab server code.
  
  source( here::here( "App_Files/Server/Save.R" ), local = TRUE )

  #===============
  # Settings tab server code.

  source( here::here( "App_Files/Server/Settings.R" ), local = TRUE )

  #===============
  # DataLab tab server code.
  
  if (app_user == "shiny") { token <- "" # Set token to empty string when deployed on shinyapps.
  } else if (app_user != "shiny") source( here::here( "DataLab_Files/DataLab_Server.R" ), local = TRUE )

  #===============
  # Dev tab server code.

  source( here::here( "App_Files/Server/Dev.R" ), local = TRUE )

  session$onSessionEnded( function() {

    stopApp()

  } )
  
}