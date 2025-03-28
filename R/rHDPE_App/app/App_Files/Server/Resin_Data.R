# Update resin data and dependencies.

resin_data_r <- reactiveVal()

ftir_resins_r <- reactiveValues()
dsc_resins_r <- reactiveValues()
tga_resins_r <- reactiveValues()
rheo_resins_r <- reactiveValues()
colour_resins_r <- reactiveValues()
tt_resins_r <- reactiveValues()
shm_resins_r <- reactiveValues()
tls_resins_r <- reactiveValues()
escr_resins_r <- reactiveValues()
gcms_resins_r <- reactiveValues()

correlation_resins_r <- reactiveValues( correlation_resins_r = data.frame() )
metadata_r <- reactiveValues()

component_analysis_resins_names <- reactiveVal()
ds_paper_1_resins_names <- reactiveVal()

observeEvent( current_dataset(), {
    
  resin_data <- read_excel( paste0( paste0( directory, "List_of_Resins", current_dataset(), ".xlsx" ) ), .name_repair = "unique_quiet" )
  
  if (0 %in% resin_data$Identifier) {
    
    resin_data <- data.frame( resin_data[-1,] %>% mutate( Identifier = as.integer( Identifier ) ), check.names = FALSE )
    
  }
  
  else {
    
    resin_data <- data.frame( resin_data %>% mutate( Identifier = as.integer( Identifier ) ), check.names = FALSE )
    
  }
  
  resin_data_r( resin_data )
  
  ftir_data$read_data <- FALSE
  dsc_data$read_data <- FALSE
  tga_data$read_data <- FALSE
  rheo_data$read_data <- FALSE
  colour_data$read_data <- FALSE
  tt_data$read_data <- FALSE
  shm_data$read_data <- FALSE
  tls_data$read_data <- FALSE
  escr_data$read_data <- FALSE
  gcms_data$read_data <- FALSE
  global_data$read_data <- FALSE
  
  ftir_data$compute_features <- TRUE
  dsc_data$compute_features <- TRUE
  tga_data$compute_features <- TRUE
  rheo_data$compute_features <- TRUE
  colour_data$compute_features <- TRUE
  tt_data$compute_features <- TRUE
  shm_data$compute_features <- TRUE
  tls_data$compute_features <- TRUE
  escr_data$compute_features <- TRUE
  gcms_data$compute_features <- TRUE
  
})

observeEvent( resin_data_r(), {
  
  ftir_resins_r[["ftir_resins_r"]] <- resin_data_r() %>% filter( FTIR == 1 ) %>% select( "Identifier", "Name", "Label" )
  dsc_resins_r[["dsc_resins_r"]] <- resin_data_r() %>% filter( DSC == 1 ) %>% select( "Identifier", "Name", "Label" )
  tga_resins_r[["tga_resins_r"]] <- resin_data_r() %>% filter( TGA == 1 ) %>% select( "Identifier", "Name", "Label" )
  rheo_resins_r[["rheo_resins_r"]] <- resin_data_r() %>% filter( Rheology == 1 ) %>% select( "Identifier", "Name", "Label" )
  colour_resins_r[["colour_resins_r"]] <- resin_data_r() %>% filter( Colour == 1 ) %>% select( "Identifier", "Name", "Label" )
  tt_resins_r[["tt_resins_r"]] <- resin_data_r() %>% filter( TT == 1 ) %>% select( "Identifier", "Name", "Label" )
  shm_resins_r[["shm_resins_r"]] <- resin_data_r() %>% filter( SHM == 1 ) %>% select( "Identifier", "Name", "Label" )
  tls_resins_r[["tls_resins_r"]] <- resin_data_r() %>% filter( TLS == 1 ) %>% select( "Identifier", "Name", "Label" )
  escr_resins_r[["escr_resins_r"]] <- resin_data_r() %>% filter( ESCR == 1 ) %>% select( "Identifier", "Name", "Label" )
  gcms_resins_r[["gcms_resins_r"]] <- resin_data_r() %>% filter( GCMS == 1 ) %>% select( "Identifier", "Name", "Label" )
  
  correlation_resins_r[["correlation_resins_r"]] <- resin_data_r() %>% select( "Identifier", "Name", "Label" )
  metadata_r[["metadata_r"]] <- resin_data_r()
  
  component_analysis_resins_names( resin_data_r() %>% filter( Identifier %in% component_analysis_resins_identifiers ) %>% pull( Name ) )
  ds_paper_1_resins_names( mapply( function( x, y ) {paste0( x, " (", y, ")" )}, resin_data_r() %>% filter( Identifier %in% ds_paper_1_resins_identifiers ) %>% pull( Name ), resin_data_r() %>% filter( Identifier %in% ds_paper_1_resins_identifiers ) %>% pull( Label ) ) )
  
  updateSelectInput( session, "PP_select_resin_si", choices = setNames( ftir_resins_r$ftir_resins_r[-which( is.na( ftir_resins_r$ftir_resins_r$Name ) ),] %>% pull( Identifier ), mapply( function( x, y ) {paste0( x, " (", y, ")" )}, ftir_resins_r$ftir_resins_r[-which( is.na( ftir_resins_r$ftir_resins_r$Name ) ),] %>% pull( Name ), ftir_resins_r$ftir_resins_r[-which( is.na( ftir_resins_r$ftir_resins_r$Name ) ),] %>% pull( Label ) ) ) )
  updateSelectInput( session, "CA_select_resin_si", choices = setNames( component_analysis_resins_identifiers, component_analysis_resins_names() ) )
  updateSelectInput( session, "ESCRRA_select_resin_si", choices = setNames( ds_paper_1_resins_identifiers, ds_paper_1_resins_names() ) )
  updateSelectInput( session, "ESCRP_select_resin_si", choices = setNames( ds_paper_1_resins_identifiers, ds_paper_1_resins_names() ) )
  
})