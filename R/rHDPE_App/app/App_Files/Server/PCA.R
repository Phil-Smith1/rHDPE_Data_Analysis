# PCA tab server code.

output$PCA_table_ro <- renderReactable({

  req( nrow( resin_data_r() ) > 0 )

  reactable( data = resin_data_r() %>% select( "Identifier", "Label", "Name" ), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list( cursor = "pointer" ), onClick = "select", bordered = TRUE )

})

outputOptions( output, "PCA_table_ro", suspendWhenHidden = FALSE )

read_PCA_select_datasets_cb <- eventReactive( input$PCA_compute_ab, {
  
  datasets_to_read <- as.integer( input$PCA_select_datasets_cb )

  if (2 %in% datasets_to_read & length( input$PCA_dsc_features_pi ) == 0) {
    
    datasets_to_read <- datasets_to_read[datasets_to_read != 2]
    
  }
  
  datasets_to_read
  
})

PCA_selected_resins <- reactive( resin_data_r()[getReactableState( "PCA_table_ro", "selected" ), "Identifier"] )

observe({

  selected_resins <- isolate( PCA_selected_resins() )

  if (!input$PCA_dv1_cb) {

    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )

  }

  if (!input$PCA_dv2_cb) {

    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )

  }

  if (input$PCA_dv1_cb) {

    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )

  }

  if (input$PCA_dv2_cb) {

    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )

  }

  if (input$PCA_no_virgin_resins_cb) {

    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )

  }

  if (input$PCA_no_pp_resins_cb) {

    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )

  }

  req( nrow( resin_data_r() ) > 0 )

  updateReactable( "PCA_table_ro", resin_data_r() %>% select( "Identifier", "Label", "Name" ), selected = match( selected_resins, resin_data_r()$Identifier ), page = isolate( getReactableState( "PCA_table_ro", "page" ) ) )

})

