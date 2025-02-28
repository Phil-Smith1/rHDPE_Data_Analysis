#===============
# Code to output png.

# In UI:

imageOutput( "identifier" )

# In server:

output$identifier <- renderImage({
  
  obtain_data_to_plot_ftir() # Was here as this was the reactive dependency.
  
  list(
    src = file.path( "www/Output/FTIR/Plots/Plot.png" ), # Path to file to plot, I think shiny.io looks in the www folder.
    contentType = "image/png",
    width = 400,
    height = 400
  )
  
}, deleteFile = FALSE )

#===============
# Code to output pdf in a pdf viewer.

# In UI:

htmlOutput( "PCA" )

# In server:

output$PCA <- renderUI({
  
  input_parameters$datasets_to_read <- int_cb()
  
  input_parameters$pca = TRUE
  input_parameters$read_files = TRUE
  input_parameters$scatterplot = FALSE
  
  Global_Analysis$Analysis$Global_Analysis_Main( input_parameters )
  
  # # Key code below, the pdf must be saved in the www folder, but do not include www in the file path, see
  # https://stackoverflow.com/questions/68376905/r-shiny-pdf-display-is-blank
  
  tags$iframe( style = 'height: 650px; width: 500px;', src = "Output/Global/PCA/Overall.pdf" )
  
})

#===============
# Code, making use of shinyfilters, that links selectizeInputs to a reactable table so that the table can be filtered.

# In UI:

selectizeInput( inputId = "ftir_select_experiment_si", label = "Experiment", multiple = TRUE, options = list( onChange = event( "ftir_ev_click_vis" ) ), choices = c( "Unilever", "BGP" ) )

# In server:

define_filters_index <- -1 # An index so that filters do not need to be re-defined unless they have been changed elsewhere.

# Defining and updating the filters.

observeEvent( input$ftir_ev_click_vis, {

  if (define_filters_index != 0) {

    define_filters( input, "ftir_table_ro", c( ftir_select_experiment_si = "Obtained from" ), resin_data )
    define_filters_index <<- 0

  }

  ftir_resins_r$ftir_resins_r <- update_filters( input, session, "ftir_table_ro" ) %>% select( "Identifier", "Label", "Name" )

})