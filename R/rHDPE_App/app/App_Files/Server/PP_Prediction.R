# PP prediction tab server code.

pp_results <- reactive( pp_analysis( ftir_data$PP_percentages, input$PP_select_resin_si ) )

output$PP_percentage_po <- renderPlotly({
  
  req( ftir_data$read_data )
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = pp_results()[[1]], number = list( font = list( color = text_colour ), suffix = "%" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 15 ), tickfont = list( color = text_colour, size = 15 ) ),
      steps = list( list(range = c( 0, 5 ), color = "green" ), list( range = c( 5, 10 ), color = "orange" ), list( range = c( 10, 15 ), color = "red" ) ),
      bar = list( color = "purple" )
    )
  ) %>% layout( title = list( text = "Polypropylene Contamination", yanchor = "top", y = 0.95, font = list( color = text_colour, size = 40 ) ), paper_bgcolor = bs_light )
  
})

output$PP_by_specimens_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[2]], aes( x = factor( Specimen ), y = specimen_pp_values ) ) + geom_col( colour = "white", fill = bs_primary ) + ylab( "PP Percentage [%]" ) + xlab( "Specimen" ) + theme( axis.title = element_text( size = 25, colour = "white" ), axis.text = element_text( size = 20, colour = "white" ), panel.background = element_rect( colour = secondary_colour ), panel.grid.major = element_line( colour = secondary_colour ), axis.ticks = element_line( colour = secondary_colour ) )
  
})

output$PP_by_wavenumber_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[3]], aes( x = factor( Wavenumber, levels = unique( Wavenumber ) ), y = wavenumber_pp_values ) ) + geom_col( colour = "white", fill = bs_primary ) + ylab( "PP Percentage [%]" ) + xlab( expression( "Wavenumber [cm"^"-1"*"]" ) ) + theme( axis.title = element_text( size = 25, colour = "white" ), axis.text = element_text( size = 20, colour = "white" ), panel.background = element_rect( colour = secondary_colour ), panel.grid.major = element_line( colour = secondary_colour ), axis.ticks = element_line( colour = secondary_colour ) )
  
})

output$PP_boxplot_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[4]], aes( x = "", y = complete_values ) ) + geom_boxplot( lwd = 2, outlier.size = 3, colour = "white", fill = bs_primary ) + coord_flip() + ylab( "PP Percentage [%]" ) + xlab( paste( "Resin ", input$si_pp ) ) + theme( axis.title = element_text( size = 25, colour = "white" ), axis.text = element_text( size = 20, colour = "white" ), panel.background = element_rect( colour = secondary_colour ), panel.grid.major = element_line( colour = secondary_colour ), axis.ticks = element_line( colour = secondary_colour ) )
  
})

output$PP_summary_to <- renderTable({
  
  req( ftir_data$read_data )
  
  pp_results()[[5]]
  
})

output$PP_heatmap_po <- renderPlot({
  
  req( ftir_data$read_data )
  
  ggplot( pp_results()[[6]], aes( x = factor( specimen ), y = variable, fill = value ) ) + geom_tile() + geom_text( aes( label = round( value, 2 ) ), size = 8, colour = "black" ) + labs( x = "Specimen", y = expression( "Wavenumber [cm"^"-1"*"]" ), fill = "PP Content" ) + theme( title = element_text( size = 20, colour = "white", hjust = 0.5 ), axis.title = element_text( size = 25, colour = "white" ), axis.text = element_text( size = 20, colour = "white" ) ) + scale_fill_gradient( low = "white", high = bs_primary )
  
})

output$PP_table_ro <- renderReactable({
  
  req( !is.null( ftir_resins_r$ftir_resins_r ) )
  
  reactable( data = ftir_resins_r$ftir_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )
  
})

PP_selected_resins <- reactive( ftir_resins_r$ftir_resins_r[getReactableState( "PP_table_ro", "selected" ), "Identifier"] )

pp_compare_results <- reactive( {
  
  PP_final_predictions <- c()
  
  for (i in PP_selected_resins()) {
    
    PP_final_predictions <- c( PP_final_predictions, pp_analysis( ftir_data$PP_percentages, i )[[1]] )
    
  }
  
  PP_final_predictions
  
})

