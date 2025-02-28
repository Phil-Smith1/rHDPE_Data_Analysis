# TLS Visualisation.

# Table output.

output$tls_table_ro <- renderReactable({
  
  req( !is.null( tls_resins_r$tls_resins_r ) )
  
  reactable( data = tls_resins_r$tls_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

tls_selected_resins <- reactive( tls_resins_r$tls_resins_r[getReactableState( "tls_table_ro", "selected" ), "Identifier"] )
tls_selected_specimens <- eventReactive( input$tls_visualise_ab, input$tls_select_specimens_pi )
tls_range <- eventReactive( input$tls_visualise_ab, input$tls_strain_sli )

observe({
  
  selected_resins <- isolate( tls_selected_resins() )
  
  if (!input$tls_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$tls_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tls_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$tls_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$tls_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$tls_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "tls_table_ro", tls_resins_r$tls_resins_r, selected = match( selected_resins, tls_resins_r$tls_resins_r$Identifier ), page = isolate( getReactableState( "tls_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( tls_resins_r$tls_resins_r[getReactableState( "tls_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "tls", "TLS" ) )
    
    req( tls_data$read_data )
    
    specimens <- tls_data$file_data %>% filter( Resin %in% tls_resins_r$tls_resins_r[getReactableState( "tls_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "tls_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_tls <- eventReactive( input$tls_visualise_ab, {
  
  tls_input_parameters$shiny_samples_to_plot <- tls_selected_resins()
  tls_input_parameters$shiny_specimens_to_plot <- tls_selected_specimens()
  tls_input_parameters$shiny_split <- tls_range()
  
  data_to_plot <- TLS_Analysis$TLS_plotting$plot_data( tls_input_parameters, tls_data$data[[1]], tls_data$data[[2]], c(), c() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$tls_visualisation_po <- renderPlot({
  
  validate( need( length( tls_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( tls_range()[[1]] != tls_range()[[2]], "Please widen the strain range" ) )
  validate( need( length( tls_selected_specimens() ) > 0, "Please select specimens" ) )
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( tls_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[tls_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( tls_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = tls_range() ) + labs( title = "Stress-strain Curve", x = "Strain [%]", y = "Stress [Pa]" )
    
  marker <- 1
  
  for (s in seq_along( tls_selected_resins() )) {
    
    resin_specimens <- tls_data$file_data %>% filter( Resin == tls_selected_resins()[s], Label %in% tls_selected_specimens() )
    
    l <- nrow( resin_specimens )
    
    if (l > 0) {
      
      for (i in marker:(marker - 1 + l)) {
        
        g <- g + geom_line( data = obtain_data_to_plot_tls(), aes( x = .data[[colnames( obtain_data_to_plot_tls() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_tls() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
        
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
    
}, res = 96 ) %>% bindEvent( input$tls_visualise_ab )