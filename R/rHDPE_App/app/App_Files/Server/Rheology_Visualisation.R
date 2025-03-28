# Rheology Visualisation.

# Table output.

output$rheo_table_ro <- renderReactable({
  
  req( !is.null( rheo_resins_r$rheo_resins_r ) )
  
  reactable( data = rheo_resins_r$rheo_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

rheo_selected_resins <- reactive( rheo_resins_r$rheo_resins_r[getReactableState( "rheo_table_ro", "selected" ), "Identifier"] )
read_rheo_mean_specimen_cb <- eventReactive( input$rheo_visualise_ab, input$rheo_mean_specimen_cb )
rheo_selected_specimens <- eventReactive( input$rheo_visualise_ab, input$rheo_select_specimens_pi )
rheo_plot_type <- eventReactive( input$rheo_visualise_ab, input$rheo_plot_type_si )
rheo_af_range <- eventReactive( input$rheo_visualise_ab, input$rheo_af_sli )
rheo_cv_range <- eventReactive( input$rheo_visualise_ab, input$rheo_cv_sli )
rheo_cm_range <- eventReactive( input$rheo_visualise_ab, input$rheo_cm_sli )

observe({
  
  selected_resins <- isolate( rheo_selected_resins() )
  
  if (!input$rheo_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$rheo_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$rheo_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$rheo_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$rheo_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$rheo_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "rheo_table_ro", rheo_resins_r$rheo_resins_r, selected = match( selected_resins, rheo_resins_r$rheo_resins_r$Identifier ), page = isolate( getReactableState( "rheo_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( rheo_resins_r$rheo_resins_r[getReactableState( "rheo_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "rheo", "Rheology" ) )
    
    req( rheo_data$read_data )
    
    specimens <- rheo_data$file_data_minus_hidden %>% filter( Resin %in% rheo_resins_r$rheo_resins_r[getReactableState( "rheo_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "rheo_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_rheo <- eventReactive( input$rheo_visualise_ab, {
  
  rheo_input_parameters$shiny_mean = FALSE
  rheo_input_parameters$shiny_specimen = FALSE
  rheo_input_parameters$shiny_cv_vs_af = FALSE
  rheo_input_parameters$shiny_pa_vs_cv = FALSE
  rheo_input_parameters$shiny_vgp = FALSE
  
  if ("Mean" %in% read_rheo_mean_specimen_cb()) {
    
    rheo_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_rheo_mean_specimen_cb()) {
    
    rheo_input_parameters$shiny_specimen = TRUE
    
  }
  
  rheo_input_parameters$shiny_samples_to_plot <- rheo_selected_resins()
  rheo_input_parameters$shiny_specimens_to_plot <- rheo_selected_specimens()
  
  if (rheo_plot_type() == "Complex viscosity vs Angular frequency") {
    
    rheo_input_parameters$shiny_cv_vs_af = TRUE
    rheo_input_parameters$shiny_split <- rheo_af_range()
    
  }
  
  if (rheo_plot_type() == "Phase angle vs Complex viscosity") {
    
    rheo_input_parameters$shiny_pa_vs_cv = TRUE
    rheo_input_parameters$shiny_split <- rheo_cv_range()
    
  }
  
  if (rheo_plot_type() == "Van Gurp-Palmen") {
    
    rheo_input_parameters$shiny_vgp = TRUE
    rheo_input_parameters$shiny_split <- rheo_cm_range()
    
  }
  
  data_to_plot <- Rheology_Analysis$rheology_plotting$plot_data( rheo_input_parameters, rheo_data$data_minus_hidden[[1]], rheo_data$data_minus_hidden[[2]], c(), c(), name_appendage = current_dataset() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$rheo_visualisation_po <- renderPlot({
  
  validate( need( "Specimen" %in% read_rheo_mean_specimen_cb() | "Mean" %in% read_rheo_mean_specimen_cb() , "Please select mean or specimen (or both)" ) )
  validate( need( length( rheo_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( ncol( obtain_data_to_plot_rheo() ) > 0, "Please widen the x-axis range" ) )
  
  if ("Specimen" %in% read_rheo_mean_specimen_cb()) {
    
    validate( need( length( rheo_selected_specimens() ) > 0, "Please select specimens" ) )
    
  }
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( rheo_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[rheo_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( rheo_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot()
  
  if (rheo_plot_type() == "Complex viscosity vs Angular frequency") {
   
    g <- g + coord_cartesian( xlim = rheo_af_range() ) + labs( title = "Complex viscosity vs angular frequency", x = "Angular Frequency [rad/s]", y = "Complex Viscosity [Pa.s]" ) + scale_x_continuous( trans = "log10" ) + scale_y_continuous( trans = "log10" )
    
  }
  
  if (rheo_plot_type() == "Phase angle vs Complex viscosity") {
    
    g <- g + coord_cartesian( xlim = rheo_cv_range() ) + labs( title = "Phase angle vs complex viscosity", x = "Complex Viscosity [Pa.s]", y = "Phase angle" ) + scale_x_continuous( trans = "log10" )
    
  }
  
  if (rheo_plot_type() == "Van Gurp-Palmen") {
    
    g <- g + coord_cartesian( xlim = rheo_cm_range() ) + labs( title = "Van Gurp-Palmen", x = "Complex modulus [Pa]", y = "Phase angle" ) + scale_x_continuous( trans = "log10" )
    
  }
    
  if (! "Specimen" %in% read_rheo_mean_specimen_cb()) {
    
    for (s in seq_along( rheo_selected_resins() )) {
      
      g <- g + geom_point( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[s * 2]]], color = resin_data_r()$Label[match( rheo_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
      g <- g + geom_line( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[s * 2]]], color = resin_data_r()$Label[match( rheo_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
      
      labels <- c( labels, resin_data_r()$Label[match( rheo_selected_resins()[s], resin_data_r()$Identifier )] )
      break_order <- c( break_order, resin_data_r()$Label[match( rheo_selected_resins()[s], resin_data_r()$Identifier )] )
      
    }
    
  } else {
    
    marker <- 1
    
    for (s in seq_along( rheo_selected_resins() )) {
      
      resin_specimens <- rheo_data$file_data_minus_hidden %>% filter( Resin == rheo_selected_resins()[s], Label %in% rheo_selected_specimens() )
      
      l <- nrow( resin_specimens )
      
      if (l > 0) {
        
        for (i in marker:(marker - 1 + l)) {
          
          g <- g + geom_point( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
          g <- g + geom_line( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
          
          labels <- c( labels, resin_specimens$Label[i - marker + 1] )
          break_order <- c( break_order, as.character( (i * 7) %% 31 + 1 ) )
          
        }
        
      }
          
      marker <- marker + l
      
      if ("Mean" %in% read_rheo_mean_specimen_cb()) {
        
        g <- g + geom_point( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[marker * 2]]], color = resin_data_r()$Label[match( rheo_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
        g <- g + geom_line( data = obtain_data_to_plot_rheo(), aes( x = .data[[colnames( obtain_data_to_plot_rheo() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_rheo() )[marker * 2]]], color = resin_data_r()$Label[match( rheo_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
        
        labels <- c( labels, resin_data_r()$Label[match( rheo_selected_resins()[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, resin_data_r()$Label[match( rheo_selected_resins()[s], resin_data_r()$Identifier )] )
        
        marker <- marker + 1
        
      }
        
    }
      
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
    
}, res = 96 ) %>% bindEvent( input$rheo_visualise_ab )