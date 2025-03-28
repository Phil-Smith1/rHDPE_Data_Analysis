# DSC Visualisation.

# Table output.

output$dsc_table_ro <- renderReactable({
  
  req( !is.null( dsc_resins_r$dsc_resins_r ) )
  
  reactable( data = dsc_resins_r$dsc_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE )
  
})

dsc_selected_resins <- reactive( dsc_resins_r$dsc_resins_r[getReactableState( "dsc_table_ro", "selected" ), "Identifier"] )
read_dsc_mean_specimen_cb <- eventReactive( input$dsc_visualise_ab, input$dsc_mean_specimen_cb )
dsc_selected_specimens <- eventReactive( input$dsc_visualise_ab, input$dsc_select_specimens_pi )
read_dsc_melt_cryst_cb <- eventReactive( input$dsc_visualise_ab, input$dsc_melt_cryst_cb )
dsc_range <- eventReactive( input$dsc_visualise_ab, input$dsc_temp_sli )

observe({
  
  selected_resins <- isolate( dsc_selected_resins() )
  
  if (!input$dsc_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$dsc_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$dsc_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$dsc_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$dsc_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$dsc_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "dsc_table_ro", dsc_resins_r$dsc_resins_r, selected = match( selected_resins, dsc_resins_r$dsc_resins_r$Identifier ), page = isolate( getReactableState( "dsc_table_ro", "page" ) ) )
  
})

observe({
  
  if (length( dsc_resins_r$dsc_resins_r[getReactableState( "dsc_table_ro", "selected" ), "Identifier"] ) > 0) {
    
    isolate( initiate_data_reading( "dsc", "DSC" ) )
    
    req( dsc_data$read_data )
    
    specimens <- dsc_data$file_data_minus_hidden %>% filter( Resin %in% dsc_resins_r$dsc_resins_r[getReactableState( "dsc_table_ro", "selected" ), "Identifier"] ) %>% pull( Label )
    
    updatePickerInput( inputId = "dsc_select_specimens_pi", choices = specimens )
    
  }
  
})

obtain_data_to_plot_dsc <- eventReactive( input$dsc_visualise_ab, {
  
  dsc_input_parameters$shiny_mean = FALSE
  dsc_input_parameters$shiny_specimen = FALSE
  dsc_input_parameters$shiny_melt = FALSE
  dsc_input_parameters$shiny_cryst = FALSE
  
  if ("Mean" %in% read_dsc_mean_specimen_cb()) {
    
    dsc_input_parameters$shiny_mean = TRUE
    
  }
  
  if ("Specimen" %in% read_dsc_mean_specimen_cb()) {
    
    dsc_input_parameters$shiny_specimen = TRUE
    
  }
  
  if ("Melt" %in% read_dsc_melt_cryst_cb()) {
    
    dsc_input_parameters$shiny_melt = TRUE
    
  }
  
  if ("Cryst" %in% read_dsc_melt_cryst_cb()) {
    
    dsc_input_parameters$shiny_cryst = TRUE
    
  }
  
  dsc_input_parameters$shiny_samples_to_plot <- dsc_selected_resins()
  dsc_input_parameters$shiny_specimens_to_plot <- dsc_selected_specimens()
  dsc_input_parameters$shiny_split <- dsc_range()
  
  data_to_plot <- DSC_Analysis$DSC_plotting$plot_data( dsc_input_parameters, dsc_data$data_minus_hidden[[1]], dsc_data$data_minus_hidden[[2]], c(), c(), name_appendage = current_dataset() )
  
  max_length <- max( lengths( data_to_plot ) )
  
  for (i in 1:length( data_to_plot ) ) {
    
    length( data_to_plot[[i]] ) <- max_length
    
  }
  
  data.frame( data_to_plot )
  
})

