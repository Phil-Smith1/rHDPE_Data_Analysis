# PCA tab server code.

output$PCA_table_ro <- renderReactable({

  req( nrow( resin_data_r() ) > 0 )

  reactable( data = resin_data_r(), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
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

observe( updatePickerInput( inputId = "PCA_individual_experiments_pi", choices = setNames( as.integer( input$PCA_select_datasets_cb )[as.integer( input$PCA_select_datasets_cb ) != 7], datasets[as.integer( input$PCA_select_datasets_cb )[as.integer( input$PCA_select_datasets_cb ) != 7]] ) ) )

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

PCA_read_files <- function( global_input_parameters, datasets_to_plot, sample_mask ) {
  
  num_features <- 0
  
  if (1 %in% datasets_to_plot) {
    
    if (ftir_data$compute_features) { initiate_data_reading( "ftir", "FTIR" ); compute_ftir_features( ftir_input_parameters, current_dataset, ftir_data ) }
    
    ftir_input_parameters$sample_mask <- sample_mask
    
    FTIR_Analysis$Utilities$read_and_analyse_FTIR_features( ftir_input_parameters, ftir_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + 2
    
  }
  
  if (2 %in% datasets_to_plot) {
    
    if (dsc_data$compute_features) { initiate_data_reading( "dsc", "DSC" ); compute_dsc_features( dsc_input_parameters, current_dataset, dsc_data ) }
    
    dsc_input_parameters$sample_mask <- sample_mask
    dsc_input_parameters$feature_selection <- as.integer( input$PCA_dsc_features_pi )
    
    DSC_Analysis$Utilities$read_and_analyse_features( dsc_input_parameters, dsc_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_dsc_features_pi )
    
  }
  
  if (3 %in% datasets_to_plot) {
    
    if (tga_data$compute_features) { initiate_data_reading( "tga", "TGA" ); compute_tga_features( tga_input_parameters, current_dataset, tga_data ) }
    
    tga_input_parameters$sample_mask <- sample_mask
    tga_input_parameters$feature_selection <- as.integer( input$PCA_tga_features_pi )
    
    TGA_Analysis$Utilities$read_and_analyse_TGA_features( tga_input_parameters, tga_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tga_features_pi )
    
  }
  
  if (4 %in% datasets_to_plot) {
    
    if (rheo_data$compute_features) { initiate_data_reading( "rheo", "Rheology" ); compute_rheo_features( rheo_input_parameters, current_dataset, rheo_data ) }
    
    rheo_input_parameters$sample_mask <- sample_mask
    rheo_input_parameters$feature_selection <- as.integer( input$PCA_rheo_features_pi )
    
    Rheology_Analysis$Utilities$read_and_analyse_features( rheo_input_parameters, rheo_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_rheo_features_pi )
    
  }
  
  if (5 %in% datasets_to_plot) {
    
    if (tt_data$compute_features) { initiate_data_reading( "tt", "TT" ); compute_tt_features( tt_input_parameters, current_dataset, tt_data ) }
    
    tt_input_parameters$sample_mask <- sample_mask
    tt_input_parameters$feature_selection <- as.integer( input$PCA_tt_features_pi )
    
    TT_Analysis$Utilities$read_and_analyse_features( tt_input_parameters, tt_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tt_features_pi )
    
  }
  
  if (6 %in% datasets_to_plot) {
    
    if (colour_data$compute_features) { initiate_data_reading( "colour", "Colour" ); compute_colour_features( colour_input_parameters, current_dataset, colour_data ) }
    
    colour_input_parameters$sample_mask <- sample_mask
    colour_input_parameters$feature_selection <- as.integer( input$PCA_colour_features_pi )
    
    Colour_Analysis$Utilities$read_and_analyse_features( colour_input_parameters, colour_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_colour_features_pi )
    
  }
  
  if (7 %in% datasets_to_plot) {
    
    if (shm_data$compute_features) { initiate_data_reading( "shm", "SHM" ); compute_shm_features( shm_input_parameters, current_dataset, shm_data ) }
    
    shm_input_parameters$sample_mask <- sample_mask
    
    SHM_Analysis$Utilities$read_and_analyse_SHM_features( shm_input_parameters, shm_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + 1
    
  }
  
  if (8 %in% datasets_to_plot) {
    
    if (tls_data$compute_features) { initiate_data_reading( "tls", "TLS" ); compute_tls_features( tls_input_parameters, current_dataset, tls_data ) }
    
    tls_input_parameters$sample_mask <- sample_mask
    tls_input_parameters$feature_selection <- as.integer( input$PCA_tls_features_pi )
    
    TLS_Analysis$Utilities$read_and_analyse_features( tls_input_parameters, tls_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_tls_features_pi )
    
  }
  
  if (9 %in% datasets_to_plot) {
    
    if (escr_data$compute_features) { initiate_data_reading( "escr", "ESCR" ); compute_escr_features( escr_input_parameters, current_dataset, escr_data ) }
    
    escr_input_parameters$sample_mask <- sample_mask
    escr_input_parameters$feature_selection <- as.integer( input$PCA_escr_features_pi )
    
    ESCR_Analysis$Utilities$read_and_analyse_ESCR_features( escr_input_parameters, escr_data$data_minus_hidden[[1]], current_dataset() )
    
    num_features <- num_features + length( input$PCA_escr_features_pi )
    
  }
  
  validate( need( num_features > 1, "Please select more features to perform the PCA on." ) )
  
  global_input_parameters$datasets_to_read <- datasets_to_plot
  global_input_parameters$sample_mask <- sample_mask
  
  Global_Analysis$Preprocessing$read_files_and_preprocess( global_input_parameters, datasets_to_read = datasets_to_plot, name_appendage = current_dataset() )
  
}

PCA_read_files_r <- eventReactive( input$PCA_compute_ab, PCA_read_files( global_input_parameters, read_PCA_select_datasets_cb(), PCA_selected_resins() ) )

obtain_PCA_data_to_plot <- function( global_input_parameters, datasets_to_plot, sample_mask ) {
  
  global_input_parameters$datasets_to_read <- datasets_to_plot
  global_input_parameters$sample_mask <- sample_mask
  
  data_transfer <- Global_Analysis$Utilities$pca( global_input_parameters, PCA_read_files_r()[[1]], PCA_read_files_r()[[2]], current_dataset() )
  
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
  
  list( data_to_plot, data_to_plot_2, data_transfer[[9]], data_transfer[[10]] )
  
}

obtain_PCA_data_to_plot_main <- eventReactive( input$PCA_compute_ab, {
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 0, "Please select the datasets to perform the PCA on." ) )
  validate( need( !(length( read_PCA_select_datasets_cb() ) == 1 && read_PCA_select_datasets_cb() == 7), "As SHM contains just one feature, it must be selected with at least one other dataset." ) )
  validate( need( length( PCA_selected_resins() ) > 0, "Please select the resins to perform the PCA on." ) )
  
  obtain_PCA_data_to_plot( global_input_parameters, read_PCA_select_datasets_cb(), PCA_selected_resins() )
  
})

obtain_PCA_data_to_plot_ftir <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 1L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_dsc <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 2L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_tga <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 3L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_rheo <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 4L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_tt <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 5L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_colour <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 6L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_tls <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 8L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )
obtain_PCA_data_to_plot_escr <- reactive( obtain_PCA_data_to_plot( global_input_parameters, c( 9L ), obtain_PCA_data_to_plot_main()[[1]][[5]] ) )

output$PCA_po <- renderPlot({

  data_to_plot <- obtain_PCA_data_to_plot_main()
  
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
  
  g <- plot_pca( input, data_to_plot, resin_data_r(), title_str )
  
  g

})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_main()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_main()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_main()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_main()[[4]][[1]][[2]] ) )
output$PCA_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_main()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_main()[[4]][[2]][[2]] ) )

