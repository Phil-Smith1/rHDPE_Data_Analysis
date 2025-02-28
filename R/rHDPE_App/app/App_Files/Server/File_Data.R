# File data tab server code.

file_data_hidden <- reactiveVal( data.frame() )
file_data_minus_hidden <- reactiveVal( data.frame() )

assign_file_data_reactive_val <- function() {
  
  if (input$filedata_select_dataset_si == "FTIR") {
    
    initiate_data_reading( "ftir", "FTIR" )
      
    file_data_minus_hidden( ftir_data$file_data_minus_hidden )
    
    file_data_hidden( ftir_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "DSC") {
    
    initiate_data_reading( "dsc", "DSC" )
    
    file_data_minus_hidden( dsc_data$file_data_minus_hidden )
    
    file_data_hidden( dsc_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "TGA") {
    
    initiate_data_reading( "tga", "TGA" )
    
    file_data_minus_hidden( tga_data$file_data_minus_hidden )
    
    file_data_hidden( tga_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "Rheology") {
    
    initiate_data_reading( "rheo", "Rheology" )
    
    file_data_minus_hidden( rheo_data$file_data_minus_hidden )
    
    file_data_hidden( rheo_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "Colour") {
    
    initiate_data_reading( "colour", "Colour" )
    
    file_data_minus_hidden( colour_data$file_data_minus_hidden )
    
    file_data_hidden( colour_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "Tensile Testing") {
    
    initiate_data_reading( "tt", "Tensile Testing" )
    
    file_data_minus_hidden( tt_data$file_data_minus_hidden )
    
    file_data_hidden( tt_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "SHM") {
    
    initiate_data_reading( "shm", "SHM" )
    
    file_data_minus_hidden( shm_data$file_data_minus_hidden )
    
    file_data_hidden( shm_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "TLS") {
    
    initiate_data_reading( "tls", "TLS" )
    
    file_data_minus_hidden( tls_data$file_data_minus_hidden )
    
    file_data_hidden( tls_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "ESCR") {
    
    initiate_data_reading( "escr", "ESCR" )
    
    file_data_minus_hidden( escr_data$file_data_minus_hidden )
    
    file_data_hidden( escr_data$hidden )
    
  }
  
  if (input$filedata_select_dataset_si == "GCMS") {
    
    initiate_data_reading( "gcms", "GCMS" )
    
    file_data_minus_hidden( gcms_data$file_data_minus_hidden )
    
    file_data_hidden( gcms_data$hidden )
    
  }
  
}

observeEvent( input$filedata_select_dataset_si, {
  
  assign_file_data_reactive_val()
  
}, ignoreInit = TRUE )

output$filedata_minus_hidden_ro <- renderReactable({
  
  req( nrow( file_data_minus_hidden() ) > 0 )
  
  reactable( data = file_data_minus_hidden(), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE )
  
})

output$filedata_hidden_entries_ro <- renderReactable({
  
  validate( need( nrow( file_data_hidden() ) > 0, "No data entries are hidden." ) )
  
  reactable( data = file_data_hidden(), filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE )
  
})

observeEvent( input$filedata_hide_ab, {
  
  if (length( getReactableState( "filedata_minus_hidden_ro", "selected" ) ) > 0) {
    
    if (nrow( file_data_hidden() ) == 0) {
      
      file_data_hidden( file_data_minus_hidden()[getReactableState( "filedata_minus_hidden_ro", "selected" ),] )
      
    } else {
      
      file_data_hidden( rbind( file_data_hidden(), file_data_minus_hidden()[getReactableState( "filedata_minus_hidden_ro", "selected" ),] ) )
      
    }
    
    file_data_minus_hidden( file_data_minus_hidden()[-getReactableState( "filedata_minus_hidden_ro", "selected" ),] )
    
  }
  
})

observeEvent( input$filedata_unhide_ab, {
  
  if (length( getReactableState( "filedata_hidden_entries_ro", "selected" ) ) > 0) {
    
    df <- rbind( file_data_minus_hidden(), file_data_hidden()[getReactableState( "filedata_hidden_entries_ro", "selected" ),] )
    
    file_data_minus_hidden( df[order( as.numeric( row.names( df ) ) ),] )
    
    file_data_hidden( file_data_hidden()[-getReactableState( "filedata_hidden_entries_ro", "selected" ),] )
    
  }
  
})

observeEvent( file_data_hidden(), {
  
  if (input$filedata_select_dataset_si == "FTIR") {
    
    ftir_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_ftir( ftir_input_parameters, current_dataset, ftir_data )
    
  }
  
  if (input$filedata_select_dataset_si == "DSC") {
    
    dsc_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_dsc( dsc_input_parameters, current_dataset, dsc_data )
    
  }
  
  if (input$filedata_select_dataset_si == "TGA") {
    
    tga_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_tga( tga_input_parameters, current_dataset, tga_data )
    
  }
  
  if (input$filedata_select_dataset_si == "Rheology") {
    
    rheo_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_rheo( rheo_input_parameters, current_dataset, rheo_data )
    
  }
  
  if (input$filedata_select_dataset_si == "Colour") {
    
    colour_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_colour( colour_input_parameters, current_dataset, colour_data )
    
  }
  
  if (input$filedata_select_dataset_si == "Tensile Testing") {
    
    tt_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_tt( tt_input_parameters, current_dataset, tt_data )
    
  }
  
  if (input$filedata_select_dataset_si == "SHM") {
    
    shm_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_shm( shm_input_parameters, current_dataset, shm_data )
    
  }
  
  if (input$filedata_select_dataset_si == "TLS") {
    
    tls_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_tls( tls_input_parameters, current_dataset, tls_data )
    
  }
  
  if (input$filedata_select_dataset_si == "ESCR") {
    
    escr_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_escr( escr_input_parameters, current_dataset, escr_data )
    
  }
  
  if (input$filedata_select_dataset_si == "GCMS") {
    
    gcms_data$hidden <- file_data_hidden()
    
    update_data_minus_hidden_gcms( gcms_input_parameters, current_dataset, gcms_data )
    
  }
  
}, ignoreInit = TRUE )

observeEvent( input$filedata_delete_data_ab, {
  
  if (current_dataset() == "") showNotification( "Cannot make changes to the original dataset. To delete data, first create a copy of the original dataset and delete your chosen data from that dataset." )

  req( current_dataset() != "")

  to_delete <- as.numeric( c( rownames( file_data_minus_hidden()[getReactableState( "filedata_minus_hidden_ro", "selected" ),] ), rownames( file_data_hidden()[getReactableState( "filedata_hidden_entries_ro", "selected" ),] ) ) )

  if (length( to_delete ) > 0) {
    
    if (input$filedata_select_dataset_si == "FTIR") {
      
      ftir_data$file_data <- ftir_data$file_data[-to_delete,]
      ftir_data$data[[1]] <- ftir_data$data[[1]][-to_delete]
      ftir_data$data[[2]][[2]] <- ftir_data$data[[2]][[2]][-to_delete]
      
      write_ftir_data( ftir_input_parameters, current_dataset, ftir_data )
      
      ftir_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "DSC") {
      
      dsc_data$file_data <- dsc_data$file_data[-to_delete,]
      dsc_data$data[[1]] <- dsc_data$data[[1]][-to_delete]
      dsc_data$data[[2]][[2]] <- dsc_data$data[[2]][[2]][-to_delete]
      dsc_data$data[[2]][[4]] <- dsc_data$data[[2]][[4]][-to_delete]
      
      write_dsc_data( dsc_input_parameters, current_dataset, dsc_data )
      
      dsc_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "TGA") {
      
      tga_data$file_data <- tga_data$file_data[-to_delete,]
      tga_data$data[[1]] <- tga_data$data[[1]][-to_delete]
      tga_data$data[[2]][[1]] <- tga_data$data[[2]][[1]][-to_delete]
      tga_data$data[[2]][[3]] <- tga_data$data[[2]][[3]][-to_delete]
      tga_data$data[[2]][[4]] <- tga_data$data[[2]][[4]][-to_delete]
      tga_data$data[[2]][[5]] <- tga_data$data[[2]][[5]][-to_delete]
      
      write_tga_data( tga_input_parameters, current_dataset, tga_data )
      
      tga_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "Rheology") {
      
      rheo_data$file_data <- rheo_data$file_data[-to_delete,]
      rheo_data$data[[1]] <- rheo_data$data[[1]][-to_delete]
      rheo_data$data[[2]][[2]] <- rheo_data$data[[2]][[2]][-to_delete]
      rheo_data$data[[2]][[3]] <- rheo_data$data[[2]][[3]][-to_delete]
      rheo_data$data[[2]][[4]] <- rheo_data$data[[2]][[4]][-to_delete]
      rheo_data$data[[2]][[5]] <- rheo_data$data[[2]][[5]][-to_delete]
      
      write_rheo_data( rheo_input_parameters, current_dataset, rheo_data )
      
      rheo_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "Colour") {
      
      colour_data$file_data <- colour_data$file_data[-to_delete,]
      colour_data$data[[1]] <- colour_data$data[[1]][-to_delete]
      colour_data$data[[2]][[1]] <- colour_data$data[[2]][[1]][-to_delete]
      colour_data$data[[2]][[2]] <- colour_data$data[[2]][[2]][-to_delete]
      colour_data$data[[2]][[3]] <- colour_data$data[[2]][[3]][-to_delete]
      
      write_colour_data( colour_input_parameters, current_dataset, colour_data )
      
      colour_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "Tensile Testing") {
      
      tt_data$file_data <- tt_data$file_data[-to_delete,]
      tt_data$data[[1]] <- tt_data$data[[1]][-to_delete]
      
      for (i in 1:length( tt_data$data[[2]] )) {
        
        tt_data$data[[2]][[i]] <- tt_data$data[[2]][[i]][-to_delete]
        
      }
      
      write_tt_data( tt_input_parameters, current_dataset, tt_data )
      
      tt_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "SHM") {
      
      shm_data$file_data <- shm_data$file_data[-to_delete,]
      shm_data$data[[1]] <- shm_data$data[[1]][-to_delete]
      shm_data$data[[2]][[1]] <- shm_data$data[[2]][[1]][-to_delete]
      shm_data$data[[2]][[2]] <- shm_data$data[[2]][[2]][-to_delete]
      shm_data$data[[2]][[3]] <- shm_data$data[[2]][[3]][-to_delete]
      
      write_shm_data( shm_input_parameters, current_dataset, shm_data )
      
      shm_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "TLS") {
      
      tls_data$file_data <- tls_data$file_data[-to_delete,]
      tls_data$data[[1]] <- tls_data$data[[1]][-to_delete]
      
      for (i in 1:length( tls_data$data[[2]] )) {
        
        tls_data$data[[2]][[i]] <- tls_data$data[[2]][[i]][-to_delete]
        
      }
      
      write_tls_data( tls_input_parameters, current_dataset, tls_data )
      
      tls_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "ESCR") {
      
      escr_data$file_data <- escr_data$file_data[-to_delete,]
      escr_data$data[[1]] <- escr_data$data[[1]][-to_delete]
      escr_data$data[[2]][[2]] <- escr_data$data[[2]][[2]][-to_delete]
      
      write_escr_data( escr_input_parameters, current_dataset, escr_data )
      
      escr_data$save <- TRUE
      
    }
    
    if (input$filedata_select_dataset_si == "GCMS") {
      
      gcms_data$file_data <- gcms_data$file_data[-to_delete,]
      gcms_data$data[[1]] <- gcms_data$data[[1]][-to_delete]
      gcms_data$data[[2]][[2]] <- gcms_data$data[[2]][[2]][-to_delete]
      
      write_gcms_data( gcms_input_parameters, current_dataset, gcms_data )
      
      gcms_data$save <- TRUE
      
    }
    
    if (nrow( file_data_minus_hidden() ) > 0) {
      
      df <- file_data_minus_hidden()
      
      if (length( getReactableState( "filedata_minus_hidden_ro", "selected" ) ) > 0) {
        
        df <- df[-getReactableState( "filedata_minus_hidden_ro", "selected" ),]
        
      }
      
      rownames( df ) <- lapply( as.numeric( rownames( df ) ), function( x ) {x - sum( to_delete < x )} )
      
      file_data_minus_hidden( df )
      
    }
    
    hidden_invalidated <- FALSE
    
    if (nrow( file_data_hidden() ) > 0) {
      
      df <- file_data_hidden()
      
      if (length( getReactableState( "filedata_hidden_entries_ro", "selected" ) ) > 0) {
        
        df <- df[-getReactableState( "filedata_hidden_entries_ro", "selected" ),]
        
      }
      
      rownames( df ) <- lapply( as.numeric( rownames( df ) ), function( x ) {x - sum( to_delete < x )} )
      
      if (!identical( file_data_hidden(), df )) hidden_invalidated <- TRUE
      
      file_data_hidden( df )
      
    }
    
    if (!hidden_invalidated) {
      
      if (input$filedata_select_dataset_si == "FTIR") {
        
        update_data_minus_hidden_ftir( ftir_input_parameters, current_dataset, ftir_data )
        
      }
      
      if (input$filedata_select_dataset_si == "DSC") {
        
        update_data_minus_hidden_dsc( dsc_input_parameters, current_dataset, dsc_data )
        
      }
      
      if (input$filedata_select_dataset_si == "TGA") {
        
        update_data_minus_hidden_tga( tga_input_parameters, current_dataset, tga_data )
        
      }
      
      if (input$filedata_select_dataset_si == "Rheology") {
        
        update_data_minus_hidden_rheo( rheo_input_parameters, current_dataset, rheo_data )
        
      }
      
      if (input$filedata_select_dataset_si == "Colour") {
        
        update_data_minus_hidden_colour( colour_input_parameters, current_dataset, colour_data )
        
      }
      
      if (input$filedata_select_dataset_si == "Tensile Testing") {
        
        update_data_minus_hidden_tt( tt_input_parameters, current_dataset, tt_data )
        
      }
      
      if (input$filedata_select_dataset_si == "SHM") {
        
        update_data_minus_hidden_shm( shm_input_parameters, current_dataset, shm_data )
        
      }
      
      if (input$filedata_select_dataset_si == "TLS") {
        
        update_data_minus_hidden_tls( tls_input_parameters, current_dataset, tls_data )
        
      }
      
      if (input$filedata_select_dataset_si == "ESCR") {
        
        update_data_minus_hidden_escr( escr_input_parameters, current_dataset, escr_data )
        
      }
      
      if (input$filedata_select_dataset_si == "GCMS") {
        
        update_data_minus_hidden_gcms( gcms_input_parameters, current_dataset, gcms_data )
        
      }
      
    }
    
  }
  
  df <- resin_data_r()
  
  if (input$filedata_select_dataset_si == "FTIR") {
  
    ftir_file_data_identifiers <- unique( ftir_data$file_data$Resin )
    ftir_identifiers <- resin_data_r() %>% filter( FTIR == 1 ) %>% pull( "Identifier" )
    
    for (i in ftir_identifiers) {
      
      if (!(i %in% ftir_file_data_identifiers)) {
        
        df$FTIR[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "DSC") {
    
    dsc_file_data_identifiers <- unique( dsc_data$file_data$Resin )
    dsc_identifiers <- resin_data_r() %>% filter( DSC == 1 ) %>% pull( "Identifier" )
    
    for (i in dsc_identifiers) {
      
      if (!(i %in% dsc_file_data_identifiers)) {
        
        df$DSC[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "TGA") {
    
    tga_file_data_identifiers <- unique( tga_data$file_data$Resin )
    tga_identifiers <- resin_data_r() %>% filter( TGA == 1 ) %>% pull( "Identifier" )
    
    for (i in tga_identifiers) {
      
      if (!(i %in% tga_file_data_identifiers)) {
        
        df$TGA[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "Rheology") {
    
    rheo_file_data_identifiers <- unique( rheo_data$file_data$Resin )
    rheo_identifiers <- resin_data_r() %>% filter( Rheology == 1 ) %>% pull( "Identifier" )
    
    for (i in rheo_identifiers) {
      
      if (!(i %in% rheo_file_data_identifiers)) {
        
        df$Rheology[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "Colour") {
    
    colour_file_data_identifiers <- unique( colour_data$file_data$Resin )
    colour_identifiers <- resin_data_r() %>% filter( Colour == 1 ) %>% pull( "Identifier" )
    
    for (i in colour_identifiers) {
      
      if (!(i %in% colour_file_data_identifiers)) {
        
        df$Colour[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "Tensile Testing") {
    
    tt_file_data_identifiers <- unique( tt_data$file_data$Resin )
    tt_identifiers <- resin_data_r() %>% filter( TT == 1 ) %>% pull( "Identifier" )
    
    for (i in tt_identifiers) {
      
      if (!(i %in% tt_file_data_identifiers)) {
        
        df$TT[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "SHM") {
    
    shm_file_data_identifiers <- unique( shm_data$file_data$Resin )
    shm_identifiers <- resin_data_r() %>% filter( SHM == 1 ) %>% pull( "Identifier" )
    
    for (i in shm_identifiers) {
      
      if (!(i %in% shm_file_data_identifiers)) {
        
        df$SHM[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "TLS") {
    
    tls_file_data_identifiers <- unique( tls_data$file_data$Resin )
    tls_identifiers <- resin_data_r() %>% filter( TLS == 1 ) %>% pull( "Identifier" )
    
    for (i in tls_identifiers) {
      
      if (!(i %in% tls_file_data_identifiers)) {
        
        df$TLS[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "ESCR") {
    
    escr_file_data_identifiers <- unique( escr_data$file_data$Resin )
    escr_identifiers <- resin_data_r() %>% filter( ESCR == 1 ) %>% pull( "Identifier" )
    
    for (i in escr_identifiers) {
      
      if (!(i %in% escr_file_data_identifiers)) {
        
        df$ESCR[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  if (input$filedata_select_dataset_si == "GCMS") {
    
    gcms_file_data_identifiers <- unique( gcms_data$file_data$Resin )
    gcms_identifiers <- resin_data_r() %>% filter( GCMS == 1 ) %>% pull( "Identifier" )
    
    for (i in gcms_identifiers) {
      
      if (!(i %in% gcms_file_data_identifiers)) {
        
        df$GCMS[df$Identifier == i] <- 0
        
      }
      
    }
    
  }
  
  df <- df %>% filter( !((FTIR != 1 | is.na( FTIR )) & (DSC != 1 | is.na( DSC )) & (TGA != 1 | is.na( TGA )) & (Rheology != 1 | is.na( Rheology )) & (Colour != 1 | is.na( Colour )) & (TT != 1 | is.na( TT ))
                        & (SHM != 1 | is.na( SHM )) & (TLS != 1 | is.na( TLS )) & (ESCR != 1 | is.na( ESCR )) & (GCMS != 1 | is.na( GCMS ))) )
  
  resin_data_r( df )
  
  write_xlsx( resin_data_r(), paste0( directory, "List_of_Resins", current_dataset(), ".xlsx" ) )
  
  initial_files$save <- TRUE
  
})

