# Tab for data visualisation.

visualisationTab <- tabPanel( "Data Visualisation",
  
  tabsetPanel( id = "visualisation_tp",
    
    tabPanel( "FTIR",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "ftir_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "ftir_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "ftir_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "ftir_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel(

            checkboxGroupInput( "ftir_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.ftir_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "ftir_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )

          ),
          
          wellPanel( sliderTextInput( "ftir_wavenumbers_sli", "Wavenumbers", choices = seq( from = 4000, to = 600, by = -1 ), selected = c( 4000, 600 ), grid = TRUE ) ),
          
          actionButton( "ftir_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##ftir_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "ftir_table_ro" ),
          plotOutput( "ftir_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "DSC",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "dsc_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "dsc_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "dsc_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "dsc_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel(
            
            checkboxGroupInput( "dsc_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.dsc_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "dsc_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )
            
          ),
          
          wellPanel(
            
            checkboxGroupInput( "dsc_melt_cryst_cb", "Do you want to plot the melt curve or crystallisation curve (or both)?", choices = c( "Melt", "Cryst" ) ),
            sliderInput( "dsc_temp_sli", label = "Temperature range", value = c( 50, 210 ), min = 50, max = 210 ),
            
          ),
          
          actionButton( "dsc_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##dsc_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "dsc_table_ro" ),
          plotOutput( "dsc_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "TGA",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "tga_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "tga_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "tga_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "tga_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel(
            
            checkboxGroupInput( "tga_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.tga_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "tga_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )
            
          ),
          
          wellPanel( sliderInput( "tga_temp_sli", label = "Temperature", value = c( 50, 600 ), min = 50, max = 600 ) ),
          
          actionButton( "tga_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##tga_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "tga_table_ro" ),
          plotOutput( "tga_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "Rheology",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "rheo_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "rheo_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "rheo_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "rheo_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel(
            
            checkboxGroupInput( "rheo_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.rheo_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "rheo_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )
            
          ),
          
          wellPanel(
            
            selectInput( "rheo_plot_type_si", "Select the type of plot:", choices = c( "Complex viscosity vs Angular frequency", "Phase angle vs Complex viscosity", "Van Gurp-Palmen" ) ),
            conditionalPanel( condition = "input.rheo_plot_type_si == 'Complex viscosity vs Angular frequency'", sliderInput( "rheo_af_sli", label = "Angular frequencies", value = c( 0.1, 100 ), min = 0.1, max = 100 ) ),
            conditionalPanel( condition = "input.rheo_plot_type_si == 'Phase angle vs Complex viscosity'", sliderInput( "rheo_cv_sli", label = "Complex Viscosity", value = c( 600, 175000 ), min = 600, max = 175000 ) ),
            conditionalPanel( condition = "input.rheo_plot_type_si == 'Van Gurp-Palmen'", sliderInput( "rheo_cm_sli", label = "Complex Modulus", value = c( 1000, 400000 ), min = 1000, max = 400000 ) ),
            
          ),
          
          actionButton( "rheo_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##rheo_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "rheo_table_ro" ),
          plotOutput( "rheo_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "Colour",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "colour_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "colour_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "colour_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "colour_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel(
            
            checkboxGroupInput( "colour_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.colour_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "colour_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )
            
          ),
          
          actionButton( "colour_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##colour_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "colour_table_ro" ),
          plotlyOutput( "colour_visualisation_po" ),
          
        )
        
      )
      
    ),
    
    tabPanel( "Tensile Testing",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "tt_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "tt_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "tt_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "tt_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel( pickerInput( "tt_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) ),
          
          wellPanel( sliderInput( "tt_strain_sli", label = "Strain", value = c( 0, 450 ), min = 0, max = 450 ) ),
          
          actionButton( "tt_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##tt_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "tt_table_ro" ),
          plotOutput( "tt_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "SHM",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "shm_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "shm_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "shm_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "shm_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel( pickerInput( "shm_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) ),
          
          wellPanel( sliderInput( "shm_strain_sli", label = "Strain", value = c( 0, 250 ), min = 0, max = 250 ) ),
          
          actionButton( "shm_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##shm_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "shm_table_ro" ),
          plotOutput( "shm_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "TLS",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "tls_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "tls_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "tls_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "tls_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel( pickerInput( "tls_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) ),
          
          wellPanel( sliderInput( "tls_strain_sli", label = "Strain", value = c( 0, 15 ), min = 0, max = 15 ) ),
          
          actionButton( "tls_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##tls_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "tls_table_ro" ),
          plotOutput( "tls_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "ESCR",
              
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            p( "Select a group of resins from below to plot, or select from the table:" ),
            
            checkboxInput( "escr_dv1_cb", "Dataset Version 1 (23 resins)" ),
            checkboxInput( "escr_dv2_cb", "Dataset Version 2 (24 resins)" ),
            checkboxInput( "escr_no_virgin_resins_cb", "Exclude virgin resins" ),
            checkboxInput( "escr_no_pp_resins_cb", "Exclude resins with high PP" )
            
          ),
          
          wellPanel( sliderInput( "escr_hours_sli", label = "Hours", value = c( 0, 96 ), min = 0, max = 96 ) ),
          
          actionButton( "escr_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##escr_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "escr_table_ro" ),
          plotOutput( "escr_visualisation_po" )
          
        )
        
      )
      
    ),
    
    tabPanel( "GCMS",
             
      sidebarLayout(
        
        sidebarPanel(
          
          wellPanel(
            
            checkboxGroupInput( "gcms_mean_specimen_cb", "Do you want to plot the means or individual specimens (or both)?", choices = c( "Mean", "Specimen" ) ),
            conditionalPanel( condition = "input.gcms_mean_specimen_cb.includes( 'Specimen' )", pickerInput( "gcms_select_specimens_pi", "Select specimens:", choices = c(), multiple = TRUE, options = pickerOptions( actionsBox = TRUE ) ) )
            
          ),
          
          wellPanel( sliderInput( "gcms_ret_sli", label = "Retention Time Range", value = c( 1, 14.5 ), min = 1, max = 14.5 ) ),
          
          actionButton( "gcms_visualise_ab", "Visualise", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##gcms_visualisation_po" )
          
        ),
        
        mainPanel(
          
          reactableOutput( "gcms_table_ro" ),
          plotOutput( "gcms_visualisation_po" )
          
        )
        
      )
      
    )
    
  )
  
)