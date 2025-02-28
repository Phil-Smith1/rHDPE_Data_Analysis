# Initiate data reading.

initiate_data_reading <- function( shortname, ui_name, notifications = TRUE ) {

  if (!get( paste0( shortname, "_data" ) )$download_data) {

    if (notifications) {

      showNotification( paste0( "Waiting for ", ui_name, " data to be imported, please wait a few moments." ) )

    }

  }

  else if (!get( paste0( shortname, "_data" ) )$read_data) {

    var <- get( paste0( shortname, "_data" ) )

    var$read_data <- TRUE

    assign( paste0( shortname, "_data" ), var )

    if (notifications) {

      showNotification( paste0( "Reading ", ui_name, " data." ) )

    }
    
    if (shortname == "global") {
      
      get( paste0( "read_", shortname, "_data" ) )( get( paste0( shortname, "_input_parameters" ) ), current_dataset, get( paste0( shortname, "_data" ) ), input$ESCRP_select_model_rb )
      
    } else {
      
      get( paste0( "read_", shortname, "_data" ) )( get( paste0( shortname, "_input_parameters" ) ), current_dataset, get( paste0( shortname, "_data" ) ) )
      
    }

    if (notifications) {

      showNotification( paste0( ui_name, " data has been read." ) )

    }

  }

}

observe({
  
  if (input$tabs_tp == "PP% Prediction (FTIR)") {
    
    isolate( initiate_data_reading( "ftir", "FTIR" ) )
    
  }
  
  if (input$tabs_tp == "ESCR Prediction") {
    
    isolate( initiate_data_reading( "global", "the" ) )
    
  }
  
  if (input$tabs_tp == "Data Visualisation") {
    
    if (input$visualisation_tp == "FTIR") {
      
      isolate( initiate_data_reading( "ftir", "FTIR" ) )
      
    }
    
    else if (input$visualisation_tp == "DSC") {
      
      isolate( initiate_data_reading( "dsc", "DSC" ) )
      
    }
    
    else if (input$visualisation_tp == "TGA") {
      
      isolate( initiate_data_reading( "tga", "TGA" ) )
      
    }
    
    else if (input$visualisation_tp == "Rheology") {
      
      isolate( initiate_data_reading( "rheo", "Rheology" ) )
      
    }
    
    else if (input$visualisation_tp == "Colour") {
      
      isolate( initiate_data_reading( "colour", "Colour" ) )
      
    }
    
    else if (input$visualisation_tp == "Tensile Testing") {
      
      isolate( initiate_data_reading( "tt", "Tensile Testing" ) )
      
    }
    
    else if (input$visualisation_tp == "SHM") {
      
      isolate( initiate_data_reading( "shm", "SHM" ) )
      
    }
    
    else if (input$visualisation_tp == "TLS") {
      
      isolate( initiate_data_reading( "tls", "TLS" ) )
      
    }
    
    else if (input$visualisation_tp == "ESCR") {
      
      isolate( initiate_data_reading( "escr", "ESCR" ) )
      
    }
    
    else if (input$visualisation_tp == "GCMS") {
      
      isolate( initiate_data_reading( "gcms", "GCMS" ) )
      
    }
    
  }
  
  else if (input$tabs_tp == "File Data") {
    
    isolate( assign_file_data_reactive_val() )
    
  }
  
})