obtain_PCA_data_to_plot <- function( global_input_parameters, datasets_to_plot, sample_mask ) {
  
  global_input_parameters$datasets_to_read <- datasets_to_plot
  global_input_parameters$sample_mask <- sample_mask
  
  num_features <- 0
  
  if (1 %in% datasets_to_plot) {
    
    if (ftir_data$compute_features) {
      
      initiate_data_reading( "ftir", "FTIR" )
      
      d1 <- FTIR_Analysis$Utilities$compute_derivatives( ftir_data$data[[2]] )
      d2 <- FTIR_Analysis$Utilities$compute_derivatives( d1 )
      d3 <- FTIR_Analysis$Utilities$compute_derivatives( d2 )
      
      FTIR_Analysis$Utilities$extract_FTIR_features( ftir_input_parameters$output_directory, ftir_data$data[[1]], ftir_data$data[[2]], d1, d2, d3, -0.00008, 0.0002, 6, 3400, current_dataset() )
      
      ftir_data$compute_features <- FALSE
      
    }
    
    ftir_input_parameters$sample_mask <- sample_mask
    
    FTIR_Analysis$Utilities$read_and_analyse_FTIR_features( ftir_input_parameters, ftir_data$data[[1]], current_dataset() )
    
    num_features <- num_features + 2
    
  }
  
  if (2 %in% datasets_to_plot) {
    
    if (dsc_data$compute_features) {
      
      initiate_data_reading( "dsc", "DSC" )
      
      d1 <- DSC_Analysis$Utilities$compute_derivatives( dsc_data$data[[2]], 150L )
      d2 <- DSC_Analysis$Utilities$compute_derivatives( d1, 50L )
      
      DSC_Analysis$Utilities$extract_DSC_features( dsc_input_parameters$output_directory, dsc_data$data[[1]], dsc_data$data[[2]], d1, d2, current_dataset() )
      
      dsc_data$compute_features <- FALSE
      
    }
    
    dsc_input_parameters$sample_mask <- sample_mask
    dsc_input_parameters$feature_selection <- as.integer( input$PCA_dsc_features_pi )
    
    DSC_Analysis$Utilities$read_and_analyse_features( dsc_input_parameters, dsc_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_dsc_features_pi )
    
  }
  
  if (3 %in% datasets_to_plot) {
    
    if (tga_data$compute_features) {
      
      initiate_data_reading( "tga", "TGA" )
      
      d1 <- TGA_Analysis$Utilities$compute_derivatives( tga_data$data[[2]], 50L )
      d2 <- TGA_Analysis$Utilities$compute_derivatives( d1 )
      
      TGA_Analysis$Utilities$extract_TGA_features( tga_input_parameters$output_directory, tga_data$data[[1]], tga_data$data[[2]], d1, d2, current_dataset() )
      
      tga_data$compute_features <- FALSE
      
    }
    
    tga_input_parameters$sample_mask <- sample_mask
    tga_input_parameters$feature_selection <- as.integer( input$PCA_tga_features_pi )
    
    TGA_Analysis$Utilities$read_and_analyse_TGA_features( tga_input_parameters, tga_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tga_features_pi )
    
  }
  
  if (4 %in% datasets_to_plot) {
    
    if (rheo_data$compute_features) {
      
      initiate_data_reading( "rheo", "Rheology" )
      
      d1 <- Rheology_Analysis$Utilities$compute_derivatives( rheo_data$data[[2]] )
      d2 <- Rheology_Analysis$Utilities$compute_derivatives( d1 )
      
      Rheology_Analysis$Utilities$extract_rheology_features( rheo_input_parameters$output_directory, rheo_data$data[[1]], rheo_data$data[[2]], d1, d2, current_dataset() )
      
      rheo_data$compute_features <- FALSE
      
    }
    
    rheo_input_parameters$sample_mask <- sample_mask
    rheo_input_parameters$feature_selection <- as.integer( input$PCA_rheo_features_pi )
    
    Rheology_Analysis$Utilities$read_and_analyse_features( rheo_input_parameters, rheo_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_rheo_features_pi )
    
  }
  
  if (5 %in% datasets_to_plot) {
    
    if (tt_data$compute_features) {
      
      initiate_data_reading( "tt", "TT" )
      
      d1 <- TT_Analysis$Utilities$compute_derivatives( tt_data$data[[2]], 6L )
      d2 <- TT_Analysis$Utilities$compute_derivatives( d1 )
      
      TT_Analysis$Utilities$extract_TT_features( tt_input_parameters$output_directory, tt_data$data[[1]], tt_data$data[[2]], d1, d2, current_dataset() )
      
      tt_data$compute_features <- FALSE
      
    }
    
    tt_input_parameters$sample_mask <- sample_mask
    tt_input_parameters$feature_selection <- as.integer( input$PCA_tt_features_pi )
    
    TT_Analysis$Utilities$read_and_analyse_features( tt_input_parameters, tt_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tt_features_pi )
    
  }
  
  if (6 %in% datasets_to_plot) {
    
    if (colour_data$compute_features) {
      
      initiate_data_reading( "colour", "Colour" )
      
      Colour_Analysis$Utilities$extract_colour_features( colour_input_parameters$output_directory, colour_data$data[[1]], colour_data$data[[2]], current_dataset() )
      
      colour_data$compute_features <- FALSE
      
    }
    
    colour_input_parameters$sample_mask <- sample_mask
    colour_input_parameters$feature_selection <- as.integer( input$PCA_colour_features_pi )
    
    Colour_Analysis$Utilities$read_and_analyse_features( colour_input_parameters, colour_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_colour_features_pi )
    
  }
  
  if (7 %in% datasets_to_plot) {
    
    if (shm_data$compute_features) {
      
      initiate_data_reading( "shm", "SHM" )
      
      d1 <- SHM_Analysis$Utilities$compute_derivatives( shm_data$data[[2]], 200L )
      
      SHM_Analysis$Utilities$extract_SHM_features( shm_input_parameters$output_directory, shm_data$data[[1]], shm_data$data[[2]], d1, current_dataset() )
      
      shm_data$compute_features <- FALSE
      
    }
    
    shm_input_parameters$sample_mask <- sample_mask
    
    SHM_Analysis$Utilities$read_and_analyse_SHM_features( shm_input_parameters, shm_data$data[[1]], current_dataset() )
    
    num_features <- num_features + 1
    
  }
  
  if (8 %in% datasets_to_plot) {
    
    if (tls_data$compute_features) {
      
      initiate_data_reading( "tls", "TLS" )
      
      d1 <- TLS_Analysis$Utilities$compute_derivatives( tls_data$data[[2]] )
      d2 <- TLS_Analysis$Utilities$compute_derivatives( d1 )
      
      TLS_Analysis$Utilities$extract_tls_features( tls_input_parameters$output_directory, tls_data$data[[1]], tls_data$data[[2]], d1, d2, current_dataset() )
      
      tls_data$compute_features <- FALSE
      
    }
    
    tls_input_parameters$sample_mask <- sample_mask
    tls_input_parameters$feature_selection <- as.integer( input$PCA_tls_features_pi )
    
    TLS_Analysis$Utilities$read_and_analyse_features( tls_input_parameters, tls_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tls_features_pi )
    
  }
  
  if (9 %in% datasets_to_plot) {
    
    if (escr_data$compute_features) {
      
      initiate_data_reading( "escr", "ESCR" )
      
      ESCR_Analysis$Utilities$extract_ESCR_features( escr_input_parameters$output_directory, escr_data$data[[1]], escr_data$data[[2]], current_dataset() )
      
      escr_data$compute_features <- FALSE
      
    }
    
    escr_input_parameters$sample_mask <- sample_mask
    escr_input_parameters$feature_selection <- as.integer( input$PCA_escr_features_pi )
    
    ESCR_Analysis$Utilities$read_and_analyse_ESCR_features( escr_input_parameters, escr_data$data[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_escr_features_pi )
    
  }
  
  validate( need( num_features > 1, "Please select more features to perform the PCA on." ) )
  
  result <- Global_Analysis$Preprocessing$read_files_and_preprocess( global_input_parameters, datasets_to_read = datasets_to_plot, name_appendage = current_dataset() )
  
  data_transfer <- Global_Analysis$Utilities$pca( global_input_parameters, result[[1]], result[[2]], current_dataset() )
  
  data_to_plot <- data.frame( data_transfer[[2]], data_transfer[[3]], data_transfer[[4]], data_transfer[[5]] )
  
  data_to_plot_2 <- data.frame( data_transfer[[6]], data_transfer[[7]], data_transfer[[8]] )
  
  data_to_plot$Resin <- data_transfer[[1]]
  
  names( data_to_plot )[1] <- "X"
  names( data_to_plot )[2] <- "Y"
  names( data_to_plot )[3] <- "EX"
  names( data_to_plot )[4] <- "EY"
  names( data_to_plot_2 )[1] <- "X"
  names( data_to_plot_2 )[2] <- "Y"
  names( data_to_plot_2 )[3] <- "Labels"
  
  list( data_to_plot, data_to_plot_2 )
  
}

obtain_PCA_data_to_plot_main <- eventReactive( input$PCA_compute_ab, {
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 0, "Please select the datasets to perform the PCA on." ) )
  validate( need( !(length( read_PCA_select_datasets_cb() ) == 1 && read_PCA_select_datasets_cb() == 7), "As SHM contains just one feature, it must be selected with at least one other dataset." ) )
  validate( need( length( PCA_selected_resins() ) > 0, "Please select the resins to perform the PCA on." ) )
  
  obtain_PCA_data_to_plot( global_input_parameters, read_PCA_select_datasets_cb(), PCA_selected_resins() )
  
})

