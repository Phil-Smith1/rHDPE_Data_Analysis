# Save tab server code.

save_progress <- NULL
datasets_to_save <- reactiveVal( 0 )

perform_save_of_data <- function() {
  
  datasets_to_save( 0 )
  
  if (app_user == "shiny") {
    
    save_progress <<- shiny::Progress$new()
    save_progress$set( message = "Saving Files", value = 0 )
    
    if (initial_files$save) {datasets_to_save( datasets_to_save() + 1 ); save_initial_files_gd_et$invoke( directory )}
    if (ftir_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_ftir$invoke( directory )}
    if (dsc_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_dsc$invoke( directory )}
    if (tga_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_tga$invoke( directory )}
    if (rheo_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_rheo$invoke( directory )}
    if (colour_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_colour$invoke( directory )}
    if (tt_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_tt$invoke( directory )}
    if (shm_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_shm$invoke( directory )}
    if (tls_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_tls$invoke( directory )}
    if (escr_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_escr$invoke( directory )}
    if (gcms_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_gcms$invoke( directory )}
    if (global_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_global$invoke( directory )}
    if (raw_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_zip_file_to_gd_et_raw_data$invoke( directory )}
    
  } else if (app_user == "docker") {
    
    save_progress <<- shiny::Progress$new()
    save_progress$set( message = "Saving Files", value = 0 )
    
    if (initial_files$save) {datasets_to_save( datasets_to_save() + 1 ); save_initial_files_datalab_et$invoke( client, env, token, list_of_repoids() )}
    if (ftir_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_ftir$invoke( client, env, token, list_of_repoids() )}
    if (dsc_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_dsc$invoke( client, env, token, list_of_repoids() )}
    if (tga_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_tga$invoke( client, env, token, list_of_repoids() )}
    if (rheo_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_rheo$invoke( client, env, token, list_of_repoids() )}
    if (colour_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_colour$invoke( client, env, token, list_of_repoids() )}
    if (tt_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_tt$invoke( client, env, token, list_of_repoids() )}
    if (shm_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_shm$invoke( client, env, token, list_of_repoids() )}
    if (tls_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_tls$invoke( client, env, token, list_of_repoids() )}
    if (escr_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_escr$invoke( client, env, token, list_of_repoids() )}
    if (gcms_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_gcms$invoke( client, env, token, list_of_repoids() )}
    if (global_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_global$invoke( client, env, token, list_of_repoids() )}
    if (raw_data$save) {datasets_to_save( datasets_to_save() + 1 ); save_file_to_datalab_et_raw_data$invoke( client, env, token, list_of_repoids() )}
    
  }
  
}

observeEvent( input$save_quick_itb, {
  
  disable( "save_full_itb" )
  
  if (app_user == "philsmith") {
    
    showNotification( "Files already saved locally." )
    
  }
  
  perform_save_of_data()
  
})

observeEvent( input$save_full_itb, {
  
  disable( "save_quick_itb" )
  
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
  
  if (app_user == "philsmith") {
    
    showNotification( "Files already saved locally." )
    
  }
  
  perform_save_of_data()
  
})

observe({
  
  input$save_quick_itb
  input$save_full_itb
  
  if (app_user == "shiny") {
    
    counter <- 0
    
    try( if (isolate( initial_files$save )) {if (save_initial_files_gd_et$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( ftir_data$save )) {if (save_zip_file_to_gd_et_ftir$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( dsc_data$save )) {if (save_zip_file_to_gd_et_dsc$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tga_data$save )) {if (save_zip_file_to_gd_et_tga$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( rheo_data$save )) {if (save_zip_file_to_gd_et_rheo$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( colour_data$save )) {if (save_zip_file_to_gd_et_colour$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tt_data$save )) {if (save_zip_file_to_gd_et_tt$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( shm_data$save )) {if (save_zip_file_to_gd_et_shm$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tls_data$save )) {if (save_zip_file_to_gd_et_tls$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( escr_data$save )) {if (save_zip_file_to_gd_et_escr$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( gcms_data$save )) {if (save_zip_file_to_gd_et_gcms$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( global_data$save )) {if (save_zip_file_to_gd_et_global$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( raw_data$save )) {if (save_zip_file_to_gd_et_raw_data$result()) counter <- counter + 1}, silent = TRUE )
    
    if (counter > 0) save_progress$set( value = counter / isolate( datasets_to_save() ) )
    
    if (!is.null( save_progress ) & counter == isolate( datasets_to_save() )) {
      
      enable( "save_quick_itb" )
      enable( "save_full_itb" )
      
      update_task_button( "save_quick_itb", state = "ready" )
      update_task_button( "save_full_itb", state = "ready" )
      
      save_progress$close()
      
      initial_files$save <- FALSE
      ftir_data$save <- FALSE
      dsc_data$save <- FALSE
      tga_data$save <- FALSE
      rheo_data$save <- FALSE
      colour_data$save <- FALSE
      tt_data$save <- FALSE
      shm_data$save <- FALSE
      tls_data$save <- FALSE
      escr_data$save <- FALSE
      gcms_data$save <- FALSE
      global_data$save <- FALSE
      raw_data$save <- FALSE
      
    }
    
  } else if (app_user == "docker") {
    
    counter <- 0
    
    try( if (isolate( initial_files$save )) {if (save_initial_files_datalab_et$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( ftir_data$save )) {if (save_file_to_datalab_et_ftir$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( dsc_data$save )) {if (save_file_to_datalab_et_dsc$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tga_data$save )) {if (save_file_to_datalab_et_tga$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( rheo_data$save )) {if (save_file_to_datalab_et_rheo$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( colour_data$save )) {if (save_file_to_datalab_et_colour$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tt_data$save )) {if (save_file_to_datalab_et_tt$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( shm_data$save )) {if (save_file_to_datalab_et_shm$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( tls_data$save )) {if (save_file_to_datalab_et_tls$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( escr_data$save )) {if (save_file_to_datalab_et_escr$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( gcms_data$save )) {if (save_file_to_datalab_et_gcms$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( global_data$save )) {if (save_file_to_datalab_et_global$result()) counter <- counter + 1}, silent = TRUE )
    try( if (isolate( raw_data$save )) {if (save_file_to_datalab_et_raw_data$result()) counter <- counter + 1}, silent = TRUE )
    
    if (counter > 0) save_progress$set( value = counter / isolate( datasets_to_save() ) )
    
    if (!is.null( save_progress ) & counter == isolate( datasets_to_save() )) {
      
      enable( "save_quick_itb" )
      enable( "save_full_itb" )
      
      update_task_button( "save_quick_itb", state = "ready" )
      update_task_button( "save_full_itb", state = "ready" )
      
      save_progress$close()
      
      initial_files$save <- FALSE
      ftir_data$save <- FALSE
      dsc_data$save <- FALSE
      tga_data$save <- FALSE
      rheo_data$save <- FALSE
      colour_data$save <- FALSE
      tt_data$save <- FALSE
      shm_data$save <- FALSE
      tls_data$save <- FALSE
      escr_data$save <- FALSE
      gcms_data$save <- FALSE
      global_data$save <- FALSE
      raw_data$save <- FALSE
      
    }
    
  }
  
})