output$PP_compare_po <- renderPlotly({
  
  req( ftir_data$read_data )
  
  number_of_gauges <- length( pp_compare_results() )
  number_of_rows <- number_of_gauges %/% 2 + number_of_gauges %% 2

  req( number_of_gauges >= 1 )
  
  list_of_figures <- list()
  rects <- list()
  
  for (i in 1:number_of_gauges) {
    
    list_of_figures[[i]] <- plot_ly( domain = list( x = c( 0.55 * (i + 1) %% 2, 0.45 + 0.55 * (i + 1) %% 2 ), y = c( 1 - (1 / number_of_rows) * (i + 1) %/% 2, 1 - (1 / number_of_rows) * (i + 1) %/% 2 + 0.9 / number_of_rows ) ), value = pp_compare_results()[[i]], number = list( font = list( color = text_colour ), suffix = "%" ), title = list( text = ftir_resins_r$ftir_resins_r$Name[match( PP_selected_resins()[[i]], ftir_resins_r$ftir_resins_r$Identifier )], font = list( color = text_colour ) ),
      type = "indicator", mode = "gauge+number",
      gauge = list(
        axis = list( range = c( 0, 15 ), tickfont = list( color = text_colour, size = 15 ) ),
        steps = list( list( range = c( 0, 5 ), color = "green" ), list( range = c( 5, 10 ), color = "orange" ), list( range = c( 10, 15 ), color = "red" ) ),
        bar = list( color = "purple" )
      )
    )
    
    rects[[i]] <- list( type = "rect", line = list( color = bs_primary ), x0 = -0.0325 + 0.5325 * (i + 1) %% 2, x1 = 0.5 + 0.5325 * (i + 1) %% 2, y0 = 1 - (1 / number_of_rows) * (i + 1) %/% 2, y1 = 1 - (1 / number_of_rows) * (i + 1) %/% 2 + 1 / number_of_rows )
    
  }

  fig <- subplot( list_of_figures, nrows = number_of_rows ) %>% layout( height = 400 * number_of_rows, paper_bgcolor = bs_light, shapes = rects, margin = list( l = 40, r = 40, t = 0, b = 0 ) )

  fig
  
}) %>% bindEvent( input$PP_compare_ab )

