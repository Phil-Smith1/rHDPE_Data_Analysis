#===============
# Tab for displaying pairwise feature correlations.

featureCorrelationsTab <- tabPanel( "Feature Correlations",
          
  sidebarLayout(

    sidebarPanel(
      
      wellPanel(
        
        selectInput( "corr_select_x_si", "Select x axis:", choices = setNames( features_labels, features_human_labels ) ),
        selectInput( "corr_select_y_si", "Select y axis:", choices = setNames( features_labels, features_human_labels ) )
        
      ),
      
      wellPanel(
        
        p( "Select a group of resins from below to plot, or select a custom set of resins:" ),
        
        checkboxInput( "corr_dv1_cb", "Dataset Version 1 (23 resins)" ),
        checkboxInput( "corr_dv2_cb", "Dataset Version 2 (24 resins)" ),
        checkboxInput( "corr_no_virgin_resins_cb", "Exclude virgin resins" ),
        checkboxInput( "corr_no_pp_resins_cb", "Exclude resins with high PP" ),
        checkboxInput( "corr_custom_resins_cb", "Select custom resins" ),
        conditionalPanel( condition = "input.corr_custom_resins_cb == true", reactableOutput( "corr_table_ro" ) ),
        
      ),

      actionButton( "corr_plot_ab", "Plot scatterplot", width = "100%" ) %>% a() %>% tagAppendAttributes( href = "##corr_po" ),
      
      wellPanel(
        
        p( "Line and curve fitting:" ),
        
        checkboxInput( "corr_regression_line_cb", "Add regression line and compute R2 value and Pearson correlation coefficient" ),
        checkboxInput( "corr_exponential_fit_cb", "Perform an exponential fit to the data" )
        
      ),
      
      wellPanel(
        
        p( "Plot customisation:" ),
        
        checkboxInput( "corr_add_labels_cb", "Labels next to points" ),
        checkboxInput( "corr_limits_cb", "Restrict axis limits" ),
        checkboxInput( "corr_savefig_cb", "Save the figure" )
        
      )

    ),

    mainPanel(

      plotOutput( "corr_po", height = 800 ),
      conditionalPanel( condition = "input.corr_regression_line_cb", textOutput( "corr_r2_to" ), textOutput( "corr_pearson_to" ) ),
      conditionalPanel( condition = "input.corr_exponential_fit_cb", textOutput( "corr_exponential_fit_to" ), textOutput( "corr_exponential_fit_r2_to" ) )

    )

  )
  
)