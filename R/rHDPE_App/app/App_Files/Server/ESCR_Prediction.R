# ESCR prediction tab server code.

observeEvent( input$ESCRP_select_model_rb, {
  
  model_version = ""
  
  if (input$ESCRP_select_model_rb == "General") model_version = "23456710"
  
  if (input$ESCRP_select_model_rb == "DSC") model_version = "27"
  
  global_data[["SHM_AvsP"]] <- suppressMessages( read_csv( paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_Actual_vs_Predicted_", model_version, current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
  global_data[["SHM_ESCR_Predictions"]] <- suppressMessages( read_csv( paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_ESCR_Prediction_", model_version, current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
}, ignoreInit = TRUE )

# ESCRP_shm_value <- reactive( global_data$ESCR_Predictions %>% filter( sample == input$ESCRP_select_resin_si ) %>% pull( SHM ) )
ESCRP_escr_value <- reactive( global_data$SHM_ESCR_Predictions %>% filter( sample == input$ESCRP_select_resin_si ) %>% pull( ESCR_Prediction ) )

# output$ESCRP_SHM_po <- renderPlotly({
#   
#   fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = ESCRP_shm_value(), title = list( text = "Strain Hardening Modulus", font = list( color = text_colour ) ),
#     type = "indicator", mode = "gauge+number",
#     gauge = list(
#       steps = list( list( range = c( 0, 15 ), color = "purple" ) ),
#       axis = list( range = c( 0, 15 ) ),
#       bar = list( color = "lightblue" )
#     )
#   ) %>% layout( paper_bgcolor = bs_light, margin = list( l = 20, r = 20, t = 20 ) )
#   
# })

output$ESCRP_ESCR_po <- renderPlotly({
  
  fig <- plot_ly(
    
    domain = list( x = c( 0, 1 ), y = c( 0, 0.77 ) ), value = ESCRP_escr_value(),
    number = list( font = list( color = text_colour ), suffix = " Hours" ),
    # title = list( text = "Predicted ESCR", font = list( color = text_colour, size = 40 ) ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      steps = list( list( range = c( 0, 90 ), color = bs_primary ) ),
      axis = list( range = c( 0, 90 ), tickfont = list( color = text_colour, size = 15 ) ),
      bar = list( color = "purple" )
    )
    
  ) %>% layout( title = list( text = "Predicted ESCR", yanchor = "top", y = 0.95, font = list( color = text_colour, size = 40 ) ), paper_bgcolor = bs_light )
  
})

obtain_shm_escr_data <- reactive({
  
  obtain_scatterplot_data_to_plot( global_input_parameters, "SHM", "ESCR_50%Failure", c() )
  
})

output$ESCRP_po <- renderPlot({
  
  resin_colours <- c()
  resin_names <- c()
  labels <- c()
  
  for (s in seq_along( obtain_shm_escr_data()[[5]] )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[obtain_shm_escr_data()[[5]][s] + 1,] ) )
    resin_names <- c( resin_names, obtain_shm_escr_data()[[5]][s] )
    labels <- c( labels, resin_data_r()$Label[match( obtain_shm_escr_data()[[5]][s], resin_data_r()$Identifier )] )
    
  }
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  g <- ggplot( data = obtain_shm_escr_data(), aes( x = X, y = Y, color = fct_inorder( as.factor( Resin ) ) ) )
  
  g <- g + labs( title = paste0( "Scatterplot of ", features_metadata$Axis_Label[match( "SHM", features_metadata$Feature_Label )], " vs ", features_metadata$Axis_Label[match( "ESCR_50%Failure", features_metadata$Feature_Label )] ), x = features_metadata$Axis_Label[match( "SHM", features_metadata$Feature_Label )], y = features_metadata$Axis_Label[match( "ESCR_50%Failure", features_metadata$Feature_Label )] )
    
  g <- g + geom_point( size = 5 )
  
  g <- g + scale_colour_manual( name = "Resin", values = resin_names_and_colours, label = labels )
  
  g <- g + theme( title = element_text( size = 24, hjust = 0.5 ), aspect.ratio = 1, axis.title = element_text( size = 24 ), legend.title = element_text( size = 24 ), legend.text = element_text( size = 24 ), axis.text = element_text( size = 24 ) )
  
  g <- g + geom_errorbar( aes( ymin = Y - EY, ymax = Y + EY ), size = 1.5, show.legend = FALSE ) + geom_errorbarh( aes( xmin = X - EX, xmax = X + EX ), size = 1.5, show.legend = FALSE )
  
  g
  
})

output$ESCRP_shm_prediction_po <- renderPlot({
  
  resin_colours <- c()
  resin_names <- c()
  labels <- c()
  
  sample_mask <- global_data$SHM_AvsP[["sample"]]
  
  for (s in seq_along( sample_mask )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[sample_mask[s] + 1,] ) )
    resin_names <- c( resin_names, sample_mask[s] )
    labels <- c( labels, resin_data_r()$Label[match( sample_mask[s], resin_data_r()$Identifier )] )
    
  }
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  g <- ggplot( data = global_data$SHM_AvsP, aes( x = SHM, y = SHM_True, color = fct_inorder( as.factor( sample ) ) ) )
  
  g <- g + labs( title = "Predicted SHM vs Actual SHM", x = "Predicted SHM", y = "Actual SHM" )
  
  g <- g + geom_point( size = 5 )
  
  g <- g + scale_colour_manual( name = "Resin", values = resin_names_and_colours, label = labels )
  
  g <- g + theme( title = element_text( size = 24, hjust = 0.5 ), aspect.ratio = 1, axis.title = element_text( size = 24 ), legend.title = element_text( size = 24 ), legend.text = element_text( size = 24 ), axis.text = element_text( size = 24 ) )
  
  g <- g + geom_errorbar( aes( ymin = SHM_True - SHM_std, ymax = SHM_True + SHM_std ), size = 1.5, show.legend = FALSE )
  
  g
  
})

