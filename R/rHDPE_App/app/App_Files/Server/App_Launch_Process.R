#===============
# Server code for process app goes through when launched.

#===============
# Code

prelaunch <- reactiveVal() # Simply a reactive value that triggers events just by being initialised.
list_of_repoids <- reactiveVal() # Stores the list of repository IDs of files on DataLab.

# Code for reading the file containing the list of repository IDs, and using it to import the latest list of repository IDs from DataLab.
# In this observeEvent, the code is run before the app has finished being initialised.

observeEvent( prelaunch, {
  
  if (app_user == "docker") {
    
    list_of_repoids( suppressMessages( read_csv( "List_of_RepoIDs.csv", na = character() ) ) )
    
    if (token != "") {
      
      read_file_from_datalab( client, env, token, list_of_repoids(), "Repos", "csv" )
      
      list_of_repoids( suppressMessages( read_csv( "List_of_RepoIDs.csv", na = character() ) ) )
      
    }
    
  }
  
}, ignoreNULL = FALSE )

# Reactive value app_initialised waits for js_initialised to be set to true (and the user to login if applicable), then is itself set to TRUE.

app_initialised <- reactiveVal()

if (include_login) {
  
  observe({
    
    req( input$js_initialised & credentials()$user_auth )
    
    app_initialised( TRUE )
    
  })
  
} else {
  
  observeEvent( input$js_initialised, app_initialised( TRUE ) )
  
}

# Once app initialised, option to do further things before setting reactive value signin_complete to TRUE.

signin_complete <- reactiveVal( FALSE )

observeEvent( app_initialised(), {
  
  signin_complete( TRUE )
  
})

# Reactive value signin_complete is set to true once all initialisation and login have been completed.

# The app appears once signin_complete is set to TRUE.

observe( shinyjs::toggle( id = "tabsetPanel", condition = signin_complete() ) )

# Once sign-in is complete, download data in the background. These reactive values contain the data, and whether the data has been downloaded and read.

initial_files <- reactiveValues( download_data = FALSE, save = FALSE )
ftir_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
dsc_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
tga_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
rheo_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
colour_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
tt_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
shm_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
tls_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
escr_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
gcms_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
global_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )
raw_data <- reactiveValues( download_data = FALSE, read_data = FALSE, compute_features = TRUE, save = FALSE )

download_progress <- NULL

