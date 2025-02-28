# SHM Visualisation.

# Table output.

output$shm_table_ro <- renderReactable({
  
  req( !is.null( shm_resins_r$shm_resins_r ) )
  
  reactable( data = shm_resins_r$shm_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

shm_selected_resins <- reactive( shm_resins_r$shm_resins_r[getReactableState( "shm_table_ro", "selected" ), "Identifier"] )
shm_selected_specimens <- eventReactive( input$shm_visualise_ab, input$shm_select_specimens_pi )
shm_range <- eventReactive( input$shm_visualise_ab, input$shm_strain_sli )

observe({
  
  selected_resins <- isolate( shm_selected_resins() )
  
  if (!input$shm_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$shm_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$shm_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$shm_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$shm_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$shm_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "shm_table_ro", shm_resins_r$shm_resins_r, selected = match( selected_resins, shm_resins_r$shm_resins_r$Identifier ), page = isolate( getReactableState( "shm_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( shm_resins_r$shm_resins_r[getReactableState( "shm_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "shm", "SHM" ) )
    
    req( shm_data$read_data )
    
    specimens <- shm_data$file_data %>% filter( Resin %in% shm_resins_r$shm_resins_r[getReactableState( "shm_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "shm_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_shm <- eventReactive( input$shm_visualise_ab, {
  
  shm_input_parameters$shiny_samples_to_plot <- shm_selected_resins()
  shm_input_parameters$shiny_specimens_to_plot <- shm_selected_specimens()
  shm_input_parameters$shiny_split <- shm_range()
  
  data_to_plot <- SHM_Analysis$SHM_plotting$plot_data( shm_input_parameters, shm_data$data[[1]], shm_data$data[[2]], c() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$shm_visualisation_po <- renderPlot({
  
  validate( need( length( shm_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( shm_range()[[1]] != shm_range()[[2]], "Please widen the strain range" ) )
  validate( need( length( shm_selected_specimens() ) > 0, "Please select specimens" ) )
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( shm_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[shm_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, resin_data_r()$Label[match( shm_selected_resins()[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, as.character( 1:31 ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = shm_range() ) + labs( title = "Stress-strain Curve", x = "Strain [%]", y = "Stress [Pa]" )
    
  marker <- 1
  
  for (s in seq_along( shm_selected_resins() )) {
    
    resin_specimens <- shm_data$file_data %>% filter( Resin == shm_selected_resins()[s], Label %in% shm_selected_specimens() )
    
    l <- nrow( resin_specimens )
    
    if (l > 0) {
      
      for (i in marker:(marker - 1 + l)) {
        
        g <- g + geom_line( data = obtain_data_to_plot_shm(), aes( x = .data[[colnames( obtain_data_to_plot_shm() )[i * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_shm() )[i * 2]]], color = as.character( (!!i * 7) %% 31 + 1 ) ) )
        
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
    
}, res = 96 ) %>% bindEvent( input$shm_visualise_ab )