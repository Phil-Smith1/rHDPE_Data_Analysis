# PP prediction tab server code.

pp_results <- reactive( pp_analysis( ftir_data$PP_percentages, input$PP_select_resin_si ) )

output$PP_percentage_po <- renderPlotly({
  
  req( ftir_data$read_data )
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = pp_results()[[1]], number = list( font = list( color = text_colour ), suffix = "%" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 15 ), tickfont = list( color = text_colour, size = 15 ) ),
      steps = list( list(range = c( 0, 2 ), color = "green" ), list( range = c( 2, 5 ), color = "orange" ), list( range = c( 5, 15 ), color = "red" ) ),
      bar = list( color = "purple" )
    )
  ) %>% layout( title = list( text = "Polypropylene Contamination", yanchor = "top", y = 0.95, font = list( color = text_colour, size = 40 ) ), paper_bgcolor = bs_light )
  
})

output$PP_by_specimens_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[2]], aes( x = factor( Specimen ), y = specimen_pp_values ) ) + geom_col( colour = "black", fill = "yellow" ) + ylab( "PP Percentage [%]" ) + xlab( "Specimen" ) + theme( axis.title = element_text( size = 20, colour = "white" ), axis.text = element_text( size = 15, colour = "white" ) )
  
})

output$PP_by_wavenumber_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[3]], aes( x = factor( Wavenumber, levels = unique( Wavenumber ) ), y = wavenumber_pp_values ) ) + geom_col( colour = "black", fill = "yellow" ) + ylab( "PP Percentage [%]" ) + xlab( "Wavenumber" ) + theme( axis.title = element_text( size = 20, colour = "white" ), axis.text = element_text( size = 15, colour = "white" ) )
  
})

output$PP_boxplot_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[4]], aes( x = "", y = complete_values ) ) + geom_boxplot( lwd = 3, outlier.size = 3, colour = "white", fill = "yellow" ) + coord_flip() + ylab( "PP Percentage [%]" ) + xlab( paste( "Resin ", input$si_pp ) ) + theme( axis.title = element_text( size = 20, colour = "white" ), axis.text = element_text( size = 15, colour = "white" ) )
  
})

output$PP_summary_to <- renderTable({
  
  req( ftir_data$read_data )
  
  pp_results()[[5]]
  
})

output$PP_heatmap_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[6]], aes( x = factor( specimen ), y = variable, fill = value ) ) + geom_tile() + geom_text( aes( label = round( value, 2 ) ), size = 8, colour = "black" ) + labs( title = "Predictions in Detail", x = "Specimen", y = "Wavenumber", fill = "PP Content" ) + theme( title = element_text( size = 20, colour = "white", hjust = 0.5 ), axis.title = element_text( size = 20, colour = "white" ), axis.text = element_text( size = 15, colour = "white" ) ) + scale_fill_gradient( low = "white", high = "yellow" )
  
})