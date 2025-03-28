#===============
# Upload tab server code.

#===============
# Modal Dialogs

# Modal 1

upload_modal_1_experiment_si_r <- reactiveVal( NULL )
experiment_data_r <- reactiveVal()

show_upload_modal_1 <- function( si = NULL ) {
  
  if (current_dataset() == "") {
    
    showModal(
      
      modalDialog( title = "You Need To Change The Dataset Version",
                            
        size = "l",
        
        p( "The current dataset version is 'Original', which new data can't be uploaded to.", br(), br(),
           "To upload data, change the dataset version. This can be done in Settings.", br(), br(),
           "You may need to first create a new dataset version, which again can be done in Settings.", style = paste0( "color: ", text_colour ) ),
        
        footer = tagList( modalButton( "Dismiss" ) )
        
      )
                            
    )
    
  } else {
    
    showModal(
      
      modalDialog( title = "Select Experiment",
                            
        selectizeInput( "upload_modal_1_experiment_si", "Which experiment would you like to upload data for?", choices = setNames( c( "", resin_data_titles ), c( "", experiments ) ), select = si, options = list( placeholder = "Please select an option below" ) ),
        
        conditionalPanel( condition = "input.upload_modal_1_experiment_si != ''",
                          
          downloadButton( "upload_modal_1_download_db", "Download example of compatible file", class = "download" )
          
        ),
        
        footer = tagList( input_task_button( "upload_modal_1_continue", "Continue", label_busy = "Reading Data..." ), actionButton( "upload_modal_1_dismiss", "Dismiss" ) )
      
      )
                            
    )
    
  }
  
}

# Modal 2

show_upload_modal_2 <- function() {
  
  showModal(
    
    modalDialog( title = "Select Files",
                          
      fileInput( "upload_fi", "Select the file(s)", multiple = TRUE ),
      
      footer = tagList( actionButton( "upload_modal_2_back", "Back" ), actionButton( "upload_modal_2_continue", "Continue" ),  modalButton( "Dismiss" ) )
      
    )
                          
  )
  
}

# Modal 3

output$upload_modal_3_to <- renderText( paste0( "The dataset version that you will be uploading to is: ", input$settings_dataset_version_si ) )

show_upload_modal_3 <- function() {
  
  showModal(
    
    modalDialog( title = "Dataset Version",
                            
      span( textOutput( "upload_modal_3_to" ), br(), "If you wish to change the dataset version, go to Settings.", style = paste0( "color: ", text_colour ) ),
      
      footer = tagList( actionButton( "upload_modal_3_back", "Back" ), actionButton( "upload_modal_3_continue", "Continue" ), modalButton( "Dismiss" ) )
      
    )
                          
  )
  
}

# Modal 4

upload_modal_4_new_or_existing_resin_rb_r <- reactiveVal( character( 0 ) )
upload_modal_4_cb_r <- reactiveVal( FALSE )
upload_modal_4_identifier_ni_r <- reactiveVal( NULL )
upload_modal_4_identifier_si_r <- reactiveVal( NULL )

upload_modal_4_iv <- InputValidator$new()
upload_modal_4_ni_iv <- InputValidator$new()
upload_modal_4_si_iv <- InputValidator$new()

upload_modal_4_iv$add_rule( "upload_modal_4_new_or_existing_resin_rb", sv_required( message = "Please select if this is a new or existing resin" ) )

upload_modal_4_ni_iv$add_rule( "upload_modal_4_identifier_ni", sv_required( message = "Please choose a resin identifer" ) )
upload_modal_4_ni_iv$add_rule( "upload_modal_4_identifier_ni", ~ if (!(is.integer( . ) & . > 0)) "Resin identifier should be a positive integer" )
upload_modal_4_ni_iv$add_rule( "upload_modal_4_identifier_ni", ~ if (. %in% resin_data_r()$Identifier) "Resin identifier is already taken" )

upload_modal_4_si_iv$add_rule( "upload_modal_4_identifier_si", sv_required( message = "Please choose a resin identifer" ) )