obtain_PCA_data_to_plot_subplots <- eventReactive( input$PCA_compute_ab, {
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  req( length( PCA_selected_resins() ) > 0 )
  
  data_to_plot_list <- list()
  
  for (d in read_PCA_select_datasets_cb()) {
    
    if (d == 7) next
    
    data_to_plot_list <- append( data_to_plot_list, list( obtain_PCA_data_to_plot( global_input_parameters, d, obtain_PCA_data_to_plot_main()[[1]][[5]] ) ) )
    
  }
  
  data_to_plot_list
  
})

output$PCA_po <- renderPlot({

  data_to_plot <- obtain_PCA_data_to_plot_main()

  resin_colours <- c()
  resin_names <- c()
  labels <- c()

  for (s in seq_along( data_to_plot[[1]][[5]] )) {

    resin_colours <- c( resin_colours, rgb( list_of_colours[data_to_plot[[1]][[5]][s] + 1,] ) )
    resin_names <- c( resin_names, data_to_plot[[1]][[5]][s] )
    labels <- c( labels, resin_data_r()$Label[match( data_to_plot[[1]][[5]][s], resin_data_r()$Identifier )] )

  }

  resin_names_and_colours <- setNames( resin_colours, resin_names )

  title_str <- paste0( "PCA of ", datasets[read_PCA_select_datasets_cb()[[1]]] )

  if (length( read_PCA_select_datasets_cb() ) > 1) {

    for (i in 2:length( read_PCA_select_datasets_cb() )) {

      if (i < length( read_PCA_select_datasets_cb() )) {

        title_str <- paste0( title_str, ", ", datasets[read_PCA_select_datasets_cb()[[i]]] )

      } else {

        title_str <- paste0( title_str, " and ", datasets[read_PCA_select_datasets_cb()[[i]]] )

      }

    }

  }

  g <- ggplot( data_to_plot[[1]], aes( x = X, y = Y, color = fct_inorder( as.factor( Resin ) ) ) )

  g <- g + labs( title = title_str, x = "PC 1", y = "PC 2" )

  if (input$PCA_add_labels_cb) {

    g <- g + geom_point( size = 5, show.legend = FALSE )

    g <- g + geom_label_repel( aes( label = labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50' )

  }

  else {

    g <- g + geom_point( size = 5 )

  }

  g <- g + scale_colour_manual( name = "Resin", values = resin_names_and_colours, label = labels )

  g <- g + theme( title = element_text( size = 24, hjust = 0.5 ), aspect.ratio = 1, axis.title = element_text( size = 24 ), legend.title = element_text( size = 24 ), legend.text = element_text( size = 24 ), axis.text = element_text( size = 24 ) )

  g <- g + geom_errorbar( aes( ymin = Y - EY, ymax = Y + EY, color = fct_inorder( as.factor( Resin ) ) ), size = 1.5, show.legend = FALSE ) + geom_errorbarh( aes( xmin = X - EX, xmax = X + EX ), size = 1.5, show.legend = FALSE )

  if (input$PCA_loading_plot_cb) {

    g <- g + geom_point( data = data_to_plot[[2]], aes( x = X, y = Y ), size = 5, inherit.aes = FALSE )

    g <- g + geom_segment( data = data_to_plot[[2]], aes( xend = X, yend = Y ), x = 0, y = 0, inherit.aes = FALSE )

    g <- g + geom_label_repel( data = data_to_plot[[2]], aes( x = X, y = Y, label = Labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50', inherit.aes = FALSE )

  }

  g

})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_subplots_po <- renderPlot({

  data_to_plot <- obtain_PCA_data_to_plot_subplots()

  plots <- list()

  for (i in 1:length( data_to_plot )) {

    resin_colours <- c()
    resin_names <- c()
    labels <- c()

    for (s in seq_along( data_to_plot[[i]][[1]][[5]] )) {

      resin_colours <- c( resin_colours, rgb( list_of_colours[data_to_plot[[i]][[1]][[5]][s] + 1,] ) )
      resin_names <- c( resin_names, data_to_plot[[i]][[1]][[5]][s] )
      labels <- c( labels, resin_data_r()$Label[match( data_to_plot[[i]][[1]][[5]][s], resin_data_r()$Identifier )] )

    }

    resin_names_and_colours <- setNames( resin_colours, resin_names )

    g <- ggplot( data_to_plot[[i]][[1]], aes( x = X, y = Y, color = fct_inorder( as.factor( Resin ) ) ) )

    datasets_copy <- read_PCA_select_datasets_cb()[read_PCA_select_datasets_cb() != 7]

    g <- g + labs( title = paste0( "PCA of ", datasets[[datasets_copy[[i]]]] ), x = "PC 1", y = "PC 2" )

    if (input$PCA_add_labels_cb) {

      g <- g + geom_point( size = 5, show.legend = FALSE )

      g <- g + geom_label_repel( aes( label = !!labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50' )

    }

    else {

      g <- g + geom_point( size = 5 )

    }

    g <- g + scale_colour_manual( name = "Resin", values = resin_names_and_colours, label = labels )

    g <- g + theme( title = element_text( size = 24, hjust = 0.5 ), aspect.ratio = 1, axis.title = element_text( size = 24 ), legend.title = element_text( size = 24 ), legend.text = element_text( size = 24 ), axis.text = element_text( size = 24 ) )

    g <- g + geom_errorbar( aes( ymin = Y - EY, ymax = Y + EY, color = fct_inorder( as.factor( Resin ) ) ), size = 1.5, show.legend = FALSE ) + geom_errorbarh( aes( xmin = X - EX, xmax = X + EX ), size = 1.5, show.legend = FALSE )

    if (input$PCA_loading_plot_cb) {

      g <- g + geom_point( data = data_to_plot[[i]][[2]], aes( x = X, y = Y ), size = 5, inherit.aes = FALSE )

      g <- g + geom_segment( data = data_to_plot[[i]][[2]], aes( xend = X, yend = Y ), x = 0, y = 0, inherit.aes = FALSE )

      g <- g + geom_label_repel( data = data_to_plot[[i]][[2]], aes( x = X, y = Y, label = Labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50', inherit.aes = FALSE )

    }

    plots <- append( plots, list( g ) )

  }

  plot_grid( plotlist = plots )

})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

