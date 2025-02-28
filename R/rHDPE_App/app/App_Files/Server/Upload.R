# Upload tab server code.

iv <- InputValidator$new()

iv$add_rule( "upload_modal_2_new_or_existing_resin_cb", sv_required( message = "Please select if this is a new or existing resin" ) )
iv$add_rule( "upload_modal_2_new_or_existing_resin_cb", ~ if (length( . ) > 1) "Select only one option" )

show_upload_modal_1 <- function( si = NULL ) {
  
  if (current_dataset() == "") {
    
    showModal( modalDialog( title = "You Need To Change The Dataset Version",
                            
      size = "xl",
      
      verbatimTextOutput( "upload_modal_0_to" ),
      
      footer = tagList( modalButton( "Dismiss" ) )
                            
    ) )
    
  } else {
    
    showModal( modalDialog( title = "Experiment",
                            
      selectizeInput( "upload_modal_1_experiment_si", "Which experiment would you like to upload data for?", choices = c( "", experiments ), select = si, options = list( placeholder = "Please select an option below" ) ),
      
      footer = tagList( actionButton( "upload_modal_1_dismiss", "Dismiss" ), actionButton( "upload_modal_1_submit", "Submit" ) )
                            
    ) )
    
  }
  
}

show_upload_modal_1b <- function() {
  
  showModal( modalDialog( title = "Upload Files",
                          
    fileInput( "upload_fi", "Upload the file(s)", multiple = TRUE ),
    
    footer = tagList( actionButton( "upload_modal_1b_dismiss", "Dismiss" ), actionButton( "upload_modal_1b_submit", "Submit" ) )
                          
  ) )
  
}

upload_modal_1_experiment_si_r <- reactiveVal( NULL )

show_upload_modal_5 <- function() {
  
  showModal( modalDialog( title = "Dataset Version",
                          
    size = "xl",
                          
    verbatimTextOutput( "upload_modal_5_to" ),
    
    footer = tagList( actionButton( "upload_modal_5_continue", "Continue" ), modalButton( "Dismiss" ) )
                          
  ) )
  
}

output$upload_modal_5_to <- renderText( paste0( "The dataset version that you will be uploading to is: ", input$settings_dataset_version_si, "\nIf you wish to change the dataset version, go to Settings." ) )

