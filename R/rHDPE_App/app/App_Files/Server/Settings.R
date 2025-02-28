# Settings tab server code.

observeEvent( dataset_versions_r(), {

  updateSelectInput( session, "settings_dataset_version_si", choices = dataset_versions_r() %>% pull( Name ) )
  updateSelectInput( session, "home_dataset_version_si", choices = dataset_versions_r() %>% pull( Name ) )
  
  write_xlsx( dataset_versions_r(), paste0( directory, "Dataset_Versions.xlsx" ) )

})

observeEvent( input$home_dataset_version_si, {

  updateSelectInput( session, "settings_dataset_version_si", selected = input$home_dataset_version_si )

})

observeEvent( input$settings_dataset_version_si, {

  updateSelectInput( session, "home_dataset_version_si", selected = input$settings_dataset_version_si )

})

current_dataset <- reactiveVal()

observeEvent( input$settings_dataset_version_si, {
  
  current_dataset( dataset_versions_r()$Suffix[match( input$settings_dataset_version_si, dataset_versions_r()$Name )] )
  
}, ignoreInit = TRUE )

show_settings_modal_1 <- function() {
  
  showModal( modalDialog( title = "Create New Dataset Version",
                          
    selectInput( "settings_modal_1_si", "Select dataset to clone", choices = dataset_versions_r() %>% pull( Name ) ),
    
    textInput( "settings_modal_1_ti", "Provide the name for the new copy" ),
    
    footer = tagList( actionButton( "settings_modal_1_submit", "Submit" ), modalButton( "Dismiss" ) )
                          
  ) )
  
}

show_settings_modal_2 <- function() {
  
  showModal( modalDialog( title = "Delete Dataset Version",
                          
    selectInput( "settings_modal_2_si", "Select dataset to delete", choices = (dataset_versions_r() %>% pull( Name ))[dataset_versions_r() %>% pull( "Name" ) != "Original"] ),
    
    footer = tagList( actionButton( "settings_modal_2_submit", "Submit" ), modalButton( "Dismiss" ) )
                          
  ) )
  
}

observeEvent( input$settings_new_dataset_version_ab, {
  
  show_settings_modal_1()
  
})

observeEvent( input$settings_modal_1_submit, {
  
  removeModal()
  
  next_index = max( dataset_versions_r()$Index ) + 1
  
  new_dataset_suffix <- paste0( "_", next_index )
  
  file.copy( paste0( directory, "List_of_Resins", dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], ".xlsx" ), paste0( directory, "List_of_Resins", new_dataset_suffix, ".xlsx" ) )
  
  copy_ftir_data( ftir_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_dsc_data( dsc_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_tga_data( tga_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_rheo_data( rheo_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_colour_data( colour_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_tt_data( tt_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_shm_data( shm_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_tls_data( tls_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_escr_data( escr_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  copy_gcms_data( gcms_input_parameters, dataset_versions_r()$Suffix[match( input$settings_modal_1_si, dataset_versions_r()$Name )], new_dataset_suffix )
  
  dataset_versions_r( dataset_versions_r() %>% add_row( Name = input$settings_modal_1_ti, Suffix = new_dataset_suffix, Index = next_index ) )
  
  initial_files$save <- TRUE
  ftir_data$save <- TRUE
  dsc_data$save <- TRUE
  tga_data$save <- TRUE
  rheo_data$save <- TRUE
  colour_data$save <- TRUE
  tt_data$save <- TRUE
  shm_data$save <- TRUE
  tls_data$save <- TRUE
  escr_data$save <- TRUE
  gcms_data$save <- TRUE
  global_data$save <- TRUE
  raw_data$save <- TRUE
  
})

observeEvent( input$settings_delete_dataset_version_ab, {
  
  show_settings_modal_2()
  
})

observeEvent( input$settings_modal_2_submit, {
  
  removeModal()
  
  dataset_to_delete <- reactiveVal( dataset_versions_r()$Suffix[match( input$settings_modal_2_si, dataset_versions_r()$Name )] )
  
  if (dataset_to_delete() != "") {
    
    if (file.exists( paste0( directory, "List_of_Resins", dataset_to_delete(), ".xlsx" ) )) {
      
      file.remove( paste0( directory, "List_of_Resins", dataset_to_delete(), ".xlsx" ) )
      
    }
    
    delete_ftir_data( ftir_input_parameters, dataset_to_delete )
    delete_dsc_data( dsc_input_parameters, dataset_to_delete )
    delete_tga_data( tga_input_parameters, dataset_to_delete )
    delete_rheo_data( rheo_input_parameters, dataset_to_delete )
    delete_colour_data( colour_input_parameters, dataset_to_delete )
    delete_tt_data( tt_input_parameters, dataset_to_delete )
    delete_shm_data( shm_input_parameters, dataset_to_delete )
    delete_tls_data( tls_input_parameters, dataset_to_delete )
    delete_escr_data( escr_input_parameters, dataset_to_delete )
    delete_gcms_data( gcms_input_parameters, dataset_to_delete )
    
    dataset_versions_r( dataset_versions_r()[-match( input$settings_modal_2_si, dataset_versions_r()$Name ),] )
    
    initial_files$save <- TRUE
    ftir_data$save <- TRUE
    dsc_data$save <- TRUE
    tga_data$save <- TRUE
    rheo_data$save <- TRUE
    colour_data$save <- TRUE
    tt_data$save <- TRUE
    shm_data$save <- TRUE
    tls_data$save <- TRUE
    escr_data$save <- TRUE
    gcms_data$save <- TRUE
    global_data$save <- TRUE
    raw_data$save <- TRUE
    
  }
  
})