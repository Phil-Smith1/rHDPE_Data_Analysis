source( here::here( "App_Files/Read_Regenerate_Write.R" ) )
source( here::here( "App_Files/Extended_Tasks.R" ) )

linebreaks <- function( n ) {HTML( strrep( br(), n ) )}

pp_analysis <- function( pp_percentages, s ) {
  
  select_specimens <- pp_percentages %>% filter( sample == s ) %>% select( -sample ) # Filter pp_percentages dataframe by resin.
  
  specimen_pp_values <- (select_specimens %>% apply( 1, sum ) - select_specimens %>% apply( 1, max ) - select_specimens %>% apply( 1, min )) / (ncol( select_specimens ) - 2) # Compute prediction for each specimen.
  
  specimen_df <- data.frame( specimen_pp_values )
  specimen_df$Specimen <- c( 1:length( specimen_pp_values ) )
  
  complete_values <- setNames( data.frame( select_specimens %>% unlist() ), "complete_values" )
  
  wavenumber_df <- setNames( data.frame( select_specimens %>% apply( 2, mean ) ), "wavenumber_pp_values" )
  wavenumber_df$Wavenumber <- names( select_specimens )
  
  n <- nrow( select_specimens )
  select_specimens$specimen <- 1:n
  select_specimens_melt <- melt( select_specimens, id.vars = "specimen" )
  
  summary_data <- t( as.data.frame( apply( complete_values, 2, summary ) )[-4, , drop = FALSE] )
  
  # Compute overall PP percentage.
  
  pp_percentage <- 0
  
  if (length( specimen_pp_values ) >= 5) {
    
    pp_percentage <- (sum( specimen_pp_values ) - max( specimen_pp_values ) - min( specimen_pp_values )) / (length( specimen_pp_values ) - 2)
    
  } else {
    
    pp_percentage <- mean( specimen_pp_values )
    
  }
  
  return( list( pp_percentage, specimen_df, wavenumber_df, complete_values, summary_data, select_specimens_melt ) )
  
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