if (app_user != "shiny") {
  
  observeEvent( signin_complete(), {
    
    if (app_user == "philsmith") {
      
      initial_files$download_data <- TRUE
      ftir_data$download_data <- TRUE
      dsc_data$download_data <- TRUE
      tga_data$download_data <- TRUE
      rheo_data$download_data <- TRUE
      colour_data$download_data <- TRUE
      tt_data$download_data <- TRUE
      shm_data$download_data <- TRUE
      escr_data$download_data <- TRUE
      tls_data$download_data <- TRUE
      gcms_data$download_data <- TRUE
      global_data$download_data <- TRUE
      raw_data$download_data <- TRUE
      
    } else if (app_user == "docker") {
      
      download_progress <<- shiny::Progress$new()
      download_progress$set( message = "Downloading Files", value = 0 )
      
      read_initial_files_datalab_et$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_ftir$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_dsc$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_tga$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_rheo$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_colour$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_tt$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_shm$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_tls$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_escr$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_gcms$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_global$invoke( client, env, token, list_of_repoids() )
      read_file_from_datalab_et_raw_data$invoke( client, env, token, list_of_repoids() )
      
    }
    
  }, ignoreInit = TRUE )
  
} else {
  
  if (nbrOfWorkers() == 1) {
    
    observeEvent( signin_complete(), {
      
      download_progress <<- shiny::Progress$new()
      download_progress$set( message = "Downloading Files", value = 0 )
      
    }, ignoreInit = TRUE )
    
    control_download_on_shinyapps <- reactiveVal( 0 )
    
    observe({
      
      req( signin_complete() )
      
      if (isolate( control_download_on_shinyapps() ) == 0) { read_initial_files_gd_et$invoke( directory ); control_download_on_shinyapps( 1 ) }
      if (initial_files$download_data && isolate( control_download_on_shinyapps() ) == 1) { read_zip_from_gd_et_ftir$invoke( directory ); control_download_on_shinyapps( 2 ) }
      if (ftir_data$download_data && isolate( control_download_on_shinyapps() ) == 2) { read_zip_from_gd_et_dsc$invoke( directory ); control_download_on_shinyapps( 3 ) }
      if (dsc_data$download_data && isolate( control_download_on_shinyapps() ) == 3) { read_zip_from_gd_et_tga$invoke( directory ); control_download_on_shinyapps( 4 ) }
      if (tga_data$download_data && isolate( control_download_on_shinyapps() ) == 4) { read_zip_from_gd_et_rheo$invoke( directory ); control_download_on_shinyapps( 5 ) }
      if (rheo_data$download_data && isolate( control_download_on_shinyapps() ) == 5) { read_zip_from_gd_et_colour$invoke( directory ); control_download_on_shinyapps( 6 ) }
      if (colour_data$download_data && isolate( control_download_on_shinyapps() ) == 6) { read_zip_from_gd_et_tt$invoke( directory ); control_download_on_shinyapps( 7 ) }
      if (tt_data$download_data && isolate( control_download_on_shinyapps() ) == 7) { read_zip_from_gd_et_shm$invoke( directory ); control_download_on_shinyapps( 8 ) }
      if (shm_data$download_data && isolate( control_download_on_shinyapps() ) == 8) { read_zip_from_gd_et_tls$invoke( directory ); control_download_on_shinyapps( 9 ) }
      if (tls_data$download_data && isolate( control_download_on_shinyapps() ) == 9) { read_zip_from_gd_et_escr$invoke( directory ); control_download_on_shinyapps( 10 ) }
      if (escr_data$download_data && isolate( control_download_on_shinyapps() ) == 10) { read_zip_from_gd_et_gcms$invoke( directory ); control_download_on_shinyapps( 11 ) }
      if (gcms_data$download_data && isolate( control_download_on_shinyapps() ) == 11) { read_zip_from_gd_et_global$invoke( directory ); control_download_on_shinyapps( 12 ) }
      if (global_data$download_data && isolate( control_download_on_shinyapps() ) == 12) { read_zip_from_gd_et_raw_data$invoke( directory ); control_download_on_shinyapps( 13 ) }
      
    })
    
  } else {
    
    observeEvent( signin_complete(), {
        
      download_progress <<- shiny::Progress$new()
      download_progress$set( message = "Downloading Files", value = 0 )
      
      read_initial_files_gd_et$invoke( directory )
      read_zip_from_gd_et_ftir$invoke( directory )
      read_zip_from_gd_et_dsc$invoke( directory )
      read_zip_from_gd_et_tga$invoke( directory )
      read_zip_from_gd_et_rheo$invoke( directory )
      read_zip_from_gd_et_colour$invoke( directory )
      read_zip_from_gd_et_tt$invoke( directory )
      read_zip_from_gd_et_shm$invoke( directory )
      read_zip_from_gd_et_tls$invoke( directory )
      read_zip_from_gd_et_escr$invoke( directory )
      read_zip_from_gd_et_gcms$invoke( directory )
      read_zip_from_gd_et_global$invoke( directory )
      read_zip_from_gd_et_raw_data$invoke( directory )
      
    }, ignoreInit = TRUE )
    
  }
  
}

# Read dataset versions once initial files have been read.

dataset_versions_r <- reactiveVal()

if (app_user == "shiny") {
  
  observe({
    
    if (read_initial_files_gd_et$result()) {
      
      dataset_versions_r( data.frame( read_excel( paste0( directory, "Dataset_Versions.xlsx" ), .name_repair = "unique_quiet" ) ) %>% replace( is.na(.), "" ) )
      
    }
    
  })
  
} else if (app_user == "docker") {
  
  observe({
    
    if (read_initial_files_datalab_et$result()) {
      
      dataset_versions_r( data.frame( read_excel( paste0( directory, "Dataset_Versions.xlsx" ), .name_repair = "unique_quiet" ) ) %>% replace( is.na(.), "" ) )
      
    }
    
  })
  
} else {
  
  dataset_versions_r( data.frame( read_excel( paste0( directory, "Dataset_Versions.xlsx" ), .name_repair = "unique_quiet" ) ) %>% replace( is.na(.), "" ) )
  
}

