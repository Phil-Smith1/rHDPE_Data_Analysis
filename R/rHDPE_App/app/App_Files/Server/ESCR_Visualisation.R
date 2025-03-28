# ESCR Visualisation.

# Table output.

output$escr_table_ro <- renderReactable({
  
  req( !is.null( escr_resins_r$escr_resins_r ) )
  
  reactable( data = escr_resins_r$escr_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

escr_selected_resins <- reactive( escr_resins_r$escr_resins_r[getReactableState( "escr_table_ro", "selected" ), "Identifier"] )
escr_range <- eventReactive( input$escr_visualise_ab, input$escr_hours_sli )

observe({
  
  selected_resins <- isolate( escr_selected_resins() )
  
  if (!input$escr_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$escr_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$escr_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$escr_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$escr_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$escr_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "escr_table_ro", escr_resins_r$escr_resins_r, selected = match( selected_resins, escr_resins_r$escr_resins_r$Identifier ), page = isolate( getReactableState( "escr_table_ro", "page" ) ) )
  
})

obtain_data_to_plot_escr <- eventReactive( input$escr_visualise_ab, {
  
  escr_input_parameters$shiny_samples_to_plot <- escr_selected_resins()
  escr_input_parameters$shiny_split <- escr_range()
  
  data_to_plot <- ESCR_Analysis$ESCR_plotting$plot_data( escr_input_parameters, escr_data$data_minus_hidden[[1]], escr_data$data_minus_hidden[[2]], name_appendage = current_dataset() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$escr_visualisation_po <- renderPlot({
  
  validate( need( length( escr_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( escr_range()[[1]] != escr_range()[[2]], "Please widen the hours range" ) )
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( escr_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[escr_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( escr_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = escr_range() ) + labs( title = "ESCR", x = "Hours [hr]", y = "Success rate [%]" )
    
  for (s in seq_along( escr_selected_resins() )) {
    
    g <- g + geom_line( data = obtain_data_to_plot_escr(), aes( x = .data[[colnames( obtain_data_to_plot_escr() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_escr() )[s * 2]]], color = resin_data_r()$Label[match( escr_selected_resins()[!!s], resin_data_r()$Identifier )] ) )
    
    labels <- c( labels, resin_data_r()$Label[match( escr_selected_resins()[s], resin_data_r()$Identifier )] )
    break_order <- c( break_order, resin_data_r()$Label[match( escr_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
    
}, res = 96 ) %>% bindEvent( input$escr_visualise_ab )