show_upload_modal_4 <- function( rb = character( 0 ), cb = FALSE, ni = NULL, si = NULL ) {
  
  upload_modal_4_iv$disable()
  upload_modal_4_ni_iv$disable()
  upload_modal_4_si_iv$disable()
  
  showModal(
    
    modalDialog( title = "Resin Identifier",
    
      radioButtons( "upload_modal_4_new_or_existing_resin_rb", NULL, choices = c( "New resin", "Existing resin" ), selected = rb ),
      
      conditionalPanel( condition = "input.upload_modal_4_new_or_existing_resin_rb == 'New resin'",
        
        checkboxInput( "upload_modal_4_suggested_resin_identifier_cb", "Suggest the next available resin identifier", cb ),
        
        numericInput( "upload_modal_4_identifier_ni", "Resin identifier", ni )
        
      ),
      
      conditionalPanel( condition = "input.upload_modal_4_new_or_existing_resin_rb == 'Existing resin'",
                        
        selectizeInput( "upload_modal_4_identifier_si", "Resin identifier", choices = c( "", resin_data_r()$Identifier ), select = si, options = list( placeholder = "Please select an option below" ) )
        
      ),
      
      footer = tagList( actionButton( "upload_modal_4_back", "Back" ), actionButton( "upload_modal_4_continue", "Continue" ), modalButton( "Dismiss" ) )
      
    )
    
  )
  
}

# Modal 5

upload_modal_5_name_ti_r <- reactiveVal( NULL )
upload_modal_5_type_si_r <- reactiveVal( NULL )
upload_modal_5_cb_r <- reactiveVal( FALSE )
upload_modal_5_label_ti_r <- reactiveVal( NULL )

upload_modal_5_name_iv <- InputValidator$new()
upload_modal_5_label_iv <- InputValidator$new()

upload_modal_5_name_iv$add_rule( "upload_modal_5_name_ti", sv_required( message = "Please provide a resin name" ) )
upload_modal_5_label_iv$add_rule( "upload_modal_5_label_ti", sv_required( message = "Please provide a resin label" ) )

show_upload_modal_5 <- function( ti1 = NULL, si = NULL, cb = FALSE, ti2 = NULL ) {
  
  upload_modal_5_name_iv$disable()
  upload_modal_5_label_iv$disable()
  
  showModal(
    
    modalDialog( title = "Resin Metadata",
                 
      p( "All entries here can be changed at a later date in the 'Resin Metadata' tab." ),
      
      if (upload_modal_4_new_or_existing_resin_rb_r() == "Existing resin") p( "These entries are currently frozen as you have selected an existing resin identifier." ),
      
      selectizeInput( "upload_modal_5_type_si", "Resin Type", choices = unique( c( "", upload_modal_5_type_si_r(), resin_types ) ), select = si, options = list( placeholder = "Please select an option below" ) ),
    
      textInput( "upload_modal_5_name_ti", "Resin Name", ti1 ),
      
      checkboxInput( "upload_modal_5_suggested_resin_label_cb", "Suggest the resin label", cb ),
      
      textInput( "upload_modal_5_label_ti", "Resin Label, e.g. PCR 1", ti2 ),
      
      footer = tagList( actionButton( "upload_modal_5_back", "Back" ), actionButton( "upload_modal_5_continue", "Continue" ), modalButton( "Dismiss" ) )
      
    )
      
  )
  
  if (upload_modal_4_new_or_existing_resin_rb_r() == "Existing resin") {
    
    disable( "upload_modal_5_name_ti" )
    disable( "upload_modal_5_type_si" )
    disable( "upload_modal_5_suggested_resin_label_cb" )
    disable( "upload_modal_5_label_ti" )
    
  }
  
}

# Modal 6

show_upload_modal_6 <- function() {
  
  showModal(
    
    modalDialog( title = "Upload Files",
                          
      p( "Click 'Upload' to upload the data." ),
      
      footer = tagList( actionButton( "upload_modal_6_back", "Back" ), input_task_button( "upload_modal_6_itb", "Upload Files", label_busy = "Uploading..." ), modalButton( "Cancel" ) )
      
    )
                          
  )
  
}

#===============
# Code

# Show modal 1 when tab opens.

observeEvent( input$tabs_tp, {
  
  if (input$tabs_tp == "Upload") {
    
    show_upload_modal_1( upload_modal_1_experiment_si_r() )
    
  }
  
})

# Show modal 1 when select files button clicked.

observeEvent( input$upload_select_files_ab, {
    
  show_upload_modal_1( upload_modal_1_experiment_si_r() )
  
})

# Remove modal function for a list of producers.