output$upload_modal_0_to <- renderText( "The current dataset version is 'Original', which new data can't be uploaded to.
                                        \nTo upload data, change the dataset version. This can be done in Settings.
                                        \nYou may need to first create a new dataset version, which again can be done in Settings." )

show_upload_modal_2 <- function( cb = NULL ) {
  
  showModal( modalDialog( title = "Metadata for upload",
    
    checkboxGroupInput( "upload_modal_2_new_or_existing_resin_cb", NULL, choices = c("New resin", "Existing resin"), selected = cb ),
    
    footer = tagList( actionButton( "upload_modal_2_back", "Back" ), actionButton( "upload_modal_2_continue", "Continue" ), modalButton( "Dismiss" ) )
    
  ) )
  
}

upload_modal_2_new_or_existing_resin_cb_r <- reactiveVal( NULL )

show_upload_modal_3 <- function( ni = NULL, cb = FALSE ) {
  
  showModal( modalDialog( title = "Resin Identifier",

    checkboxInput( "upload_modal_3_suggested_resin_identifier_cb", "Suggest the next available resin identifier", cb ),

    numericInput( "upload_modal_3_ni", "Resin identifier", ni ),

    footer = tagList( actionButton( "upload_modal_3_back", "Back" ), actionButton( "upload_modal_3_continue", "Continue" ), modalButton( "Dismiss" ) )

  ) )
  
}

upload_modal_3_ni_r <- reactiveVal( NULL )

show_upload_modal_4 <- function( ti = NULL, cb = FALSE, ti2 = NULL ) {
  
  showModal( modalDialog( title = "Resin Name",
    
    textInput( "upload_modal_4_ti", "Resin Name", ti ),
    
    checkboxInput( "upload_modal_4_suggested_resin_label_cb", "Suggest the label", cb ),
    
    textInput( "upload_modal_4_label_ti", "Resin Label, e.g. PCR 1", ti2 ),
    
    footer = tagList( actionButton( "upload_modal_4_back", "Back" ), actionButton( "upload_modal_4_continue", "Continue" ), modalButton( "Dismiss" ) )
      
  ) )
  
}

show_upload_modal_6 <- function() {
  
  showModal( modalDialog( title = "Upload Files",
                          
    p( "Click 'Upload' to upload the data." ),
    
    footer = tagList( input_task_button( "upload_modal_6_itb", "Upload Files", label_busy = "Uploading..." ), modalButton( "Cancel" ) )
                          
  ) )
  
}

upload_modal_4_ti_r <- reactiveVal( NULL )
upload_modal_4_label_ti_r <- reactiveVal( NULL )

observeEvent( input$tabs_tp, {
  
  if (input$tabs_tp == "Upload") {
    
    show_upload_modal_1( upload_modal_1_experiment_si_r() )
    
  }
  
})

observeEvent( input$upload_select_files_ab, {
    
  show_upload_modal_1( upload_modal_1_experiment_si_r() )
  
})

observe( removeModal() ) %>% bindEvent( c( input$upload_modal_1_dismiss, input$upload_modal_1_submit ) )

observe( removeModal() ) %>% bindEvent( c( input$upload_modal_1b_dismiss, input$upload_modal_1b_submit ) )

observeEvent( input$upload_modal_1_submit, upload_modal_1_experiment_si_r( input$upload_modal_1_experiment_si ) )

observeEvent( input$upload_modal_1_dismiss, {
  
  if (is.null( upload_modal_1_experiment_si_r() )) {
    
    showNotification( "Please select an experiment!" )
    
  }
  
  else if (upload_modal_1_experiment_si_r() == "") {
    
    showNotification( "Please select an experiment!" )
    
  }
  
})

observeEvent( input$upload_modal_1_submit, {
  
  if (is.null( upload_modal_1_experiment_si_r() )) {
    
    showNotification( "Please select an experiment!" )
    
  }
  
  else if (upload_modal_1_experiment_si_r() == "") {
    
    showNotification( "Please select an experiment!" )
    
  }
  
  show_upload_modal_1b()
  
})

output$upload_experiment_to <- renderText( paste0( "You are uploading data for: ", upload_modal_1_experiment_si_r() ) )

output$upload_select_files_to <- renderText( paste0( "You are uploading ", nrow( files_to_upload() ), " files." ) )

files_to_upload <- reactiveVal()

observeEvent( input$upload_fi, {
  
  files_to_upload( input$upload_fi )
  
  show_upload_modal_5()
  
})

observeEvent( input$upload_change_metadata_ab, {
  
  show_upload_modal_5()
  
})

observeEvent( input$upload_modal_2_new_or_existing_resin_cb, {
    
  iv$enable()

  req( iv$is_valid() )

  iv$disable()
  
  if (input$upload_modal_2_new_or_existing_resin_cb == "New resin") {
    
    removeModal()

    show_upload_modal_3( input$upload_modal_3_ni, input$upload_modal_3_suggested_resin_identifier_cb )

  }
  
})

observeEvent( input$upload_modal_5_continue, {
  
  removeModal()
    
  show_upload_modal_2( input$upload_modal_2_new_or_existing_resin_cb )
  
})

observeEvent( input$upload_modal_2_continue, {
  
  iv$enable()
  
  req( iv$is_valid() )
  
  iv$disable()
  
  if (input$upload_modal_2_new_or_existing_resin_cb == "New resin") {
    
    removeModal()
    
    show_upload_modal_3( input$upload_modal_3_ni, input$upload_modal_3_suggested_resin_identifier_cb )
    
  }
  
})

observeEvent( input$upload_modal_3_suggested_resin_identifier_cb, {
  
  if (input$upload_modal_3_suggested_resin_identifier_cb) {
    
    suggested_resin_identifer <- max( resin_data_r()$Identifier ) + 1
    
    if (suggested_resin_identifer < 1001) suggested_resin_identifer <- 1001
    
    updateNumericInput( inputId = "upload_modal_3_ni", value = suggested_resin_identifer )
    
  }
  
  else {

    updateNumericInput( inputId = "upload_modal_3_ni", value = "" )

  }
  
})

observeEvent( input$upload_modal_4_suggested_resin_label_cb, {
  
  if (input$upload_modal_4_suggested_resin_label_cb) {
    
    updateTextInput( inputId = "upload_modal_4_label_ti", value = paste( "PCR", input$upload_modal_3_ni ) )
    
  }
  
  else {
    
    updateTextInput( inputId = "upload_modal_4_label_ti", value = "" )
    
  }
  
})

observeEvent( input$upload_modal_2_back, {
  
  removeModal()
  
  show_upload_modal_5()
  
})

observeEvent( input$upload_modal_3_back, {
  
  removeModal()
  
  show_upload_modal_2( input$upload_modal_2_new_or_existing_resin_cb )
  
})

observeEvent( input$upload_modal_4_back, {
  
  removeModal()
  
  show_upload_modal_3( input$upload_modal_3_ni, input$upload_modal_3_suggested_resin_identifier_cb )
  
})

observeEvent( input$upload_modal_3_continue, {
  
  removeModal()
  
  show_upload_modal_4( input$upload_modal_4_ti, input$upload_modal_4_suggested_resin_label_cb, input$upload_modal_4_label_ti )
  
})

upload_metadata_entry_complete <- reactiveVal( FALSE )

observeEvent( input$upload_modal_4_continue, {
  
  removeModal()
  
  upload_modal_2_new_or_existing_resin_cb_r( input$upload_modal_2_new_or_existing_resin_cb )
  upload_modal_3_ni_r( input$upload_modal_3_ni )
  upload_modal_4_ti_r( input$upload_modal_4_ti )
  upload_modal_4_label_ti_r( input$upload_modal_4_label_ti )
  
  upload_metadata_entry_complete( TRUE )
  
  show_upload_modal_6()
  
})

table_of_uploaded_data <- reactive({
  
  req( !is.null( files_to_upload() ) )
  
  table <- files_to_upload() %>% select( "name" )
  
  table$UploadedAs <- lapply( 0:(nrow( table ) - 1), function(x) paste0( "Resin", as.character( upload_modal_3_ni_r() ), "_", as.character( x ), "_" ) )
  
  table
  
})

output$upload_info_to <- renderTable({
  
  table <- table_of_uploaded_data()
  
  names( table ) <- c( "Filename", "File will be renamed as..." )
  
  table
  
})

run_upload <- reactiveVal( 0 )

observeEvent( input$upload_itb, {
  
  run_upload( run_upload() + 1 )
  
})

observeEvent( input$upload_modal_6_itb, {
  
  run_upload( run_upload() + 1 )
  
})

observeEvent( run_upload(), {
  
  if (current_dataset() == "") showNotification( "The original dataset version cannot be modified. Create a new dataset version or select a different dataset version in Settings." )
  
  req( current_dataset() != "" )
  
  if (is.null( files_to_upload() )) showNotification( "Select files to upload." )
  
  req( !is.null( files_to_upload() ) )
  
  if (!upload_metadata_entry_complete()) showNotification( "Complete metadata entry." )
  
  req( upload_metadata_entry_complete() )
  
  resin_data_r( resin_data_r() %>% add_row( Identifier = upload_modal_3_ni_r(), Name = upload_modal_4_ti_r(), Label = upload_modal_4_label_ti_r(), (!!as.name( upload_modal_1_experiment_si_r() )) := 1 ) )
  
  write_xlsx( resin_data_r(), paste0( directory, "List_of_Resins", current_dataset(), ".xlsx" ) )
  
  initial_files$save <- TRUE
  
  if (upload_modal_1_experiment_si_r() == "FTIR") {
    
    initiate_data_reading( "ftir", "FTIR" )
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- FTIR_Analysis$Preprocessing$read_shiny_file( ftir_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      ftir_data$data[[2]][[2]] <- append( ftir_data$data[[2]][[2]], read_file[[2]] )
      ftir_data$data[[1]] <- append( ftir_data$data[[1]], read_file[[1]] )
      
    }
    
    write_ftir_data( ftir_input_parameters, current_dataset, ftir_data )
    
    ftir_data$save <- TRUE
    ftir_data$compute_features <- TRUE
    
    update_data_minus_hidden_ftir( ftir_input_parameters, current_dataset, ftir_data )
    
  }
  
  files_to_upload( NULL )
  
  showNotification( "Upload Complete!" )
  
  removeModal()
  
}, ignoreInit = TRUE )