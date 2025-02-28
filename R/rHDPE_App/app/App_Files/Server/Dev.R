# Dev tab server code.

# observe({
# 
#   print( ftir_data$download_data )
#   print( dsc_data$download_data )
#   print( tga_data$download_data )
#   print( rheo_data$download_data )
#   print( colour_data$download_data )
#   print( tt_data$download_data )
#   print( shm_data$download_data )
#   print( tls_data$download_data )
#   print( escr_data$download_data )
#   print( gcms_data$download_data )
#   print( global_data$download_data )
#   print( raw_data$download_data )
# 
# })

dev_read_dataset <- reactiveVal()
dev_write_dataset <- reactiveVal()

observeEvent( dataset_versions_r(), {
  
  updateSelectInput( session, "dev_dataset_version_to_read_si", choices = dataset_versions_r() %>% pull( Name ) )
  updateSelectInput( session, "dev_dataset_version_to_write_si", choices = dataset_versions_r() %>% pull( Name ) )
  
})

observeEvent( input$dev_dataset_version_to_read_si, {
  
  dev_read_dataset( dataset_versions_r()$Suffix[match( input$dev_dataset_version_to_read_si, dataset_versions_r()$Name )] )
  
}, ignoreInit = TRUE )

observeEvent( input$dev_dataset_version_to_write_si, {
  
  dev_write_dataset( dataset_versions_r()$Suffix[match( input$dev_dataset_version_to_write_si, dataset_versions_r()$Name )] )
  
}, ignoreInit = TRUE )

observeEvent( input$dev_generate_data_ab, {
  
  if (dev_write_dataset() == "") {
    
    showNotification( "The original dataset version cannot be modified." )
    
  }
  
  req( dev_write_dataset() != "" )
    
  if (input$dev_generate_data_si == "FTIR") {
    
    read_ftir_data( ftir_input_parameters, dev_read_dataset, ftir_data )
    
    write_ftir_data( ftir_input_parameters, dev_write_dataset, ftir_data )
    
    ftir_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "DSC") {
    
    read_dsc_data( dsc_input_parameters, dev_read_dataset, dsc_data )
    
    write_dsc_data( dsc_input_parameters, dev_write_dataset, dsc_data )
    
    dsc_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "TGA") {
    
    read_tga_data( tga_input_parameters, dev_read_dataset, tga_data )
    
    write_tga_data( tga_input_parameters, dev_write_dataset, tga_data )
    
    tga_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "Rheology") {
    
    read_rheo_data( rheo_input_parameters, dev_read_dataset, rheo_data )
    
    write_rheo_data( rheo_input_parameters, dev_write_dataset, rheo_data )
    
    rheo_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "Colour") {
    
    read_colour_data( colour_input_parameters, dev_read_dataset, colour_data )
    
    write_colour_data( colour_input_parameters, dev_write_dataset, colour_data )
    
    colour_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "Tensile Testing") {
    
    read_tt_data( tt_input_parameters, dev_read_dataset, tt_data )
    
    write_tt_data( tt_input_parameters, dev_write_dataset, tt_data )
    
    tt_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "SHM") {
    
    read_shm_data( shm_input_parameters, dev_read_dataset, shm_data )
    
    write_shm_data( shm_input_parameters, dev_write_dataset, shm_data )
    
    shm_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "TLS") {
    
    read_tls_data( tls_input_parameters, dev_read_dataset, tls_data )
    
    write_tls_data( tls_input_parameters, dev_write_dataset, tls_data )
    
    tls_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "ESCR") {
    
    read_escr_data( escr_input_parameters, dev_read_dataset, escr_data )
    
    write_escr_data( escr_input_parameters, dev_write_dataset, escr_data )
    
    escr_data$read_data <- FALSE
    
  }
  
  if (input$dev_generate_data_si == "GCMS") {
    
    read_gcms_data( gcms_input_parameters, dev_read_dataset, gcms_data )
    
    write_gcms_data( gcms_input_parameters, dev_write_dataset, gcms_data )
    
    gcms_data$read_data <- FALSE
    
  }
  
})

observeEvent( input$dev_ab, {
  
  dev_print_r( c( detectCores(), nbrOfWorkers(), nbrOfFreeWorkers(), ftir_data$download_data ) )
  print( c( detectCores(), nbrOfWorkers(), nbrOfFreeWorkers() ) )
  
})

observeEvent( input$dev_ab2, {
  
  read_file_from_datalab( client, env, token, list_of_repoids(), "FTIR", "zip" )
  
  print( paste0( "Completed download of FTIR" ) )
  
})

observeEvent( input$dev_ab3, {
  
  read_file_from_datalab_et_ftir$invoke( client, env, token, list_of_repoids() )
  
})

observeEvent( input$dev_itb, {
  
  delete_tga_data( tga_input_parameters, current_dataset )
  
})

observe( dev_print_r( read_file_from_datalab_et_ftir$result() ) )

dev_print_r <- reactiveVal()

output$dev_print_to <- renderPrint( dev_print_r() )

