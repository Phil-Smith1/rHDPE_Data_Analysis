# FTIR Visualisation.

# Table output.

output$ftir_table_ro <- renderReactable({
  
  req( !is.null( ftir_resins_r$ftir_resins_r ) )
  
  reactable( data = ftir_resins_r$ftir_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

ftir_selected_resins <- reactive( ftir_resins_r$ftir_resins_r[getReactableState( "ftir_table_ro", "selected" ), "Identifier"] )
read_ftir_mean_specimen_cb <- eventReactive( input$ftir_visualise_ab, input$ftir_mean_specimen_cb )
ftir_selected_specimens <- eventReactive( input$ftir_visualise_ab, input$ftir_select_specimens_pi )
ftir_range <- eventReactive( input$ftir_visualise_ab, rev( input$ftir_wavenumbers_sli ) )

observe({
  
  selected_resins <- isolate( ftir_selected_resins() )
  
  if (!input$ftir_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$ftir_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$ftir_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$ftir_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$ftir_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$ftir_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "ftir_table_ro", ftir_resins_r$ftir_resins_r, selected = match( selected_resins, ftir_resins_r$ftir_resins_r$Identifier ), page = isolate( getReactableState( "ftir_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( ftir_resins_r$ftir_resins_r[getReactableState( "ftir_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "ftir", "FTIR" ) )
    
    req( ftir_data$read_data )
    
    specimens <- ftir_data$file_data_minus_hidden %>% filter( Resin %in% ftir_resins_r$ftir_resins_r[getReactableState( "ftir_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "ftir_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_ftir <- eventReactive( input$ftir_visualise_ab, {
  
  ftir_input_parameters$shiny_mean = FALSE
  ftir_input_parameters$shiny_specimen = FALSE
  
  if ("Mean" %in% read_ftir_mean_specimen_cb()) {
    
    ftir_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_ftir_mean_specimen_cb()) {
    
    ftir_input_parameters$shiny_specimen = TRUE
    
  }
  
  ftir_input_parameters$shiny_samples_to_plot <- ftir_selected_resins()
  ftir_input_parameters$shiny_specimens_to_plot <- ftir_selected_specimens()
  ftir_input_parameters$shiny_split <- ftir_range()
  
  data.frame( FTIR_Analysis$FTIR_plotting$plot_data( ftir_input_parameters, ftir_data$data_minus_hidden[[1]], ftir_data$data_minus_hidden[[2]], c(), c(), c(), c(), c(), c(), c() ) )
  
})
  
output$ftir_visualisation_po <- renderPlot({
  
  validate( need( "Specimen" %in% read_ftir_mean_specimen_cb() | "Mean" %in% read_ftir_mean_specimen_cb(), "Please select mean or specimen (or both)" ) )
  validate( need( length( ftir_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( ftir_range()[[1]] != ftir_range()[[2]], "Please widen the wavenumber range" ) )
  
  if ("Specimen" %in% read_ftir_mean_specimen_cb()) {
    
    validate( need( length( ftir_selected_specimens() ) > 0, "Please select specimens" ) )
    
  }
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( ftir_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[ftir_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( ftir_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = rev( ftir_range() ) ) + labs( title = "FTIR Spectrum", x = expression( paste( "Wavenumber [cm"^-1, "]" ) ), y = "Absorbance" ) + scale_x_reverse()
  
  if (! "Specimen" %in% read_ftir_mean_specimen_cb()) {
    
    for (s in seq_along( ftir_selected_resins() )) {
      
      g <- g + geom_line( data = obtain_data_to_plot_ftir(), aes( x = .data[[colnames( obtain_data_to_plot_ftir() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_ftir() )[s * 2]]], color = resin_data_r()$Label[match( ftir_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
      
      labels <- c( labels, resin_data_r()$Label[match( ftir_selected_resins()[s], resin_data_r()$Identifier )] )
      break_order <- c( break_order, resin_data_r()$Label[match( ftir_selected_resins()[s], resin_data_r()$Identifier )] )
      
    }
    
  } else {
    
    marker <- 1
    
    for (s in seq_along( ftir_selected_resins() )) {
      
      resin_specimens <- ftir_data$file_data_minus_hidden %>% filter( Resin == ftir_selected_resins()[s], Label %in% ftir_selected_specimens() )
      
      l <- nrow( resin_specimens )
      
      if (l > 0) {
        
        for (i in marker:(marker - 1 + l)) {
          
          g <- g + geom_line( data = obtain_data_to_plot_ftir(), aes( x = .data[[colnames( obtain_data_to_plot_ftir() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_ftir() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
          
          labels <- c( labels, resin_specimens$Label[i - marker + 1] )
          break_order <- c( break_order, as.character( (i * 7) %% 31 + 1 ) )
          
        }
        
      }
      
      marker <- marker + l
      
      if ("Mean" %in% read_ftir_mean_specimen_cb()) {
        
        g <- g + geom_line( data = obtain_data_to_plot_ftir(), aes( x = .data[[colnames( obtain_data_to_plot_ftir() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_ftir() )[marker * 2]]], color = resin_data_r()$Label[match( ftir_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
        
        labels <- c( labels, resin_data_r()$Label[match( ftir_selected_resins()[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, resin_data_r()$Label[match( ftir_selected_resins()[s], resin_data_r()$Identifier )] )
        
        marker <- marker + 1
        
      }
      
    }
    
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
  
}, res = 96 ) %>% bindEvent( input$ftir_visualise_ab )