output$PP_export_db <- downloadHandler(
  
  filename = function() { "PP_Predictions.xlsx" },
  
  content = function( file ) {
    
    unique_identifiers <- ftir_resins_r$ftir_resins_r[getReactableState( "PP_table_ro", "selected" ), "Identifier"]
    
    resin_names <- ftir_resins_r$ftir_resins_r[getReactableState( "PP_table_ro", "selected" ), "Name"]
    
    df <- data.frame( Identifier = unique_identifiers, Name = resin_names, PP = pp_compare_results() )
    
    names( df )[names( df ) == "PP"] <- "PP Percentage [%]"
    
    wb <- createWorkbook()
    
    addWorksheet( wb, sheetName = "PP Predictions Summary" )
    
    setColWidths( wb, 1, cols = 1:3, widths = c( 15, 40, 15 ) )
    
    writeData( wb, 1, "File exported from the PCR Predictor Tool", startRow = 1, startCol = 1 )
    
    mergeCells( wb, 1, rows = 1, cols = 1:3 )
    
    addStyle( wb, 1, style = createStyle( fontSize = 16, textDecoration = "bold", halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 1, cols = 1:3, gridExpand = TRUE )
    
    mergeCells( wb, 1, rows = 2, cols = 1:3 )
    
    writeData( wb, 1, "PP Predictions Summary", startRow = 3, startCol = 1 )
    
    mergeCells( wb, 1, rows = 3, cols = 1:3 )
    
    addStyle( wb, 1, style = createStyle( fontSize = 12, halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 3, cols = 1:3, gridExpand = TRUE )
    
    writeData( wb, 1, df, startRow = 4, startCol = 1 )
    
    addStyle( wb, 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 4, cols = 1:3, gridExpand = TRUE )
    
    addStyle( wb, 1, style = createStyle( numFmt = "0.00" ), rows = 5:(5 + length( pp_compare_results() )), cols = 3, gridExpand = TRUE )
    
    for (i in 1:length( pp_compare_results() )) {
      
      pp_sample_results <- pp_analysis( ftir_data$PP_percentages, PP_selected_resins()[[i]] )
      
      addWorksheet( wb, sheetName = substr( ftir_resins_r$ftir_resins_r$Name[match( PP_selected_resins()[[i]], ftir_resins_r$ftir_resins_r$Identifier )], 1, 31 ) )
      
      setColWidths( wb, i + 1, cols = 1:7, widths = c( 25, 13, 13, 13, 13, 13, 13 ) )
      
      writeData( wb, i + 1, paste0( "PP Predictions for ", ftir_resins_r$ftir_resins_r$Name[match( PP_selected_resins()[[i]], ftir_resins_r$ftir_resins_r$Identifier )] ), startRow = 1, startCol = 1 )
      
      mergeCells( wb, i + 1, rows = 1, cols = 1:7 )
      
      addStyle( wb, i + 1, style = createStyle( fontSize = 16, textDecoration = "bold", halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 1, cols = 1:7, gridExpand = TRUE )
      
      writeData( wb, i + 1, "Overall PP Prediction", startRow = 3, startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 3, cols = 1, gridExpand = TRUE )

      writeData( wb, i + 1, pp_sample_results[[1]], startRow = 3, startCol = 2 )
      
      addStyle( wb, i + 1, style = createStyle( numFmt = "0.00" ), rows = 3, cols = 2, gridExpand = TRUE )
      
      writeData( wb, i + 1, "Distribution of PP Predictions", startRow = 5, startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fontSize = 12, halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 5, cols = 1, gridExpand = TRUE )
      
      writeData( wb, i + 1, pp_sample_results[[5]], startRow = 6, startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 6, cols = 1:5, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( numFmt = "0.00" ), rows = 7, cols = 1:5, gridExpand = TRUE )

      writeData( wb, i + 1, "PP Prediction by Specimen", startRow = 9, startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fontSize = 12, halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 9, cols = 1, gridExpand = TRUE )
      
      df <- data.frame( Specimen = pp_sample_results[[2]]$Specimen, PP = pp_sample_results[[2]]$specimen_pp_values )
      
      names( df )[names( df ) == "PP"] <- "PP Percentage [%]"

      writeData( wb, i + 1, df, startRow = 10, startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 10, cols = 1:2, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( numFmt = "0.00" ), rows = 11:(10 + nrow( pp_sample_results[[2]] )), cols = 2, gridExpand = TRUE )

      writeData( wb, i + 1, "PP Prediction by Wavenumber", startRow = 12 + nrow( pp_sample_results[[2]] ), startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fontSize = 12, halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 12 + nrow( pp_sample_results[[2]] ), cols = 1, gridExpand = TRUE )
      
      df <- data.frame( Wavenumber = pp_sample_results[[3]]$Wavenumber, PP = pp_sample_results[[3]]$wavenumber_pp_values )
      
      names( df )[names( df ) == "PP"] <- "PP Percentage [%]"

      writeData( wb, i + 1, df, startRow = 13 + nrow( pp_sample_results[[2]] ), startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 13 + nrow( pp_sample_results[[2]] ), cols = 1:2, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( halign = "right" ), rows = (14 + nrow( pp_sample_results[[2]] )):(19 + nrow( pp_sample_results[[2]] )), cols = 1, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( numFmt = "0.00" ), rows = (14 + nrow( pp_sample_results[[2]] )):(19 + nrow( pp_sample_results[[2]] )), cols = 2, gridExpand = TRUE )
      
      writeData( wb, i + 1, "Table of PP Predictions", startRow = 21 + nrow( pp_sample_results[[2]] ), startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fontSize = 12, halign = "center", fgFill = bs_bg, fontColour = text_colour, border = "TopBottomLeftRight", borderColour = bs_primary, borderStyle = "medium" ), rows = 21 + nrow( pp_sample_results[[2]] ), cols = 1, gridExpand = TRUE )
      
      df <- pp_sample_results[[7]][, c( 7, 1:6 )]
      
      names( df )[names( df ) == "specimen"] <- "Specimen"
      
      writeData( wb, i + 1, df, startRow = 22 + nrow( pp_sample_results[[2]] ), startCol = 1 )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = 22 + nrow( pp_sample_results[[2]] ), cols = 1:7, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( fgFill = bs_primary, halign = "center", fontColour = "#ffffff", border = "TopBottomLeftRight", borderColour = bs_bg ), rows = (23 + nrow( pp_sample_results[[2]] )):(22 + 2 * nrow( pp_sample_results[[2]] )), cols = 1, gridExpand = TRUE )
      
      addStyle( wb, i + 1, style = createStyle( numFmt = "0.00" ), rows = (23 + nrow( pp_sample_results[[2]] )):(22 + 2 * nrow( pp_sample_results[[2]] )), cols = 2:7, gridExpand = TRUE )
      
    }
    
    saveWorkbook( wb, file )
    
  }
  
)