observe( removeModal(), priority = 1 ) %>% bindEvent( c( input$upload_modal_1_dismiss, input$upload_fi, input$upload_modal_2_back, input$upload_modal_2_continue, input$upload_modal_3_back, input$upload_modal_3_continue, input$upload_modal_4_back, input$upload_modal_5_back, input$upload_modal_6_back ) )

# Modal 1 downloads.

output$upload_modal_1_download_db <- downloadHandler(
  
  filename = function() { 
    
    filename <- ""
    
    if (input$upload_modal_1_experiment_si == "FTIR") filename <- "Example_of_FTIR_file.dat"
    if (input$upload_modal_1_experiment_si == "DSC") filename <- "Example_of_DSC_file.csv"
    if (input$upload_modal_1_experiment_si == "TGA") filename <- "Example_of_TGA_file.xls"
    if (input$upload_modal_1_experiment_si == "Rheology") filename <- "Example_of_Rheology_file.csv"
    if (input$upload_modal_1_experiment_si == "Colour") filename <- "Example_of_Colour_file.csv"
    if (input$upload_modal_1_experiment_si == "TT") filename <- "Example_of_Tensile_Testing_file.xlsx"
    if (input$upload_modal_1_experiment_si == "SHM") filename <- "Example_of_SHM_file.csv"
    if (input$upload_modal_1_experiment_si == "TLS") filename <- "Example_of_TLS_file.csv"
    if (input$upload_modal_1_experiment_si == "ESCR") filename <- "Example_of_ESCR_file.csv"
    if (input$upload_modal_1_experiment_si == "GCMS") filename <- "Example_of_GCMS_file.csv"
    
    filename
    
  },
  
  content = function( file ) {
    
    if (input$upload_modal_1_experiment_si == "FTIR") return( file.copy( "Example_Download_Files/FTIR/Resin1_0_", file ) )
    if (input$upload_modal_1_experiment_si == "DSC") return( file.copy( "Example_Download_Files/DSC/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "TGA") return( file.copy( "Example_Download_Files/TGA/Resin1_0_.xls", file ) )
    if (input$upload_modal_1_experiment_si == "Rheology") return( file.copy( "Example_Download_Files/Rheology/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "Colour") return( file.copy( "Example_Download_Files/Colour/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "TT") return( file.copy( "Example_Download_Files/TT/Resin1_0_.xlsx", file ) )
    if (input$upload_modal_1_experiment_si == "SHM") return( file.copy( "Example_Download_Files/SHM/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "TLS") return( file.copy( "Example_Download_Files/TLS/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "ESCR") return( file.copy( "Example_Download_Files/ESCR/Resin1_0_.csv", file ) )
    if (input$upload_modal_1_experiment_si == "GCMS") return( file.copy( "Example_Download_Files/GCMS/1.csv", file ) )
    
  }
  
)

# Modal 1 continue button.

observeEvent( input$upload_modal_1_continue, {
  
  upload_modal_1_experiment_si_r( input$upload_modal_1_experiment_si )
  if (upload_modal_1_experiment_si_r() == "FTIR") { initiate_data_reading( "ftir", "FTIR" ); experiment_data_r( ftir_data ) }
  if (upload_modal_1_experiment_si_r() == "DSC") { initiate_data_reading( "dsc", "DSC" ); experiment_data_r( dsc_data ) }
  if (upload_modal_1_experiment_si_r() == "TGA") { initiate_data_reading( "tga", "TGA" ); experiment_data_r( tga_data ) }
  if (upload_modal_1_experiment_si_r() == "Rheology") { initiate_data_reading( "rheo", "Rheology" ); experiment_data_r( rheo_data ) }
  if (upload_modal_1_experiment_si_r() == "Colour") { initiate_data_reading( "colour", "Colour" ); experiment_data_r( colour_data ) }
  if (upload_modal_1_experiment_si_r() == "TT") { initiate_data_reading( "tt", "TT" ); experiment_data_r( tt_data ) }
  if (upload_modal_1_experiment_si_r() == "SHM") { initiate_data_reading( "shm", "SHM" ); experiment_data_r( shm_data ) }
  if (upload_modal_1_experiment_si_r() == "TLS") { initiate_data_reading( "tls", "TLS" ); experiment_data_r( tls_data ) }
  if (upload_modal_1_experiment_si_r() == "ESCR") { initiate_data_reading( "escr", "ESCR" ); experiment_data_r( escr_data ) }
  if (upload_modal_1_experiment_si_r() == "GCMS") { initiate_data_reading( "gcms", "GCMS" ); experiment_data_r( gcms_data ) }
  
  removeModal()
  
  if (upload_modal_1_experiment_si_r() == "") {
    
    showNotification( "Please select an experiment!" )
    
    show_upload_modal_1( upload_modal_1_experiment_si_r() )
    
  } else {
    
    show_upload_modal_2()
    
  }
  
})

# Modal 1 dismiss button.

observeEvent( input$upload_modal_1_dismiss, {
  
  if (is.null( upload_modal_1_experiment_si_r() ) || upload_modal_1_experiment_si_r() == "") {
    
    showNotification( "Please select an experiment!" )
    
  }
  
})

# Updating text output.

output$upload_experiment_to <- renderText({
  
  req( !is.null( upload_modal_1_experiment_si_r() ) && upload_modal_1_experiment_si_r() != "" )
  
  paste0( "You are uploading data for: ", upload_modal_1_experiment_si_r() )
  
})

# Assigning files to reactive value and then opening modal 3.

files_to_upload <- reactiveVal()

observeEvent( input$upload_fi, {
  
  files_to_upload( input$upload_fi )
  
  show_upload_modal_3()
  
})

# Modal 2 back button.

observeEvent( input$upload_modal_2_back, {
  
  show_upload_modal_1( upload_modal_1_experiment_si_r() )
  
})

# Modal 2 continue button.

observeEvent( input$upload_modal_2_continue, {
  
  if (is.null( files_to_upload() )) {
    
    showNotification( "Please select files to upload!" )
    
    show_upload_modal_2()
    
  } else {
    
    show_upload_modal_3()
    
  }
  
})

# Modal 3 back button.

observeEvent( input$upload_modal_3_back, {
  
  show_upload_modal_2()
  
})

# Modal 3 continue button.

observeEvent( input$upload_modal_3_continue, {
  
  show_upload_modal_4( upload_modal_4_new_or_existing_resin_rb_r(), upload_modal_4_cb_r(), upload_modal_4_identifier_ni_r(), upload_modal_4_identifier_si_r() )
  
})

# Open modal 4 when change metadata button clicked.

observeEvent( input$upload_change_metadata_ab, {
  
  if (is.null( files_to_upload() )) {
    
    showNotification( "Please select files to upload!" )
    
  }
  
  req( !is.null( files_to_upload() ) )
  
  show_upload_modal_4( upload_modal_4_new_or_existing_resin_rb_r(), upload_modal_4_cb_r(), upload_modal_4_identifier_ni_r(), upload_modal_4_identifier_si_r() )
  
})

# Work out next resin identifier if asked to.

observeEvent( input$upload_modal_4_suggested_resin_identifier_cb, {
  
  if (input$upload_modal_4_suggested_resin_identifier_cb) {
    
    suggested_resin_identifer <- max( resin_data_r()$Identifier ) + 1
    
    if (suggested_resin_identifer < 1001) suggested_resin_identifer <- 1001
    
    updateNumericInput( inputId = "upload_modal_4_identifier_ni", value = suggested_resin_identifer )
    
  }
  
  else {
    
    updateNumericInput( inputId = "upload_modal_4_identifier_ni", value = "" )
    
  }
  
})

# Actions when switching between new resin and existing resin.

observeEvent( input$upload_modal_4_new_or_existing_resin_rb, {
  
  if (input$upload_modal_4_new_or_existing_resin_rb == "New resin") {
    
    upload_modal_5_name_ti_r( NULL )
    upload_modal_5_type_si_r( NULL )
    upload_modal_5_label_ti_r( NULL )
    
  }
  
})

# Modal 4 back button.

observeEvent( input$upload_modal_4_back, {
  
  show_upload_modal_3()
  
})

# Modal 4 continue button.

upload_resin_identifier <- reactiveVal()

observeEvent( input$upload_modal_4_continue, {
  
  upload_modal_4_iv$enable()
  
  req( upload_modal_4_iv$is_valid() )
  
  upload_modal_4_iv$disable()
  
  if (input$upload_modal_4_new_or_existing_resin_rb == "New resin") {
    
    upload_modal_4_ni_iv$enable()
    
    req( upload_modal_4_ni_iv$is_valid() )
    
  } else if (input$upload_modal_4_new_or_existing_resin_rb == "Existing resin") {
    
    upload_modal_4_si_iv$enable()
    
    req( upload_modal_4_si_iv$is_valid() )
    
  }
  
  upload_modal_4_ni_iv$disable()
  upload_modal_4_si_iv$disable()
  
  removeModal()
  
  upload_modal_4_new_or_existing_resin_rb_r( input$upload_modal_4_new_or_existing_resin_rb )
  upload_modal_4_cb_r( input$upload_modal_4_suggested_resin_identifier_cb )
  upload_modal_4_identifier_ni_r( input$upload_modal_4_identifier_ni )
  upload_modal_4_identifier_si_r( input$upload_modal_4_identifier_si )
  
  if (input$upload_modal_4_new_or_existing_resin_rb == "New resin") upload_resin_identifier( upload_modal_4_identifier_ni_r() )
  
  if (input$upload_modal_4_new_or_existing_resin_rb == "Existing resin") {
    
    upload_resin_identifier( as.integer( upload_modal_4_identifier_si_r() ) )
    upload_modal_5_name_ti_r( resin_data_r()$Name[match( upload_resin_identifier(), resin_data_r()$Identifier )] )
    upload_modal_5_type_si_r( resin_data_r()$Class[match( upload_resin_identifier(), resin_data_r()$Identifier )] )
    upload_modal_5_label_ti_r( resin_data_r()$Label[match( upload_resin_identifier(), resin_data_r()$Identifier )] )
    
  }
  
  show_upload_modal_5( upload_modal_5_name_ti_r(), upload_modal_5_type_si_r(), upload_modal_5_cb_r(), upload_modal_5_label_ti_r() )
  
})

# Suggest the resin label if asked to.

observeEvent( input$upload_modal_5_suggested_resin_label_cb, {
  
  if (input$upload_modal_5_suggested_resin_label_cb) {
    
    if (upload_modal_4_new_or_existing_resin_rb_r() != "Existing resin") updateTextInput( inputId = "upload_modal_5_label_ti", value = paste( "PCR", upload_resin_identifier() ) )
    
  } else {
    
    if (upload_modal_4_new_or_existing_resin_rb_r() != "Existing resin") updateTextInput( inputId = "upload_modal_5_label_ti", value = "" )
    
  }
  
})

observeEvent( upload_resin_identifier(), {
  
  if (is.null( upload_resin_identifier() )) {
    
    upload_modal_5_label_ti_r( NULL )
    
  } else {
    
    if (upload_modal_4_new_or_existing_resin_rb_r() != "Existing resin") {
      
      if (!is.null( upload_modal_5_cb_r() )) {
        
        if (upload_modal_5_cb_r()) { updateTextInput( inputId = "upload_modal_5_label_ti", value = paste( "PCR", upload_resin_identifier() ) ); upload_modal_5_label_ti_r( paste( "PCR", upload_resin_identifier() ) ) }
        if (!upload_modal_5_cb_r()) { updateTextInput( inputId = "upload_modal_5_label_ti", value = "" ); upload_modal_5_label_ti_r( NULL ) }
        
      } else {
        
        upload_modal_5_label_ti_r( NULL )
        
      }
      
    }
    
  }
  
}, ignoreNULL = FALSE )

# Modal 5 back button.

observeEvent( input$upload_modal_5_back, {
  
  show_upload_modal_4( upload_modal_4_new_or_existing_resin_rb_r(), upload_modal_4_cb_r(), upload_modal_4_identifier_ni_r(), upload_modal_4_identifier_si_r() )
  
})

# Modal 5 continue button.

observeEvent( input$upload_modal_5_continue, {
  
  upload_modal_5_name_iv$enable()
  upload_modal_5_label_iv$enable()
  
  req( upload_modal_5_name_iv$is_valid() )
  req( upload_modal_5_label_iv$is_valid() )
  
  upload_modal_5_name_iv$disable()
  upload_modal_5_label_iv$disable()
  
  removeModal()
  
  upload_modal_5_name_ti_r( input$upload_modal_5_name_ti )
  upload_modal_5_type_si_r( input$upload_modal_5_type_si )
  upload_modal_5_cb_r( input$upload_modal_5_suggested_resin_label_cb )
  upload_modal_5_label_ti_r( input$upload_modal_5_label_ti )
  
  show_upload_modal_6()
  
})

# Modal 6 back button.

observeEvent( input$upload_modal_6_back, {
  
  show_upload_modal_5( upload_modal_5_name_ti_r(), upload_modal_5_type_si_r(), upload_modal_5_cb_r(), upload_modal_5_label_ti_r() )
  
})

# Increment run_upload reactive value if either of upload buttons are clicked.

run_upload <- reactiveVal( 0 )

observeEvent( input$upload_modal_6_itb, {
  
  run_upload( run_upload() + 1 )
  
})

observeEvent( input$upload_itb, {
  
  run_upload( run_upload() + 1 )
  
})

# Update and render table output.

table_of_uploaded_data <- reactive({
  
  req( !is.null( files_to_upload() ) )
  
  table <- files_to_upload() %>% select( "name" )
  
  max_existing_specimen <- -1
  
  if (length( isolate( upload_modal_4_new_or_existing_resin_rb_r() ) ) != 0 && isolate( upload_modal_4_new_or_existing_resin_rb_r() ) == "Existing resin" && !is.null( upload_resin_identifier() ) && length( which( experiment_data_r()$file_data$Resin == upload_resin_identifier() ) ) > 0 ) max_existing_specimen <- experiment_data_r()$file_data$Specimen[which( experiment_data_r()$file_data$Resin == upload_resin_identifier() )] %>% max()
  
  table$UploadedAs <- unlist( lapply( (max_existing_specimen + 1):(max_existing_specimen + nrow( table )), function( x ) paste0( "Resin", as.character( upload_resin_identifier() ), "_", as.character( x ), "_" ) ) )
  
  table$Resin <- unlist( lapply( (max_existing_specimen + 1):(max_existing_specimen + nrow( table )), function( x ) {
    
    if (is.null( upload_resin_identifier() )) { return( NA )
    } else return( upload_resin_identifier() )
    
  }) )
  
  table$Specimen <- unlist( lapply( (max_existing_specimen + 1):(max_existing_specimen + nrow( table )), function( x ) x ) )
  
  table
  
})

output$upload_info_to <- renderTable({
  
  table <- table_of_uploaded_data()[, c( 1, 3, 4 )]
  
  names( table ) <- c( "Filename", "Assigned Resin Identifier", "Assigned Specimen Number" )
  
  table
  
})

# Upload the files.

observeEvent( run_upload(), {
  
  if (current_dataset() == "") showNotification( "The original dataset version cannot be modified. Create a new dataset version or select a different dataset version in Settings." )
  
  req( current_dataset() != "" )
  
  if (is.null( files_to_upload() )) showNotification( "Please select files to upload." )
  
  req( !is.null( files_to_upload() ) )
  
  if (is.null( upload_resin_identifier() )) showNotification( "Please select the resin identifier." )
  
  req( !is.null( upload_resin_identifier() ) )
  
  if (is.null( upload_modal_5_name_ti_r() ) || upload_modal_5_name_ti_r() == "") showNotification( "Please provide a resin name." )
  
  req( !is.null( upload_modal_5_name_ti_r() ) && upload_modal_5_name_ti_r() != "" )
  
  if (is.null( upload_modal_5_label_ti_r() ) || upload_modal_5_label_ti_r() == "") showNotification( "Please provide a resin label." )
  
  req( !is.null( upload_modal_5_label_ti_r() ) && upload_modal_5_label_ti_r() != "" )
  
  if (upload_modal_4_new_or_existing_resin_rb_r() == "New resin") {
    
    resin_data_r( resin_data_r() %>% add_row( Identifier = upload_resin_identifier(), Name = upload_modal_5_name_ti_r(), Label = upload_modal_5_label_ti_r(), Class = upload_modal_5_type_si_r(), (!!as.name( upload_modal_1_experiment_si_r() )) := 1 ) )
    
  } else if (upload_modal_4_new_or_existing_resin_rb_r() == "Existing resin") {
    
    experiment_exists_for_resin <- resin_data_r()[[upload_modal_1_experiment_si_r()]][match( upload_resin_identifier(), resin_data_r()$Identifier )]
    
    if (is.na( experiment_exists_for_resin ) || experiment_exists_for_resin == 0) {
      
      df <- resin_data_r()
      
      df[[upload_modal_1_experiment_si_r()]][match( upload_resin_identifier(), df$Identifier )] <- 1
      
      resin_data_r( df )
      
    }
    
  }
  
  write_xlsx( resin_data_r(), paste0( directory, "List_of_Resins", current_dataset(), ".xlsx" ) )

  initial_files$save <- TRUE

  if (upload_modal_1_experiment_si_r() == "FTIR") {

    for (i in 1:nrow( table_of_uploaded_data() )) {

      read_file <- FTIR_Analysis$Preprocessing$read_shiny_file( ftir_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )

      ftir_data$data[[2]][[2]] <- append( ftir_data$data[[2]][[2]], read_file[[2]][[2]] )
      ftir_data$data[[1]] <- append( ftir_data$data[[1]], read_file[[1]] )

    }

    write_ftir_data( ftir_input_parameters, current_dataset, ftir_data )

    ftir_data$save <- TRUE
    ftir_data$compute_features <- TRUE

    update_data_minus_hidden_ftir( ftir_input_parameters, current_dataset, ftir_data )

  }
  
  if (upload_modal_1_experiment_si_r() == "DSC") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- DSC_Analysis$Preprocessing$read_shiny_file( dsc_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      dsc_data$data[[2]][[2]] <- append( dsc_data$data[[2]][[2]], read_file[[2]][[2]] )
      dsc_data$data[[2]][[4]] <- append( dsc_data$data[[2]][[4]], read_file[[2]][[4]] )
      dsc_data$data[[1]] <- append( dsc_data$data[[1]], read_file[[1]] )
      
    }
    
    write_dsc_data( dsc_input_parameters, current_dataset, dsc_data )
    
    dsc_data$save <- TRUE
    dsc_data$compute_features <- TRUE
    
    update_data_minus_hidden_dsc( dsc_input_parameters, current_dataset, dsc_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "TGA") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- TGA_Analysis$Preprocessing$read_shiny_file( tga_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      tga_data$data[[2]][[1]] <- append( tga_data$data[[2]][[1]], read_file[[2]][[1]] )
      tga_data$data[[2]][[3]] <- append( tga_data$data[[2]][[3]], read_file[[2]][[3]] )
      tga_data$data[[2]][[4]] <- append( tga_data$data[[2]][[4]], read_file[[2]][[4]] )
      tga_data$data[[2]][[5]] <- append( tga_data$data[[2]][[5]], read_file[[2]][[5]] )
      tga_data$data[[1]] <- append( tga_data$data[[1]], read_file[[1]] )
      
    }
    
    write_tga_data( tga_input_parameters, current_dataset, tga_data )
    
    tga_data$save <- TRUE
    tga_data$compute_features <- TRUE
    
    update_data_minus_hidden_tga( tga_input_parameters, current_dataset, tga_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "Rheology") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- Rheology_Analysis$Preprocessing$read_shiny_file( rheo_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      rheo_data$data[[2]][[2]] <- append( rheo_data$data[[2]][[2]], read_file[[2]][[2]] )
      rheo_data$data[[2]][[3]] <- append( rheo_data$data[[2]][[3]], read_file[[2]][[3]] )
      rheo_data$data[[2]][[4]] <- append( rheo_data$data[[2]][[4]], read_file[[2]][[4]] )
      rheo_data$data[[2]][[5]] <- append( rheo_data$data[[2]][[5]], read_file[[2]][[5]] )
      rheo_data$data[[1]] <- append( rheo_data$data[[1]], read_file[[1]] )
      
    }
    
    write_rheo_data( rheo_input_parameters, current_dataset, rheo_data )
    
    rheo_data$save <- TRUE
    rheo_data$compute_features <- TRUE
    
    update_data_minus_hidden_rheo( rheo_input_parameters, current_dataset, rheo_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "Colour") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- Colour_Analysis$Preprocessing$read_shiny_file( colour_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      print( class( colour_data$data[[2]][[1]]))
      print( class( read_file[[2]][[1]]))
      
      colour_data$data[[2]][[1]] <- array( append( colour_data$data[[2]][[1]], read_file[[2]][[1]] ) )
      colour_data$data[[2]][[2]] <- array( append( colour_data$data[[2]][[2]], read_file[[2]][[2]] ) )
      colour_data$data[[2]][[3]] <- array( append( colour_data$data[[2]][[3]], read_file[[2]][[3]] ) )
      colour_data$data[[1]] <- append( colour_data$data[[1]], read_file[[1]] )
      
      print( class( colour_data$data[[2]][[1]]))
      
    }
    
    write_colour_data( colour_input_parameters, current_dataset, colour_data )
    
    colour_data$save <- TRUE
    colour_data$compute_features <- TRUE
    
    update_data_minus_hidden_colour( colour_input_parameters, current_dataset, colour_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "TT") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- TT_Analysis$Preprocessing$read_shiny_file( tt_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      for (i in 1:length( tt_data$data[[2]] )) {
        
        tt_data$data[[2]][[i]] <- append( tt_data$data[[2]][[i]], read_file[[2]][[i]] )
        
      }
      
      tt_data$data[[1]] <- append( tt_data$data[[1]], read_file[[1]] )
      
    }
    
    write_tt_data( tt_input_parameters, current_dataset, tt_data )
    
    tt_data$save <- TRUE
    tt_data$compute_features <- TRUE
    
    update_data_minus_hidden_tt( tt_input_parameters, current_dataset, tt_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "SHM") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- SHM_Analysis$Preprocessing$read_shiny_file( shm_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      shm_data$data[[2]][[1]] <- append( shm_data$data[[2]][[1]], read_file[[2]][[1]] )
      shm_data$data[[2]][[2]] <- append( shm_data$data[[2]][[2]], read_file[[2]][[2]] )
      shm_data$data[[2]][[3]] <- append( shm_data$data[[2]][[3]], read_file[[2]][[3]] )
      shm_data$data[[1]] <- append( shm_data$data[[1]], read_file[[1]] )
      
    }
    
    write_shm_data( shm_input_parameters, current_dataset, shm_data )
    
    shm_data$save <- TRUE
    shm_data$compute_features <- TRUE
    
    update_data_minus_hidden_shm( shm_input_parameters, current_dataset, shm_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "TLS") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- TLS_Analysis$Preprocessing$read_shiny_file( tls_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      for (i in 1:length( tls_data$data[[2]] )) {
        
        tls_data$data[[2]][[i]] <- append( tls_data$data[[2]][[i]], read_file[[2]][[i]] )
        
      }
      
      tls_data$data[[1]] <- append( tls_data$data[[1]], read_file[[1]] )
      
    }
    
    write_tls_data( tls_input_parameters, current_dataset, tls_data )
    
    tls_data$save <- TRUE
    tls_data$compute_features <- TRUE
    
    update_data_minus_hidden_tls( tls_input_parameters, current_dataset, tls_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "ESCR") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- ESCR_Analysis$Preprocessing$read_shiny_file( escr_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      escr_data$data[[2]][[2]] <- append( escr_data$data[[2]][[2]], read_file[[2]][[2]] )
      escr_data$data[[1]] <- append( escr_data$data[[1]], read_file[[1]] )
      
    }
    
    write_escr_data( escr_input_parameters, current_dataset, escr_data )
    
    escr_data$save <- TRUE
    escr_data$compute_features <- TRUE
    
    update_data_minus_hidden_escr( escr_input_parameters, current_dataset, escr_data )
    
  }
  
  if (upload_modal_1_experiment_si_r() == "GCMS") {
    
    for (i in 1:nrow( table_of_uploaded_data() )) {
      
      read_file <- GCMS_Analysis$Preprocessing$read_shiny_file( gcms_input_parameters$directory, files_to_upload()$datapath[i], table_of_uploaded_data()$UploadedAs[[i]], current_dataset() )
      
      gcms_data$data[[2]][[2]] <- append( gcms_data$data[[2]][[2]], read_file[[2]][[2]] )
      gcms_data$data[[1]] <- append( gcms_data$data[[1]], read_file[[1]] )
      
    }
    
    write_gcms_data( gcms_input_parameters, current_dataset, gcms_data )
    
    gcms_data$save <- TRUE
    gcms_data$compute_features <- TRUE
    
    update_data_minus_hidden_gcms( gcms_input_parameters, current_dataset, gcms_data )
    
  }

  files_to_upload( NULL )
  upload_modal_1_experiment_si_r( NULL )
  upload_modal_4_new_or_existing_resin_rb_r( character( 0 ) )
  upload_modal_4_cb_r( FALSE )
  upload_resin_identifier( NULL )
  upload_modal_4_identifier_ni_r( NULL )
  upload_modal_4_identifier_si_r( NULL )
  upload_modal_5_name_ti_r( NULL )
  upload_modal_5_type_si_r( NULL )
  upload_modal_5_cb_r( FALSE )
  upload_modal_5_label_ti_r( NULL )
  
  showNotification( "Upload Complete!" )
  
  removeModal()
  
  perform_save_of_data()
  
}, ignoreInit = TRUE )