# GCMS Visualisation.

# Table output.

output$gcms_table_ro <- renderReactable({
  
  req( !is.null( gcms_resins_r$gcms_resins_r ) )
  
  reactable( data = gcms_resins_r$gcms_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE )
  
})

gcms_selected_resins <- reactive( gcms_resins_r$gcms_resins_r[getReactableState( "gcms_table_ro", "selected" ), "Identifier"] )
read_gcms_mean_specimen_cb <- eventReactive( input$gcms_visualise_ab, input$gcms_mean_specimen_cb )
gcms_selected_specimens <- eventReactive( input$gcms_visualise_ab, input$gcms_select_specimens_pi )
gcms_range <- eventReactive( input$gcms_visualise_ab, input$gcms_ret_sli )

observe({
  
  if (length( gcms_resins_r$gcms_resins_r[getReactableState( "gcms_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "gcms", "GCMS" ) )
    
    req( gcms_data$read_data )
    
    specimens <- gcms_data$file_data %>% filter( Resin %in% gcms_resins_r$gcms_resins_r[getReactableState( "gcms_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "gcms_select_specimens_pi", choices = specimens )
    
  }

})

obtain_data_to_plot_gcms <- eventReactive( input$gcms_visualise_ab, {
  
  gcms_input_parameters$shiny_mean = FALSE
  gcms_input_parameters$shiny_specimen = FALSE
  
  if ("Mean" %in% read_gcms_mean_specimen_cb()) {
    
    gcms_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_gcms_mean_specimen_cb()) {
    
    gcms_input_parameters$shiny_specimen = TRUE
    
  }
  
  gcms_input_parameters$shiny_samples_to_plot <- gcms_selected_resins()
  gcms_input_parameters$shiny_specimens_to_plot <- gcms_selected_specimens()
  gcms_input_parameters$shiny_split <- gcms_range()
  
  data.frame( GCMS_Analysis$GCMS_plotting$plot_data( gcms_input_parameters, gcms_data$data[[1]], gcms_data$data[[2]], c(), c(), c() ) )
  
})

output$gcms_visualisation_po <- renderPlot({
  
  validate( need( "Specimen" %in% read_gcms_mean_specimen_cb() | "Mean" %in% read_gcms_mean_specimen_cb() , "Please select mean or specimen (or both)" ) )
  validate( need( length( gcms_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( gcms_range()[[1]] != gcms_range()[[2]], "Please widen the retention time range" ) )
  
  if ("Specimen" %in% read_gcms_mean_specimen_cb()) {
    
    validate( need( length( gcms_selected_specimens() ) > 0, "Please select specimens" ) )
    
  }
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( gcms_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[gcms_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( gcms_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = gcms_range() ) + labs( title = "GCMS Spectrum", x = "Retention Time [minutes]", y = "Absorbance" )
  
  if (! "Specimen" %in% read_gcms_mean_specimen_cb()) {
    
    for (s in seq_along( gcms_selected_resins() )) {
      
      g <- g + geom_line( data = obtain_data_to_plot_gcms(), aes( x = .data[[colnames( obtain_data_to_plot_gcms() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_gcms() )[s * 2]]], color = resin_data_r()$Label[match( gcms_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
      
      labels <- c( labels, resin_data_r()$Label[match( gcms_selected_resins()[s], resin_data_r()$Identifier )] )
      break_order <- c( break_order, resin_data_r()$Label[match( gcms_selected_resins()[s], resin_data_r()$Identifier )] )
      
    }
    
  } else {
    
    marker <- 1
    
    for (s in seq_along( gcms_selected_resins() )) {
      
      resin_specimens <- gcms_data$file_data %>% filter( Resin == gcms_selected_resins()[s], Label %in% gcms_selected_specimens() )
      
      l <- nrow( resin_specimens )
      
      if (l > 0) {
        
        for (i in marker:(marker - 1 + l)) {
          
          g <- g + geom_line( data = obtain_data_to_plot_gcms(), aes( x = .data[[colnames( obtain_data_to_plot_gcms() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_gcms() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
          
          labels <- c( labels, resin_specimens$Label[i - marker + 1] )
          break_order <- c( break_order, as.character( (i * 7) %% 31 + 1 ) )
          
        }
        
      }
      
      marker <- marker + l
      
      if ("Mean" %in% read_gcms_mean_specimen_cb()) {
        
        g <- g + geom_line( data = obtain_data_to_plot_gcms(), aes( x = .data[[colnames( obtain_data_to_plot_gcms() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_gcms() )[marker * 2]]], color = resin_data_r()$Label[match( gcms_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
        
        labels <- c( labels, resin_data_r()$Label[match( gcms_selected_resins()[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, resin_data_r()$Label[match( gcms_selected_resins()[s], resin_data_r()$Identifier )] )
        
        marker <- marker + 1
        
      }
      
    }
    
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
  
}, res = 96 ) %>% bindEvent( input$gcms_visualise_ab )