output$PCA_ftir_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_ftir(), resin_data_r(), "PCA of FTIR" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_ftir_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_ftir()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_ftir()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_ftir_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_ftir()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_ftir()[[4]][[1]][[2]] ) )
output$PCA_ftir_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_ftir()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_ftir()[[4]][[2]][[2]] ) )

output$PCA_dsc_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_dsc(), resin_data_r(), "PCA of DSC" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_dsc_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_dsc()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_dsc()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_dsc_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_dsc()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_dsc()[[4]][[1]][[2]] ) )
output$PCA_dsc_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_dsc()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_dsc()[[4]][[2]][[2]] ) )

output$PCA_tga_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_tga(), resin_data_r(), "PCA of TGA" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_tga_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_tga()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_tga()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_tga_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tga()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_tga()[[4]][[1]][[2]] ) )
output$PCA_tga_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tga()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_tga()[[4]][[2]][[2]] ) )

output$PCA_rheo_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_rheo(), resin_data_r(), "PCA of Rheology" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_rheo_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_rheo()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_rheo()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_rheo_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_rheo()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_rheo()[[4]][[1]][[2]] ) )
output$PCA_rheo_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_rheo()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_rheo()[[4]][[2]][[2]] ) )

output$PCA_tt_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_tt(), resin_data_r(), "PCA of Tensile Testing" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_tt_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_tt()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_tt()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_tt_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tt()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_tt()[[4]][[1]][[2]] ) )
output$PCA_tt_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tt()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_tt()[[4]][[2]][[2]] ) )

output$PCA_colour_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_colour(), resin_data_r(), "PCA of Colour" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_colour_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_colour()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_colour()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_colour_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_colour()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_colour()[[4]][[1]][[2]] ) )
output$PCA_colour_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_colour()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_colour()[[4]][[2]][[2]] ) )

output$PCA_tls_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_tls(), resin_data_r(), "PCA of TLS" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_tls_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_tls()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_tls()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_tls_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tls()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_tls()[[4]][[1]][[2]] ) )
output$PCA_tls_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_tls()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_tls()[[4]][[2]][[2]] ) )

output$PCA_escr_po <- renderPlot({
  
  validate( need( length( read_PCA_select_datasets_cb() ) > 1, "Subplots for individual datasets are only shown when more than one dataset is selected." ) )
  
  plot_pca( input, obtain_PCA_data_to_plot_escr(), resin_data_r(), "PCA of ESCR" )
  
})  %>% bindEvent( c( input$PCA_compute_ab, input$PCA_add_labels_cb, input$PCA_loading_plot_cb ) )

output$PCA_escr_variation_to <- renderTable({
  
  table <- data.frame( t( obtain_PCA_data_to_plot_escr()[[3]] * 100 ) )
  
  names( table ) <- lapply( 1:length( obtain_PCA_data_to_plot_escr()[[3]] ), function( x ) { paste0( "PC ", as.character( x ) ) } )
  
  table
  
})

output$PCA_escr_coefficients_1_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_escr()[[4]][[1]][[1]], Coefficients = obtain_PCA_data_to_plot_escr()[[4]][[1]][[2]] ) )
output$PCA_escr_coefficients_2_to <- renderTable( data.frame( Features = obtain_PCA_data_to_plot_escr()[[4]][[2]][[1]], Coefficients = obtain_PCA_data_to_plot_escr()[[4]][[2]][[2]] ) )

# plot_grid( plotlist = list( g1, g2 ) )