output$dsc_visualisation_po <- renderPlot({
  
  validate( need( "Specimen" %in% read_dsc_mean_specimen_cb() | "Mean" %in% read_dsc_mean_specimen_cb() , "Please select mean or specimen (or both)" ) )
  validate( need( length( dsc_selected_resins() ) > 0, "Please select resins" ) )
  validate( need( "Melt" %in% read_dsc_melt_cryst_cb() | "Cryst" %in% read_dsc_melt_cryst_cb() , "Please select melt or cryst (or both)" ) )
  validate( need( dsc_range()[[1]] != dsc_range()[[2]], "Please widen the temperature range" ) )
  
  if ("Specimen" %in% read_dsc_mean_specimen_cb()) {
    
    validate( need( length( dsc_selected_specimens() ) > 0, "Please select specimens" ) )
    
  }
  
  multiplier <- 1
  
  if ("Melt" %in% read_dsc_melt_cryst_cb() & "Cryst" %in% read_dsc_melt_cryst_cb()) multiplier <- 2
  
  mult_dsc_selected_resins <- rep( dsc_selected_resins(), each = multiplier )
  
  resin_colours <- c()
  resin_names <- c()
  
  for (s in seq_along( dsc_selected_resins() )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[dsc_selected_resins()[s] + 1,] ) )
    resin_colours <- c( resin_colours, rgb( list_of_colours[dsc_selected_resins()[s] + 1,] ) )
    resin_names <- c( resin_names, paste( resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )], "Cryst" ) )
    resin_names <- c( resin_names, paste( resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )], "Melt" ) )
    
  }
  
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_colours <- c( resin_colours, rainbow( 31 ) )
  resin_names <- c( resin_names, paste( as.character( 1:31 ), "Cryst" ) )
  resin_names <- c( resin_names, paste( as.character( 1:31 ), "Melt" ) )
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  labels <- c()
  break_order <- c()
  
  g <- ggplot() + coord_cartesian( xlim = dsc_range() ) + labs( title = "DSC Curve", x = "Temperature [°C]", y = expression( paste( "Heat Flow [Wg"^-1, "]" ) ) )
  
  if (! "Specimen" %in% read_dsc_mean_specimen_cb()) {
    
    for (s in seq_along( mult_dsc_selected_resins )) {
      
      if ((multiplier == 2 & s %% 2 == 1) | (multiplier == 1 & "Cryst" %in% read_dsc_melt_cryst_cb())) {
        
        g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[s * 2]]], color = paste( resin_data_r()$Label[match( mult_dsc_selected_resins[!!s], resin_data_r()$Identifier )], "Cryst" ) ) )
        
        labels <- c( labels, resin_data_r()$Label[match( mult_dsc_selected_resins[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, paste( resin_data_r()$Label[match( mult_dsc_selected_resins[s], resin_data_r()$Identifier )], "Cryst" ) )
        
      } else {
        
        g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[s * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[s * 2]]], color = paste( resin_data_r()$Label[match( mult_dsc_selected_resins[!!s], resin_data_r()$Identifier )], "Melt" ) ) )
        
        labels <- c( labels, resin_data_r()$Label[match( mult_dsc_selected_resins[s], resin_data_r()$Identifier )] )
        
        if (multiplier == 1) {
          
          break_order <- c( break_order, paste( resin_data_r()$Label[match( mult_dsc_selected_resins[s], resin_data_r()$Identifier )], "Melt" ) )
          
        } else {
          
          break_order <- c( break_order, paste( resin_data_r()$Label[match( mult_dsc_selected_resins[s], resin_data_r()$Identifier )], "Cryst" ) )
          
        }
        
      }
      
    }
    
  } else {
    
    marker <- 1
    
    for (s in seq_along( dsc_selected_resins() )) {
      
      resin_specimens <- dsc_data$file_data_minus_hidden %>% filter( Resin == dsc_selected_resins()[s], Label %in% dsc_selected_specimens() )
      
      l <- nrow( resin_specimens )
      
      if (l > 0) {
        
        mult_marker <- rep( marker:(marker + l - 1), each = multiplier )
        
        for (i in seq_along( mult_marker )) {
          
          j <- i + marker - 1
          
          if ((multiplier == 2 & (j - marker) %% 2 == 0) | (multiplier == 1 & "Cryst" %in% read_dsc_melt_cryst_cb())) {
            
            g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[j * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[j * 2]]], color = paste( as.character( (!!mult_marker[i] * 7) %% 31 + 1 ), "Cryst" ) ) )
            
            labels <- c( labels, resin_specimens$Label[mult_marker[i] - marker + 1] )
            break_order <- c( break_order, paste( as.character( (mult_marker[i] * 7) %% 31 + 1 ), "Cryst" ) )
            
          } else {
            
            g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[j * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[j * 2]]], color = paste( as.character( (!!mult_marker[i] * 7) %% 31 + 1 ), "Melt" ) ) )
            
            labels <- c( labels, resin_specimens$Label[mult_marker[i] - marker + 1] )
            
            if (multiplier == 1) {
              
              break_order <- c( break_order, paste( as.character( (mult_marker[i] * 7) %% 31 + 1 ), "Melt" ) )
              
            } else {
              
              break_order <- c( break_order, paste( as.character( (mult_marker[i] * 7) %% 31 + 1 ), "Cryst" ) )
              
            }
            
          }
          
        }
        
      }
      
      marker <- marker + l * multiplier
      
      if ("Mean" %in% read_dsc_mean_specimen_cb()) {
        
        g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[marker * 2]]], color = paste( resin_data_r()$Label[match( dsc_selected_resins()[!!s], resin_data_r()$Identifier )], "Cryst" ) ) )
        
        labels <- c( labels, resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )] )
        break_order <- c( break_order, paste( resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )], "Cryst" ) )
        
        marker <- marker + 1
        
        if (multiplier == 2) {
          
          g <- g + geom_line( data = obtain_data_to_plot_dsc(), aes( x = .data[[colnames( obtain_data_to_plot_dsc() )[marker * 2 - 1]]], y = .data[[colnames( obtain_data_to_plot_dsc() )[marker * 2]]], color = paste( resin_data_r()$Label[match( dsc_selected_resins()[!!s], resin_data_r()$Identifier )], "Melt" ) ) )
          
          labels <- c( labels, resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )] )
          break_order <- c( break_order, paste( resin_data_r()$Label[match( dsc_selected_resins()[s], resin_data_r()$Identifier )], "Cryst" ) )
          
          marker <- marker + 1
          
        }
        
      }
      
    }
    
  }
  
  g <- g + scale_color_manual( name = "Resins", values = resin_names_and_colours, breaks = break_order, labels = labels )
  
  num_cols_in_legend <- ceiling( length( labels ) / multiplier / 10 )
  
  g <- g + guides( color = guide_legend( ncol = num_cols_in_legend ) )
  
  g
  
}, res = 96 ) %>% bindEvent( input$dsc_visualise_ab )