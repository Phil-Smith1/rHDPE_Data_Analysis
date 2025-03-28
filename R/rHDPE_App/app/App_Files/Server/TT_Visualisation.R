# TT Visualisation.

# Table output.

output$tt_table_ro <- renderReactable({
  
  req( !is.null( tt_resins_r$tt_resins_r ) )
  
  reactable( data = tt_resins_r$tt_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

tt_selected_resins <- reactive( tt_resins_r$tt_resins_r[getReactableState( "tt_table_ro", "selected" ), "Identifier"] )
tt_selected_specimens <- eventReactive( input$tt_visualise_ab, input$tt_select_specimens_pi )
tt_range <- eventReactive( input$tt_visualise_ab, input$tt_strain_sli )

observe({
  
  selected_resins <- isolate( tt_selected_resins() )
  
  if (!input$tt_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$tt_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tt_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$tt_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tt_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$tt_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "tt_table_ro", tt_resins_r$tt_resins_r, selected = match( selected_resins, tt_resins_r$tt_resins_r$Identifier ), page = isolate( getReactableState( "tt_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( tt_resins_r$tt_resins_r[getReactableState( "tt_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "tt", "Tensile Testing" ) )
    
    req( tt_data$read_data )
    
    specimens <- tt_data$file_data_minus_hidden %>% filter( Resin %in% tt_resins_r$tt_resins_r[getReactableState( "tt_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "tt_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_tt <- eventReactive( input$tt_visualise_ab, {
  
  tt_input_parameters$shiny_samples_to_plot <- tt_selected_resins()
  tt_input_parameters$shiny_specimens_to_plot <- tt_selected_specimens()
  tt_input_parameters$shiny_split <- tt_range()
  
  data_to_plot <- TT_Analysis$TT_plotting$plot_data( tt_input_parameters, tt_data$data_minus_hidden[[1]], tt_data$data_minus_hidden[[2]], c(), c(), current_dataset() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$tt_visualisation_po <- renderPlot({
  
  validate( need( length( tt_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( tt_range()[[1]] != tt_range()[[2]], "Please widen the strain range" ) )
  validate( need( length( tt_selected_specimens() ) > 0, "Please select specimens" ) )
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( tt_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[tt_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( tt_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = tt_range() ) + labs( title = "Stress-strain Curve", x = "Strain [%]", y = "Stress [Pa]" )
    
  marker <- 1
  
  for (s in seq_along( tt_selected_resins() )) {
    
    resin_specimens <- tt_data$file_data_minus_hidden %>% filter( Resin == tt_selected_resins()[s], Label %in% tt_selected_specimens() )
    
    l <- nrow( resin_specimens )
    
    if (l > 0) {
      
      for (i in marker:(marker - 1 + l)) {
        
        g <- g + geom_line( data = obtain_data_to_plot_tt(), aes( x = .data[[colnames( obtain_data_to_plot_tt() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_tt() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
        
        labels <- c( labels, resin_specimens$Label[i - marker + 1] )
        break_order <- c( break_order, as.character( (i * 7) %% 31 + 1 ) )
        
      }
      
    }
        
    marker <- marker + l
      
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
    
}, res = 96 ) %>% bindEvent( input$tt_visualise_ab )