# Tab for PCA analysis.

PCATab <- tabPanel( "PCA",
                    
  sidebarLayout(
    
    sidebarPanel(
      
      wellPanel(
      
        checkboxGroupInput( "PCA_select_datasets_cb", "Select datasets to feed the PCA:", choiceNames = datasets, choiceValues = 1:9 ),
        
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
      
      wellPanel(
        
        plotOutput( "PCA_po", height = 800 ),
        
        br(),
        
        p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
        
        fluidRow( column( 12, tableOutput( "PCA_variation_to" ), align = "center" ) ),
        
        br(),
        
        p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
        
        fluidRow(
          
          column( 2 ),
          
          column( 4, p( "PC 1" ), tableOutput( "PCA_coefficients_1_to" ), align = "center" ),
        
          column( 4, p( "PC 2" ), tableOutput( "PCA_coefficients_2_to" ), align = "center" ),
          
          column( 2 )
          
        )
        
      ),
      
      pickerInput( "PCA_individual_experiments_pi", "Select experiments to show the individual PCAs of", choices = c(), multiple = TRUE, width = "100%", options = pickerOptions( actionsBox = TRUE ) ),
      
      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '1' ) == true",
                        
        wellPanel(
          
          plotOutput( "PCA_ftir_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_ftir_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_ftir_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_ftir_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '2' ) == true",

        wellPanel(
          
          plotOutput( "PCA_dsc_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_dsc_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_dsc_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_dsc_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '3' ) == true",

        wellPanel(
          
          plotOutput( "PCA_tga_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_tga_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_tga_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_tga_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '4' ) == true",

        wellPanel(
          
          plotOutput( "PCA_rheo_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_rheo_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_rheo_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_rheo_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '5' ) == true",

        wellPanel(
          
          plotOutput( "PCA_tt_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_tt_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_tt_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_tt_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '6' ) == true",

        wellPanel(
          
          plotOutput( "PCA_colour_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_colour_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_colour_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_colour_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '8' ) == true",

        wellPanel(
          
          plotOutput( "PCA_tls_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_tls_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_tls_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_tls_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      ),

      conditionalPanel( condition = "input.PCA_individual_experiments_pi.includes( '9' ) == true",

        wellPanel(
          
          plotOutput( "PCA_escr_po", height = 800 ),
          
          br(),
          
          p( "Percentage Variation Explained by each Principal Component (PC)", style = "text-align: center" ),
          
          fluidRow( column( 12, tableOutput( "PCA_escr_variation_to" ), align = "center" ) ),
          
          br(),
          
          p( "Coefficients of features for the PCs (in order of coefficient magnitude)", style = "text-align: center" ),
          
          fluidRow(
            
            column( 2 ),
            
            column( 4, p( "PC 1" ), tableOutput( "PCA_escr_coefficients_1_to" ), align = "center" ),
            
            column( 4, p( "PC 2" ), tableOutput( "PCA_escr_coefficients_2_to" ), align = "center" ),
            
            column( 2 )
            
          )
          
        )

      )
      
    )
    
  )
  
)