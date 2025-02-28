# Tab for PCA analysis.

PCATab <- tabPanel( "PCA",
                    
  sidebarLayout(
    
    sidebarPanel(
      
      wellPanel(
      
        checkboxGroupInput( "PCA_select_datasets_cb", "Select datasets:", choiceNames = datasets, choiceValues = 1:9 ),
        
      ),
      
      wellPanel(
        
        p( "Select a group of resins from below to plot, or select a custom set of resins:" ),
        
        checkboxInput( "PCA_dv1_cb", "Dataset Version 1 (23 resins)" ),
        checkboxInput( "PCA_dv2_cb", "Dataset Version 2 (24 resins)" ),
        checkboxInput( "PCA_no_virgin_resins_cb", "Exclude virgin resins" ),
        checkboxInput( "PCA_no_pp_resins_cb", "Exclude resins with high PP" ),
        checkboxInput( "PCA_custom_resins_cb", "Select custom resins" ),
        conditionalPanel( condition = "input.PCA_custom_resins_cb == true", reactableOutput( "PCA_table_ro" ) ),
        
      ),
      
      actionButton( "PCA_compute_ab", "Compute PCA of selected datasets", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##PCA_po" ),
      
      wellPanel(
        
        p( "Plot customisation:" ),
        
        checkboxInput( "PCA_add_labels_cb", "Labels next to points" ),
        checkboxInput( "PCA_loading_plot_cb", "Add loading plot" )
        
      ),
      
      wellPanel(
        
        checkboxInput( "PCA_advanced_settings_cb", "Show advanced settings" ),
        
        conditionalPanel( condition = "input.PCA_advanced_settings_cb == true",
          
          lapply( 1:length( e ), function(i) {
            
            if (i == 3) {
              
              pickerInput( paste0( "PCA_", e_labels[[i]], "_features_pi" ), paste0( "Select ", e[[i]], " Features:" ), choices = get( paste0( e_labels[[i]], "_features" ) ), selected = get( paste0( e_labels[[i]], "_features" ) )[c( 1, 2, 3, 4, 5, 6, 7 )], multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) )
              
            } else {
              
              pickerInput( paste0( "PCA_", e_labels[[i]], "_features_pi" ), paste0( "Select ", e[[i]], " Features:" ), choices = get( paste0( e_labels[[i]], "_features" ) ), selected = get( paste0( e_labels[[i]], "_features" ) ), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) )
              
            }
            
          })
          
        ),
        
      ),
      
    ),
    
    mainPanel(
      
      plotOutput( "PCA_po", height = 800 ),
      plotOutput( "PCA_subplots_po", height = 800 )
      
    )
    
  )
  
)