# Track when data is downloaded, updating the progress bar and the reactive values as each dataset is downloaded.

observe({
  
  if (app_user == "shiny") {
    
    try( initial_files$download_data <- read_initial_files_gd_et$result(), silent = TRUE )
    try( ftir_data$download_data <- read_zip_from_gd_et_ftir$result(), silent = TRUE )
    try( dsc_data$download_data <- read_zip_from_gd_et_dsc$result(), silent = TRUE )
    try( tga_data$download_data <- read_zip_from_gd_et_tga$result(), silent = TRUE )
    try( rheo_data$download_data <- read_zip_from_gd_et_rheo$result(), silent = TRUE )
    try( colour_data$download_data <- read_zip_from_gd_et_colour$result(), silent = TRUE )
    try( tt_data$download_data <- read_zip_from_gd_et_tt$result(), silent = TRUE )
    try( tls_data$download_data <- read_zip_from_gd_et_tls$result(), silent = TRUE )
    try( shm_data$download_data <- read_zip_from_gd_et_shm$result(), silent = TRUE )
    try( escr_data$download_data <- read_zip_from_gd_et_escr$result(), silent = TRUE )
    try( gcms_data$download_data <- read_zip_from_gd_et_gcms$result(), silent = TRUE )
    try( global_data$download_data <- read_zip_from_gd_et_global$result(), silent = TRUE )
    try( raw_data$download_data <- read_zip_from_gd_et_raw_data$result(), silent = TRUE )
    
    counter <- 0
    
    try( if (read_initial_files_gd_et$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_ftir$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_dsc$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_tga$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_rheo$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_colour$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_tt$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_shm$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_tls$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_escr$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_gcms$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_global$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_zip_from_gd_et_raw_data$result()) counter <- counter + 1, silent = TRUE )
    
    if (counter > 0) download_progress$set( value = counter / 13 )
    
    if (counter == 13) download_progress$close()
    
  } else if (app_user == "docker") {
    
    try( initial_files$download_data <- read_initial_files_datalab_et$result(), silent = TRUE )
    try( ftir_data$download_data <- read_file_from_datalab_et_ftir$result(), silent = TRUE )
    try( dsc_data$download_data <- read_file_from_datalab_et_dsc$result(), silent = TRUE )
    try( tga_data$download_data <- read_file_from_datalab_et_tga$result(), silent = TRUE )
    try( rheo_data$download_data <- read_file_from_datalab_et_rheo$result(), silent = TRUE )
    try( colour_data$download_data <- read_file_from_datalab_et_colour$result(), silent = TRUE )
    try( tt_data$download_data <- read_file_from_datalab_et_tt$result(), silent = TRUE )
    try( shm_data$download_data <- read_file_from_datalab_et_shm$result(), silent = TRUE )
    try( tls_data$download_data <- read_file_from_datalab_et_tls$result(), silent = TRUE )
    try( escr_data$download_data <- read_file_from_datalab_et_escr$result(), silent = TRUE )
    try( gcms_data$download_data <- read_file_from_datalab_et_gcms$result(), silent = TRUE )
    try( global_data$download_data <- read_file_from_datalab_et_global$result(), silent = TRUE )
    try( raw_data$download_data <- read_file_from_datalab_et_raw_data$result(), silent = TRUE )
    
    counter <- 0
    
    try( if (read_initial_files_datalab_et$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_ftir$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_dsc$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_tga$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_rheo$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_colour$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_tt$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_shm$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_tls$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_escr$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_gcms$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_global$result()) counter <- counter + 1, silent = TRUE )
    try( if (read_file_from_datalab_et_raw_data$result()) counter <- counter + 1, silent = TRUE )
    
    if (counter > 0) download_progress$set( value = counter / 13 )
    
    if (counter == 13) download_progress$close()
    
  }
  
}, priority = 1 )