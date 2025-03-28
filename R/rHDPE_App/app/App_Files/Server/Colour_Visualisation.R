# Colour Visualisation.

# Table output.

output$colour_table_ro <- renderReactable({
  
  req( !is.null( colour_resins_r$colour_resins_r ) )
  
  reactable( data = colour_resins_r$colour_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

colour_selected_resins <- reactive( colour_resins_r$colour_resins_r[getReactableState( "colour_table_ro", "selected" ), "Identifier"] )
read_colour_mean_specimen_cb <- eventReactive( input$colour_visualise_ab, input$colour_mean_specimen_cb )
colour_selected_specimens <- eventReactive( input$colour_visualise_ab, input$colour_select_specimens_pi )

observe({
  
  selected_resins <- isolate( colour_selected_resins() )
  
  if (!input$colour_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$colour_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$colour_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$colour_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$colour_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$colour_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "colour_table_ro", colour_resins_r$colour_resins_r, selected = match( selected_resins, colour_resins_r$colour_resins_r$Identifier ), page = isolate( getReactableState( "colour_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( colour_resins_r$colour_resins_r[getReactableState( "colour_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "colour", "Colour" ) )
    
    req( colour_data$read_data )
    
    specimens <- colour_data$file_data_minus_hidden %>% filter( Resin %in% colour_resins_r$colour_resins_r[getReactableState( "colour_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "colour_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_colour <- eventReactive( input$colour_visualise_ab, {
  
  colour_input_parameters$shiny_mean = FALSE
  colour_input_parameters$shiny_specimen = FALSE
  
  if ("Mean" %in% read_colour_mean_specimen_cb()) {
    
    colour_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_colour_mean_specimen_cb()) {
    
    colour_input_parameters$shiny_specimen = TRUE
    
  }
  
  colour_input_parameters$shiny_samples_to_plot <- colour_selected_resins()
  colour_input_parameters$shiny_specimens_to_plot <- colour_selected_specimens()
  
  if (colour_data$compute_features) { initiate_data_reading( "colour", "Colour" ); compute_colour_features( colour_input_parameters, current_dataset, colour_data ) }
  
  data_to_plot <- data.frame( Colour_Analysis$Colour_plotting$plot_data( colour_input_parameters, colour_data$data_minus_hidden[[1]], colour_data$data_minus_hidden[[2]], name_appendage = current_dataset() ) )
  
  colnames( data_to_plot ) <- c( "L", "a", "b" )
  
  data_to_plot
  
})

output$colour_visualisation_po <- renderPlotly({
  
  validate( need( "Specimen" %in% read_colour_mean_specimen_cb() | "Mean" %in% read_colour_mean_specimen_cb() , "Please select mean or specimen" ) )
  validate( need( !("Specimen" %in% read_colour_mean_specimen_cb() & "Mean" %in% read_colour_mean_specimen_cb()) , "Please select one of mean or specimen" ) )
  validate( need( length( colour_selected_resins() ) > 0, "Please select resins" ) )

  if ("Specimen" %in% read_colour_mean_specimen_cb()) {

    validate( need( length( colour_selected_specimens() ) > 0, "Please select specimens" ) )

  }
  
  resin_colours <- c()
  resin_names <- c()
  
  if ("Mean" %in% read_colour_mean_specimen_cb()) {

    for (s in seq_along( colour_selected_resins() )) {
  
      resin_colours <- c( resin_colours, rgb( list_of_colours[colour_selected_resins()[s] + 1,] ) )
      resin_names <- c( resin_names, resin_data_r()$Label[match( colour_selected_resins()[s], resin_data_r()$Identifier )] )
  
    }
    
  }
  
  if ("Specimen" %in% read_colour_mean_specimen_cb()) {
    
    specimens <- colour_data$file_data_minus_hidden %>% filter( Label %in% colour_selected_specimens() )
    
    for (i in 1:nrow( specimens )) {
      
      resin_colours <- c( resin_colours, rgb( list_of_colours[specimens[[i, 1]] + 1,] ) )
      resin_names <- c( resin_names, specimens[[i, 3]] )
      
    }
    
  }
  
  fig <- plot_ly( obtain_data_to_plot_colour(), type = "scatter3d", x = ~a, y = ~b, z = ~L, marker = list( color = resin_colours ), name = factor( resin_names, levels = resin_names ) )
  
  fig
  
}) %>% bindEvent( input$colour_visualise_ab )