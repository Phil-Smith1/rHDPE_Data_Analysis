# TGA Visualisation.

# Table output.

output$tga_table_ro <- renderReactable({
  
  req( !is.null( tga_resins_r$tga_resins_r ) )
  
  reactable( data = tga_resins_r$tga_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

tga_selected_resins <- reactive( tga_resins_r$tga_resins_r[getReactableState( "tga_table_ro", "selected" ), "Identifier"] )
read_tga_mean_specimen_cb <- eventReactive( input$tga_visualise_ab, input$tga_mean_specimen_cb )
tga_selected_specimens <- eventReactive( input$tga_visualise_ab, input$tga_select_specimens_pi )
tga_range <- eventReactive( input$tga_visualise_ab, input$tga_temp_sli )

observe({
  
  selected_resins <- isolate( tga_selected_resins() )
  
  if (!input$tga_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$tga_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tga_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$tga_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tga_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$tga_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "tga_table_ro", tga_resins_r$tga_resins_r, selected = match( selected_resins, tga_resins_r$tga_resins_r$Identifier ), page = isolate( getReactableState( "tga_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( tga_resins_r$tga_resins_r[getReactableState( "tga_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "tga", "TGA" ) )
    
    req( tga_data$read_data )
    
    specimens <- tga_data$file_data_minus_hidden %>% filter( Resin %in% tga_resins_r$tga_resins_r[getReactableState( "tga_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "tga_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_tga <- eventReactive( input$tga_visualise_ab, {
  
  tga_input_parameters$shiny_mean = FALSE
  tga_input_parameters$shiny_specimen = FALSE
  
  if ("Mean" %in% read_tga_mean_specimen_cb()) {
    
    tga_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_tga_mean_specimen_cb()) {
    
    tga_input_parameters$shiny_specimen = TRUE
    
  }
  
  tga_input_parameters$shiny_samples_to_plot <- tga_selected_resins()
  tga_input_parameters$shiny_specimens_to_plot <- tga_selected_specimens()
  tga_input_parameters$shiny_split <- tga_range()
  
  data.frame( TGA_Analysis$TGA_plotting$plot_data( tga_input_parameters, tga_data$data_minus_hidden[[1]], tga_data$data_minus_hidden[[2]], c(), c(), name_appendage = current_dataset() ) )
  
})

output$tga_visualisation_po <- renderPlot({
  
  validate( need( "Specimen" %in% read_tga_mean_specimen_cb() | "Mean" %in% read_tga_mean_specimen_cb() , "Please select mean or specimen (or both)" ) )
  validate( need( length( tga_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( tga_range()[[1]] != tga_range()[[2]], "Please widen the temperature range" ) )
  
  if ("Specimen" %in% read_tga_mean_specimen_cb()) {
    
    validate( need( length( tga_selected_specimens() ) > 0, "Please select specimens" ) )
    
  }
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( tga_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[tga_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( tga_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = tga_range() ) + labs( title = "TGA Curve", x = "Temperature [°C]", y = "Weight Loss [%]" )
    
  if (! "Specimen" %in% read_tga_mean_specimen_cb()) {
    
    for (s in seq_along( tga_selected_resins() )) {
      
      g <- g + geom_line( data = obtain_data_to_plot_tga(), aes( x = .data[[colnames( obtain_data_to_plot_tga() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_tga() )[s * 2]]], color = resin_data_r()$Label[match( tga_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
      
      labels <- c( labels, resin_data_r()$Label[match( tga_selected_resins()[s], resin_data_r()$Identifier )] )
      break_order <- c( break_order, resin_data_r()$Label[match( tga_selected_resins()[s], resin_data_r()$Identifier )] )
      
    }
    
  } else {
    
    marker <- 1
    
    for (s in seq_along( tga_selected_resins() )) {
      
      resin_specimens <- tga_data$file_data_minus_hidden %>% filter( Resin == tga_selected_resins()[s], Label %in% tga_selected_specimens() )
      
      l <- nrow( resin_specimens )
      
      if (l > 0) {
        
        for (i in marker:(marker - 1 + l)) {
          
          g <- g + geom_line( data = obtain_data_to_plot_tga(), aes( x = .data[[colnames( obtain_data_to_plot_tga() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_tga() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
          
          labels <- c( labels, resin_specimens$Label[i - marker + 1] )
          break_order <- c( break_order, as.character( (i * 7) %% 31 + 1 ) )
          
        }
        
      }
          
      marker <- marker + l
      
      if ("Mean" %in% read_tga_mean_specimen_cb()) {
        
        g <- g + geom_line( data = obtain_data_to_plot_tga(), aes( x = .data[[colnames( obtain_data_to_plot_tga() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_tga() )[marker * 2]]], color = resin_data_r()$Label[match( tga_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
        
        labels <- c( labels, resin_data_r()$Label[match( tga_selected_resins()[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, resin_data_r()$Label[match( tga_selected_resins()[s], resin_data_r()$Identifier )] )
        
        marker <- marker + 1
        
      }
        
    }
      
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
    
}, res = 96 ) %>% bindEvent( input$tga_visualise_ab )