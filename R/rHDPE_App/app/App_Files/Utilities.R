#===============
# File containing utility functions.

#===============
# Sources

if (app_user != "shiny") source( here::here( "DataLab_Files/DataLab_Utilities.R" ) ) # Load DataLab libraries and functions, but not if on shinyapps as some packages are stored only locally on DataLab.
source( here::here( "App_Files/GoogleDrive_Utilities.R" ) ) # File containing functions for interacting with Google Drive.
source( here::here( "App_Files/Read_and_Write_Data.R" ) ) # File containing the functions that read the data from a file, write data to a file, and other data related functions (regenerate, update hidden data, copy, delete).
source( here::here( "App_Files/Extended_Tasks.R" ) ) # File containing all extended tasks (downloading and saving data).

#===============
# Code

linebreaks <- function( n ) {HTML( strrep( br(), n ) )}

pp_analysis <- function( pp_percentages, s ) {
  
  select_specimens <- pp_percentages %>% filter( sample == s ) %>% select( -c( sample, Specimen ) ) # Filter pp_percentages dataframe by resin.
  
  specimen_pp_values <- (select_specimens %>% apply( 1, sum ) - select_specimens %>% apply( 1, max ) - select_specimens %>% apply( 1, min )) / (ncol( select_specimens ) - 2) # Compute prediction for each specimen.
  
  specimen_df <- data.frame( specimen_pp_values )
  specimen_df$Specimen <- pp_percentages %>% filter( sample == s ) %>% pull( Specimen )
  
  complete_values <- setNames( data.frame( select_specimens %>% unlist() ), "complete_values" )
  
  wavenumber_df <- setNames( data.frame( select_specimens %>% apply( 2, mean ) ), "wavenumber_pp_values" )
  wavenumber_df$Wavenumber <- names( select_specimens )
  
  select_specimens$specimen <- specimen_df$Specimen
  select_specimens_melt <- melt( select_specimens, id.vars = "specimen" )
  
  summary_data <- t( as.data.frame( apply( complete_values, 2, summary ) )[-4, , drop = FALSE] )
  
  # Compute overall PP percentage.
  
  pp_percentage <- 0
  
  if (length( specimen_pp_values ) >= 5) {
    
    pp_percentage <- (sum( specimen_pp_values ) - max( specimen_pp_values ) - min( specimen_pp_values )) / (length( specimen_pp_values ) - 2)
    
  } else {
    
    pp_percentage <- mean( specimen_pp_values )
    
  }
  
  return( list( pp_percentage, specimen_df, wavenumber_df, complete_values, summary_data, select_specimens_melt, select_specimens ) )
  
}

obtain_scatterplot_data_to_plot <- function( global_input_parameters, x_feature, y_feature, sample_mask ) {
  
  global_input_parameters$pca <- FALSE
  global_input_parameters$read_files <- FALSE
  global_input_parameters$scatterplot <- TRUE
  global_input_parameters$scatterplot_x <- x_feature
  global_input_parameters$scatterplot_y <- y_feature
  
  global_input_parameters$sample_mask <- sample_mask
  
  result <- Global_Analysis$Preprocessing$read_files_and_preprocess( global_input_parameters, c( 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 13L ), FALSE, TRUE, x_feature, y_feature )
  
  data_to_plot <- data.frame( Global_Analysis$Utilities$scatterplots( global_input_parameters, result[[1]], result[[2]] ) )
  
  # data_to_plot <- data.frame( Global_Analysis$Analysis$Global_Analysis_Main( global_input_parameters ) )
  
  data_to_plot$Resin <- as.integer( global_input_parameters$sample_mask )
  
  names( data_to_plot )[1] <- "X"
  names( data_to_plot )[2] <- "Y"
  names( data_to_plot )[3] <- "EX"
  names( data_to_plot )[4] <- "EY"
  
  data_to_plot
  
}

plot_pca <- function( input, data_to_plot, resin_data_r, title_str ) {
  
  resin_colours <- c()
  resin_names <- c()
  labels <- c()
  
  for (s in seq_along( data_to_plot[[1]][[5]] )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[data_to_plot[[1]][[5]][s] + 1,] ) )
    resin_names <- c( resin_names, data_to_plot[[1]][[5]][s] )
    labels <- c( labels, resin_data_r$Label[match( data_to_plot[[1]][[5]][s], resin_data_r$Identifier )] )
    
  }
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  g <- ggplot( data_to_plot[[1]], aes( x = X, y = Y, color = fct_inorder( as.factor( Resin ) ) ) )
  
  g <- g + labs( title = title_str, x = "PC 1", y = "PC 2" )
  
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
    
    g <- g + geom_point( data = data_to_plot[[2]], aes( x = X, y = Y ), size = 5, inherit.aes = FALSE )
    
    g <- g + geom_segment( data = data_to_plot[[2]], aes( xend = X, yend = Y ), x = 0, y = 0, inherit.aes = FALSE )
    
    g <- g + geom_label_repel( data = data_to_plot[[2]], aes( x = X, y = Y, label = Labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50', inherit.aes = FALSE )
    
  }
  
  g
  
}

