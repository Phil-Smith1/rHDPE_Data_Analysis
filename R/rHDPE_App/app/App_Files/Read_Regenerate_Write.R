read_ftir_data <- function( ftir_input_parameters, current_dataset, ftir_data ) {
  
  ftir_data[["data"]] <- FTIR_Analysis$Preprocessing$read_csv( ftir_input_parameters$directory, ftir_input_parameters$output_directory, ftir_input_parameters$merge_groups, current_dataset() )
  
  ftir_data[["data"]] <- FTIR_Analysis$Preprocessing$remove_files( ftir_data$data[[1]], ftir_data$data[[2]], "nfrpd" )
  
  ftir_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( ftir_data$data[[1]], unlist ) ) )
  names( ftir_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  ftir_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  FTIR_Analysis$Preprocessing$compute_mean( ftir_input_parameters$output_directory, ftir_data$data[[1]], ftir_data$data[[2]], current_dataset() )
  
  ftir_data$data[[2]] <- FTIR_Analysis$Preprocessing$read_mean( ftir_input_parameters$output_directory, ftir_data$data[[2]], current_dataset() )
  
  FTIR_Analysis$Utilities$pp_percentage_model( ftir_input_parameters$directory, ftir_input_parameters$output_directory, ftir_data$data[[1]], ftir_data$data[[2]], current_dataset() )
  
  ftir_data[["PP_percentages"]] <- suppressMessages( read_csv( paste0( ftir_input_parameters$output_directory, "FTIR/Sandbox/PP_Percentage_Analysis/Features/PP_Predictions", current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
  ftir_data[["hidden"]] <- data.frame()
  ftir_data[["file_data_minus_hidden"]] <- ftir_data$file_data
  ftir_data[["data_minus_hidden"]] <- ftir_data$data
  
}

regenerate_ftir_data <- function( ftir_input_parameters, current_dataset, ftir_data ) {
  
  FTIR_Analysis$Preprocessing$compute_mean( ftir_input_parameters$output_directory, ftir_data$data_minus_hidden[[1]], ftir_data$data_minus_hidden[[2]], current_dataset() )
  
  ftir_data$data_minus_hidden[[2]] <- FTIR_Analysis$Preprocessing$read_mean( ftir_input_parameters$output_directory, ftir_data$data_minus_hidden[[2]], current_dataset() )
  
  FTIR_Analysis$Utilities$pp_percentage_model( ftir_input_parameters$directory, ftir_input_parameters$output_directory, ftir_data$data_minus_hidden[[1]], ftir_data$data_minus_hidden[[2]], current_dataset() )
  
  ftir_data$PP_percentages <- suppressMessages( read_csv( paste0( ftir_input_parameters$output_directory, "FTIR/Sandbox/PP_Percentage_Analysis/Features/PP_Predictions", current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
}

update_data_minus_hidden_ftir <- function( ftir_input_parameters, current_dataset, ftir_data ) {
  
  if (nrow( ftir_data$hidden ) == 0) {
    
    ftir_data$data_minus_hidden <- ftir_data$data
    ftir_data$file_data_minus_hidden <- ftir_data$file_data
    
  } else {
    
    ftir_data$data_minus_hidden[[1]] <- ftir_data$data[[1]][-as.numeric( rownames( ftir_data$hidden ) )]
    ftir_data$data_minus_hidden[[2]][[2]] <- ftir_data$data[[2]][[2]][-as.numeric( rownames( ftir_data$hidden ) )]
    ftir_data$file_data_minus_hidden <- ftir_data$file_data[-as.numeric( row.names( ftir_data$hidden ) ),]
    
  }
  
  regenerate_ftir_data( ftir_input_parameters, current_dataset, ftir_data )
  
  ftir_data$compute_features <- TRUE
  
}

copy_ftir_data <- function( ftir_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  FTIR_Analysis$Preprocessing$copy_data( ftir_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_ftir_data <- function( ftir_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  FTIR_Analysis$Preprocessing$delete_data( ftir_input_parameters$output_directory, current_dataset() )
  
}

write_ftir_data <- function( ftir_input_parameters, current_dataset, ftir_data ) {
  
  FTIR_Analysis$Preprocessing$write_csv( ftir_input_parameters$output_directory, ftir_data$data[[1]], ftir_data$data[[2]], current_dataset() )
  
  ftir_data$data <- FTIR_Analysis$Preprocessing$read_csv( ftir_input_parameters$directory, ftir_input_parameters$output_directory, ftir_input_parameters$merge_groups, current_dataset() )
  
  ftir_data$file_data <- as.data.frame( do.call( rbind, lapply( ftir_data$data[[1]], unlist ) ) )
  names( ftir_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  ftir_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_dsc_data <- function( dsc_input_parameters, current_dataset, dsc_data ) {
  
  dsc_data[["data"]] <- DSC_Analysis$Preprocessing$read_csv( dsc_input_parameters$directory, dsc_input_parameters$output_directory, dsc_input_parameters$merge_groups, current_dataset() )
  
  dsc_data[["data"]] <- DSC_Analysis$Preprocessing$remove_files( dsc_data$data[[1]], dsc_data$data[[2]], "aduz" )
  
  dsc_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( dsc_data$data[[1]], unlist ) ) )
  names( dsc_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  dsc_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  DSC_Analysis$Preprocessing$compute_mean( dsc_input_parameters$output_directory, dsc_data$data[[1]], dsc_data$data[[2]], current_dataset() )
  
  dsc_data$data[[2]] <- DSC_Analysis$Preprocessing$read_mean( dsc_input_parameters$output_directory, dsc_data$data[[2]], current_dataset() )
  
  dsc_data[["hidden"]] <- data.frame()
  dsc_data[["file_data_minus_hidden"]] <- dsc_data$file_data
  dsc_data[["data_minus_hidden"]] <- dsc_data$data
  
}

regenerate_dsc_data <- function( dsc_input_parameters, current_dataset, dsc_data ) {
  
  DSC_Analysis$Preprocessing$compute_mean( dsc_input_parameters$output_directory, dsc_data$data_minus_hidden[[1]], dsc_data$data_minus_hidden[[2]], current_dataset() )
  
  dsc_data$data_minus_hidden[[2]] <- DSC_Analysis$Preprocessing$read_mean( dsc_input_parameters$output_directory, dsc_data$data_minus_hidden[[2]], current_dataset() )
  
}

update_data_minus_hidden_dsc <- function( dsc_input_parameters, current_dataset, dsc_data ) {
  
  if (nrow( dsc_data$hidden ) == 0) {
    
    dsc_data$data_minus_hidden <- dsc_data$data
    dsc_data$file_data_minus_hidden <- dsc_data$file_data
    
  } else {
    
    dsc_data$data_minus_hidden[[1]] <- dsc_data$data[[1]][-as.numeric( rownames( dsc_data$hidden ) )]
    dsc_data$data_minus_hidden[[2]][[2]] <- dsc_data$data[[2]][[2]][-as.numeric( rownames( dsc_data$hidden ) )]
    dsc_data$data_minus_hidden[[2]][[4]] <- dsc_data$data[[2]][[4]][-as.numeric( rownames( dsc_data$hidden ) )]
    dsc_data$file_data_minus_hidden <- dsc_data$file_data[-as.numeric( row.names( dsc_data$hidden ) ),]
    
  }
  
  regenerate_dsc_data( dsc_input_parameters, current_dataset, dsc_data )
  
  dsc_data$compute_features <- TRUE
  
}

copy_dsc_data <- function( dsc_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  DSC_Analysis$Preprocessing$copy_data( dsc_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_dsc_data <- function( dsc_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  DSC_Analysis$Preprocessing$delete_data( dsc_input_parameters$output_directory, current_dataset() )
  
}

write_dsc_data <- function( dsc_input_parameters, current_dataset, dsc_data ) {
  
  DSC_Analysis$Preprocessing$write_csv( dsc_input_parameters$output_directory, dsc_data$data[[1]], dsc_data$data[[2]], current_dataset() )
  
  dsc_data$data <- DSC_Analysis$Preprocessing$read_csv( dsc_input_parameters$directory, dsc_input_parameters$output_directory, dsc_input_parameters$merge_groups, current_dataset() )
  
  dsc_data$file_data <- as.data.frame( do.call( rbind, lapply( dsc_data$data[[1]], unlist ) ) )
  names( dsc_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  dsc_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_tga_data <- function( tga_input_parameters, current_dataset, tga_data ) {
  
  tga_data[["data"]] <- TGA_Analysis$Preprocessing$read_csv( tga_input_parameters$directory, tga_input_parameters$output_directory, tga_input_parameters$merge_groups, current_dataset() )
  
  tga_data[["data"]] <- TGA_Analysis$Preprocessing$remove_files( tga_data$data[[1]], tga_data$data[[2]], "fs" )
  
  tga_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( tga_data$data[[1]], unlist ) ) )
  names( tga_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tga_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  TGA_Analysis$Preprocessing$compute_mean( tga_input_parameters$output_directory, tga_data$data[[1]], tga_data$data[[2]], current_dataset() )
  
  tga_data$data[[2]] <- TGA_Analysis$Preprocessing$read_mean( tga_input_parameters$output_directory, tga_data$data[[2]], current_dataset() )
  
  tga_data[["hidden"]] <- data.frame()
  tga_data[["file_data_minus_hidden"]] <- tga_data$file_data
  tga_data[["data_minus_hidden"]] <- tga_data$data
  
}

regenerate_tga_data <- function( tga_input_parameters, current_dataset, tga_data ) {
  
  TGA_Analysis$Preprocessing$compute_mean( tga_input_parameters$output_directory, tga_data$data_minus_hidden[[1]], tga_data$data_minus_hidden[[2]], current_dataset() )
  
  tga_data$data_minus_hidden[[2]] <- TGA_Analysis$Preprocessing$read_mean( tga_input_parameters$output_directory, tga_data$data_minus_hidden[[2]], current_dataset() )
  
}

update_data_minus_hidden_tga <- function( tga_input_parameters, current_dataset, tga_data ) {
  
  if (nrow( tga_data$hidden ) == 0) {
    
    tga_data$data_minus_hidden <- tga_data$data
    tga_data$file_data_minus_hidden <- tga_data$file_data
    
  } else {
    
    tga_data$data_minus_hidden[[1]] <- tga_data$data[[1]][-as.numeric( rownames( tga_data$hidden ) )]
    tga_data$data_minus_hidden[[2]][[1]] <- tga_data$data[[2]][[1]][-as.numeric( rownames( tga_data$hidden ) )]
    tga_data$data_minus_hidden[[2]][[3]] <- tga_data$data[[2]][[3]][-as.numeric( rownames( tga_data$hidden ) )]
    tga_data$data_minus_hidden[[2]][[4]] <- tga_data$data[[2]][[4]][-as.numeric( rownames( tga_data$hidden ) )]
    tga_data$data_minus_hidden[[2]][[5]] <- tga_data$data[[2]][[5]][-as.numeric( rownames( tga_data$hidden ) )]
    tga_data$file_data_minus_hidden <- tga_data$file_data[-as.numeric( row.names( tga_data$hidden ) ),]
    
  }
  
  regenerate_tga_data( tga_input_parameters, current_dataset, tga_data )
  
  tga_data$compute_features <- TRUE
  
}

copy_tga_data <- function( tga_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  TGA_Analysis$Preprocessing$copy_data( tga_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_tga_data <- function( tga_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  TGA_Analysis$Preprocessing$delete_data( tga_input_parameters$output_directory, current_dataset() )
  
}

write_tga_data <- function( tga_input_parameters, current_dataset, tga_data ) {
  
  delete_tga_data( tga_input_parameters, current_dataset )
  
  TGA_Analysis$Preprocessing$write_csv( tga_input_parameters$output_directory, tga_data$data[[1]], tga_data$data[[2]], current_dataset() )
  
  tga_data$data <- TGA_Analysis$Preprocessing$read_csv( tga_input_parameters$directory, tga_input_parameters$output_directory, tga_input_parameters$merge_groups, current_dataset() )
  
  tga_data$file_data <- as.data.frame( do.call( rbind, lapply( tga_data$data[[1]], unlist ) ) )
  names( tga_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tga_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_rheo_data <- function( rheo_input_parameters, current_dataset, rheo_data ) {
  
  rheo_data[["data"]] <- Rheology_Analysis$Preprocessing$read_csv( rheo_input_parameters$directory, rheo_input_parameters$output_directory, rheo_input_parameters$merge_groups, current_dataset() )
  
  rheo_data[["data"]] <- Rheology_Analysis$Preprocessing$remove_files( rheo_data$data[[1]], rheo_data$data[[2]], "" )
  
  rheo_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( rheo_data$data[[1]], unlist ) ) )
  names( rheo_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  rheo_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  Rheology_Analysis$Preprocessing$compute_mean( rheo_input_parameters$output_directory, rheo_data$data[[1]], rheo_data$data[[2]], current_dataset() )
  
  rheo_data$data[[2]] <- Rheology_Analysis$Preprocessing$read_mean( rheo_input_parameters$output_directory, rheo_data$data[[2]], current_dataset() )
  
  rheo_data[["hidden"]] <- data.frame()
  rheo_data[["file_data_minus_hidden"]] <- rheo_data$file_data
  rheo_data[["data_minus_hidden"]] <- rheo_data$data
  
}

regenerate_rheo_data <- function( rheo_input_parameters, current_dataset, rheo_data ) {
  
  Rheology_Analysis$Preprocessing$compute_mean( rheo_input_parameters$output_directory, rheo_data$data_minus_hidden[[1]], rheo_data$data_minus_hidden[[2]], current_dataset() )
  
  rheo_data$data_minus_hidden[[2]] <- Rheology_Analysis$Preprocessing$read_mean( rheo_input_parameters$output_directory, rheo_data$data_minus_hidden[[2]], current_dataset() )
  
}

update_data_minus_hidden_rheo <- function( rheo_input_parameters, current_dataset, rheo_data ) {
  
  if (nrow( rheo_data$hidden ) == 0) {
    
    rheo_data$data_minus_hidden <- rheo_data$data
    rheo_data$file_data_minus_hidden <- rheo_data$file_data
    
  } else {
    
    rheo_data$data_minus_hidden[[1]] <- rheo_data$data[[1]][-as.numeric( rownames( rheo_data$hidden ) )]
    rheo_data$data_minus_hidden[[2]][[2]] <- rheo_data$data[[2]][[2]][-as.numeric( rownames( rheo_data$hidden ) )]
    rheo_data$data_minus_hidden[[2]][[3]] <- rheo_data$data[[2]][[3]][-as.numeric( rownames( rheo_data$hidden ) )]
    rheo_data$data_minus_hidden[[2]][[4]] <- rheo_data$data[[2]][[4]][-as.numeric( rownames( rheo_data$hidden ) )]
    rheo_data$data_minus_hidden[[2]][[5]] <- rheo_data$data[[2]][[5]][-as.numeric( rownames( rheo_data$hidden ) )]
    rheo_data$file_data_minus_hidden <- rheo_data$file_data[-as.numeric( row.names( rheo_data$hidden ) ),]
    
  }
  
  regenerate_rheo_data( rheo_input_parameters, current_dataset, rheo_data )
  
  rheo_data$compute_features <- TRUE
  
}

copy_rheo_data <- function( rheo_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  Rheology_Analysis$Preprocessing$copy_data( rheo_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_rheo_data <- function( rheo_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  Rheology_Analysis$Preprocessing$delete_data( rheo_input_parameters$output_directory, current_dataset() )
  
}

write_rheo_data <- function( rheo_input_parameters, current_dataset, rheo_data ) {
  
  Rheology_Analysis$Preprocessing$write_csv( rheo_input_parameters$output_directory, rheo_data$data[[1]], rheo_data$data[[2]], current_dataset() )
  
  rheo_data$data <- Rheology_Analysis$Preprocessing$read_csv( rheo_input_parameters$directory, rheo_input_parameters$output_directory, rheo_input_parameters$merge_groups, current_dataset() )
  
  rheo_data$file_data <- as.data.frame( do.call( rbind, lapply( rheo_data$data[[1]], unlist ) ) )
  names( rheo_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  rheo_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_colour_data <- function( colour_input_parameters, current_dataset, colour_data ) {
  
  colour_data[["data"]] <- Colour_Analysis$Preprocessing$read_csv( colour_input_parameters$directory, colour_input_parameters$output_directory, colour_input_parameters$merge_groups, current_dataset() )
  
  colour_data[["data"]] <- Colour_Analysis$Preprocessing$remove_files( colour_data$data[[1]], colour_data$data[[2]], "" )
  
  colour_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( colour_data$data[[1]], unlist ) ) )
  names( colour_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  colour_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  Colour_Analysis$Preprocessing$compute_mean( colour_input_parameters$output_directory, colour_data$data[[1]], colour_data$data[[2]], current_dataset() )
  
  colour_data$data[[2]] <- Colour_Analysis$Preprocessing$read_mean( colour_input_parameters$output_directory, colour_data$data[[2]], current_dataset() )
  
  colour_data[["hidden"]] <- data.frame()
  colour_data[["file_data_minus_hidden"]] <- colour_data$file_data
  colour_data[["data_minus_hidden"]] <- colour_data$data
  
}

regenerate_colour_data <- function( colour_input_parameters, current_dataset, colour_data ) {
  
  Colour_Analysis$Preprocessing$compute_mean( colour_input_parameters$output_directory, colour_data$data_minus_hidden[[1]], colour_data$data_minus_hidden[[2]], current_dataset() )
  
  colour_data$data_minus_hidden[[2]] <- Colour_Analysis$Preprocessing$read_mean( colour_input_parameters$output_directory, colour_data$data_minus_hidden[[2]], current_dataset() )
  
}

update_data_minus_hidden_colour <- function( colour_input_parameters, current_dataset, colour_data ) {
  
  if (nrow( colour_data$hidden ) == 0) {
    
    colour_data$data_minus_hidden <- colour_data$data
    colour_data$file_data_minus_hidden <- colour_data$file_data
    
  } else {
    
    colour_data$data_minus_hidden[[1]] <- colour_data$data[[1]][-as.numeric( rownames( colour_data$hidden ) )]
    colour_data$data_minus_hidden[[2]][[1]] <- colour_data$data[[2]][[1]][-as.numeric( rownames( colour_data$hidden ) )]
    colour_data$data_minus_hidden[[2]][[2]] <- colour_data$data[[2]][[2]][-as.numeric( rownames( colour_data$hidden ) )]
    colour_data$data_minus_hidden[[2]][[3]] <- colour_data$data[[2]][[3]][-as.numeric( rownames( colour_data$hidden ) )]
    colour_data$file_data_minus_hidden <- colour_data$file_data[-as.numeric( row.names( colour_data$hidden ) ),]
    
  }
  
  regenerate_colour_data( colour_input_parameters, current_dataset, colour_data )
  
  colour_data$compute_features <- TRUE
  
}

copy_colour_data <- function( colour_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  Colour_Analysis$Preprocessing$copy_data( colour_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_colour_data <- function( colour_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  Colour_Analysis$Preprocessing$delete_data( colour_input_parameters$output_directory, current_dataset() )
  
}

write_colour_data <- function( colour_input_parameters, current_dataset, colour_data ) {
  
  Colour_Analysis$Preprocessing$write_csv( colour_input_parameters$output_directory, colour_data$data[[1]], colour_data$data[[2]], current_dataset() )
  
  colour_data$data <- Colour_Analysis$Preprocessing$read_csv( colour_input_parameters$directory, colour_input_parameters$output_directory, colour_input_parameters$merge_groups, current_dataset() )
  
  colour_data$file_data <- as.data.frame( do.call( rbind, lapply( colour_data$data[[1]], unlist ) ) )
  names( colour_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  colour_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_tt_data <- function( tt_input_parameters, current_dataset, tt_data ) {
  
  tt_data[["data"]] <- TT_Analysis$Preprocessing$read_csv( tt_input_parameters$directory, tt_input_parameters$output_directory, tt_input_parameters$merge_groups, current_dataset() )
  
  tt_data[["data"]] <- TT_Analysis$Preprocessing$remove_files( tt_data$data[[1]], tt_data$data[[2]], "" )
  
  tt_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( tt_data$data[[1]], unlist ) ) )
  names( tt_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tt_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  tt_data[["hidden"]] <- data.frame()
  tt_data[["file_data_minus_hidden"]] <- tt_data$file_data
  tt_data[["data_minus_hidden"]] <- tt_data$data
  
}

regenerate_tt_data <- function( tt_input_parameters, current_dataset, tt_data ) {}

update_data_minus_hidden_tt <- function( tt_input_parameters, current_dataset, tt_data ) {
  
  if (nrow( tt_data$hidden ) == 0) {
    
    tt_data$data_minus_hidden <- tt_data$data
    tt_data$file_data_minus_hidden <- tt_data$file_data
    
  } else {
    
    tt_data$data_minus_hidden[[1]] <- tt_data$data[[1]][-as.numeric( rownames( tt_data$hidden ) )]
    
    for (i in 1:length( tt_data$data_minus_hidden[[2]] )) {
      
      tt_data$data_minus_hidden[[2]][[i]] <- tt_data$data[[2]][[i]][-as.numeric( rownames( tt_data$hidden ) )]
      
    }
    
    tt_data$file_data_minus_hidden <- tt_data$file_data[-as.numeric( row.names( tt_data$hidden ) ),]
    
  }
  
  regenerate_tt_data( tt_input_parameters, current_dataset, tt_data )
  
  tt_data$compute_features <- TRUE
  
}

copy_tt_data <- function( tt_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  TT_Analysis$Preprocessing$copy_data( tt_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_tt_data <- function( tt_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  TT_Analysis$Preprocessing$delete_data( tt_input_parameters$output_directory, current_dataset() )
  
}

write_tt_data <- function( tt_input_parameters, current_dataset, tt_data ) {
  
  TT_Analysis$Preprocessing$write_csv( tt_input_parameters$output_directory, tt_data$data[[1]], tt_data$data[[2]], current_dataset() )
  
  tt_data$data <- TT_Analysis$Preprocessing$read_csv( tt_input_parameters$directory, tt_input_parameters$output_directory, tt_input_parameters$merge_groups, current_dataset() )
  
  tt_data$file_data <- as.data.frame( do.call( rbind, lapply( tt_data$data[[1]], unlist ) ) )
  names( tt_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tt_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_shm_data <- function( shm_input_parameters, current_dataset, shm_data ) {
  
  shm_data[["data"]] <- SHM_Analysis$Preprocessing$read_csv( shm_input_parameters$directory, shm_input_parameters$output_directory, shm_input_parameters$merge_groups, current_dataset() )
  
  shm_data[["data"]] <- SHM_Analysis$Preprocessing$remove_files( shm_data$data[[1]], shm_data$data[[2]], "s" )
  
  shm_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( shm_data$data[[1]], unlist ) ) )
  names( shm_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  shm_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  shm_data[["hidden"]] <- data.frame()
  shm_data[["file_data_minus_hidden"]] <- shm_data$file_data
  shm_data[["data_minus_hidden"]] <- shm_data$data
  
}

regenerate_shm_data <- function( shm_input_parameters, current_dataset, shm_data ) {}

update_data_minus_hidden_shm <- function( shm_input_parameters, current_dataset, shm_data ) {
  
  if (nrow( shm_data$hidden ) == 0) {
    
    shm_data$data_minus_hidden <- shm_data$data
    shm_data$file_data_minus_hidden <- shm_data$file_data
    
  } else {
    
    shm_data$data_minus_hidden[[1]] <- shm_data$data[[1]][-as.numeric( rownames( shm_data$hidden ) )]
    shm_data$data_minus_hidden[[2]][[1]] <- shm_data$data[[2]][[1]][-as.numeric( rownames( shm_data$hidden ) )]
    shm_data$data_minus_hidden[[2]][[2]] <- shm_data$data[[2]][[2]][-as.numeric( rownames( shm_data$hidden ) )]
    shm_data$data_minus_hidden[[2]][[3]] <- shm_data$data[[2]][[3]][-as.numeric( rownames( shm_data$hidden ) )]
    shm_data$file_data_minus_hidden <- shm_data$file_data[-as.numeric( row.names( shm_data$hidden ) ),]
    
  }
  
  regenerate_shm_data( shm_input_parameters, current_dataset, shm_data )
  
  shm_data$compute_features <- TRUE
  
}

copy_shm_data <- function( shm_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  SHM_Analysis$Preprocessing$copy_data( shm_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_shm_data <- function( shm_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  SHM_Analysis$Preprocessing$delete_data( shm_input_parameters$output_directory, current_dataset() )
  
}

write_shm_data <- function( shm_input_parameters, current_dataset, shm_data ) {
  
  SHM_Analysis$Preprocessing$write_csv( shm_input_parameters$output_directory, shm_data$data[[1]], shm_data$data[[2]], current_dataset() )
  
  shm_data$data <- SHM_Analysis$Preprocessing$read_csv( shm_input_parameters$directory, shm_input_parameters$output_directory, shm_input_parameters$merge_groups, current_dataset() )
  
  shm_data$file_data <- as.data.frame( do.call( rbind, lapply( shm_data$data[[1]], unlist ) ) )
  names( shm_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  shm_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_tls_data <- function( tls_input_parameters, current_dataset, tls_data ) {
  
  tls_data[["data"]] <- TLS_Analysis$Preprocessing$read_csv( tls_input_parameters$directory, tls_input_parameters$output_directory, tls_input_parameters$merge_groups, current_dataset() )
  
  tls_data[["data"]] <- TLS_Analysis$Preprocessing$remove_files( tls_data$data[[1]], tls_data$data[[2]], "e" )
  
  tls_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( tls_data$data[[1]], unlist ) ) )
  names( tls_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tls_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  tls_data[["hidden"]] <- data.frame()
  tls_data[["file_data_minus_hidden"]] <- tls_data$file_data
  tls_data[["data_minus_hidden"]] <- tls_data$data
  
}

regenerate_tls_data <- function( tls_input_parameters, current_dataset, tls_data ) {}

update_data_minus_hidden_tls <- function( tls_input_parameters, current_dataset, tls_data ) {
  
  if (nrow( tls_data$hidden ) == 0) {
    
    tls_data$data_minus_hidden <- tls_data$data
    tls_data$file_data_minus_hidden <- tls_data$file_data
    
  } else {
    
    tls_data$data_minus_hidden[[1]] <- tls_data$data[[1]][-as.numeric( rownames( tls_data$hidden ) )]
    
    for (i in 1:length( tls_data$data_minus_hidden[[2]] )) {
      
      tls_data$data_minus_hidden[[2]][[i]] <- tls_data$data[[2]][[i]][-as.numeric( rownames( tls_data$hidden ) )]
      
    }
    
    tls_data$file_data_minus_hidden <- tls_data$file_data[-as.numeric( row.names( tls_data$hidden ) ),]
    
  }
  
  regenerate_tls_data( tls_input_parameters, current_dataset, tls_data )
  
  tls_data$compute_features <- TRUE
  
}

copy_tls_data <- function( tls_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  TLS_Analysis$Preprocessing$copy_data( tls_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_tls_data <- function( tls_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  TLS_Analysis$Preprocessing$delete_data( tls_input_parameters$output_directory, current_dataset() )
  
}

write_tls_data <- function( tls_input_parameters, current_dataset, tls_data ) {
  
  TLS_Analysis$Preprocessing$write_csv( tls_input_parameters$output_directory, tls_data$data[[1]], tls_data$data[[2]], current_dataset() )
  
  tls_data$data <- TLS_Analysis$Preprocessing$read_csv( tls_input_parameters$directory, tls_input_parameters$output_directory, tls_input_parameters$merge_groups, current_dataset() )
  
  tls_data$file_data <- as.data.frame( do.call( rbind, lapply( tls_data$data[[1]], unlist ) ) )
  names( tls_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  tls_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_escr_data <- function( escr_input_parameters, current_dataset, escr_data ) {
  
  escr_data[["data"]] <- ESCR_Analysis$Preprocessing$read_csv( escr_input_parameters$directory, escr_input_parameters$output_directory, escr_input_parameters$merge_groups, current_dataset() )
  
  escr_data[["data"]] <- ESCR_Analysis$Preprocessing$remove_files( escr_data$data[[1]], escr_data$data[[2]], "" )
  
  escr_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( escr_data$data[[1]], unlist ) ) )
  names( escr_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  escr_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  escr_data[["hidden"]] <- data.frame()
  escr_data[["file_data_minus_hidden"]] <- escr_data$file_data
  escr_data[["data_minus_hidden"]] <- escr_data$data
  
}

regenerate_escr_data <- function( escr_input_parameters, current_dataset, escr_data ) {}

update_data_minus_hidden_escr <- function( escr_input_parameters, current_dataset, escr_data ) {
  
  if (nrow( escr_data$hidden ) == 0) {
    
    escr_data$data_minus_hidden <- escr_data$data
    escr_data$file_data_minus_hidden <- escr_data$file_data
    
  } else {
    
    escr_data$data_minus_hidden[[1]] <- escr_data$data[[1]][-as.numeric( rownames( escr_data$hidden ) )]
    escr_data$data_minus_hidden[[2]][[2]] <- escr_data$data[[2]][[2]][-as.numeric( rownames( escr_data$hidden ) )]
    escr_data$file_data_minus_hidden <- escr_data$file_data[-as.numeric( row.names( escr_data$hidden ) ),]
    
  }
  
  regenerate_escr_data( escr_input_parameters, current_dataset, escr_data )
  
  escr_data$compute_features <- TRUE
  
}

copy_escr_data <- function( escr_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  ESCR_Analysis$Preprocessing$copy_data( escr_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_escr_data <- function( escr_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  ESCR_Analysis$Preprocessing$delete_data( escr_input_parameters$output_directory, current_dataset() )
  
}

write_escr_data <- function( escr_input_parameters, current_dataset, escr_data ) {
  
  ESCR_Analysis$Preprocessing$write_csv( escr_input_parameters$output_directory, escr_data$data[[1]], escr_data$data[[2]], current_dataset() )
  
  escr_data$data <- ESCR_Analysis$Preprocessing$read_csv( escr_input_parameters$directory, escr_input_parameters$output_directory, escr_input_parameters$merge_groups, current_dataset() )
  
  escr_data$file_data <- as.data.frame( do.call( rbind, lapply( escr_data$data[[1]], unlist ) ) )
  names( escr_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  escr_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_gcms_data <- function( gcms_input_parameters, current_dataset, gcms_data ) {
  
  gcms_data[["data"]] <- GCMS_Analysis$Preprocessing$read_csv( gcms_input_parameters$directory, gcms_input_parameters$output_directory, gcms_input_parameters$merge_groups, current_dataset() )
  
  gcms_data[["data"]] <- GCMS_Analysis$Preprocessing$remove_files( gcms_data$data[[1]], gcms_data$data[[2]], "" )
  
  gcms_data[["file_data"]] <- as.data.frame( do.call( rbind, lapply( gcms_data$data[[1]], unlist ) ) )
  names( gcms_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  gcms_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
  GCMS_Analysis$Preprocessing$compute_mean( gcms_input_parameters$output_directory, gcms_data$data[[1]], gcms_data$data[[2]], current_dataset() )
  
  gcms_data$data[[2]] <- GCMS_Analysis$Preprocessing$read_mean( gcms_input_parameters$output_directory, gcms_data$data[[2]], current_dataset() )
  
  gcms_data[["hidden"]] <- data.frame()
  gcms_data[["file_data_minus_hidden"]] <- gcms_data$file_data
  gcms_data[["data_minus_hidden"]] <- gcms_data$data
  
}

regenerate_gcms_data <- function( gcms_input_parameters, current_dataset, gcms_data ) {
  
  GCMS_Analysis$Preprocessing$compute_mean( gcms_input_parameters$output_directory, gcms_data$data_minus_hidden[[1]], gcms_data$data_minus_hidden[[2]], current_dataset() )
  
  gcms_data$data_minus_hidden[[2]] <- GCMS_Analysis$Preprocessing$read_mean( gcms_input_parameters$output_directory, gcms_data$data_minus_hidden[[2]], current_dataset() )
  
}

update_data_minus_hidden_gcms <- function( gcms_input_parameters, current_dataset, gcms_data ) {
  
  if (nrow( gcms_data$hidden ) == 0) {
    
    gcms_data$data_minus_hidden <- gcms_data$data
    gcms_data$file_data_minus_hidden <- gcms_data$file_data
    
  } else {
    
    gcms_data$data_minus_hidden[[1]] <- gcms_data$data[[1]][-as.numeric( rownames( gcms_data$hidden ) )]
    gcms_data$data_minus_hidden[[2]][[2]] <- gcms_data$data[[2]][[2]][-as.numeric( rownames( gcms_data$hidden ) )]
    gcms_data$file_data_minus_hidden <- gcms_data$file_data[-as.numeric( row.names( gcms_data$hidden ) ),]
    
  }
  
  regenerate_gcms_data( gcms_input_parameters, current_dataset, gcms_data )
  
  gcms_data$compute_features <- TRUE
  
}

copy_gcms_data <- function( gcms_input_parameters, dataset_version_1, dataset_version_2 ) {
  
  req( dataset_version_2 != "" )
  
  GCMS_Analysis$Preprocessing$copy_data( gcms_input_parameters$output_directory, dataset_version_1, dataset_version_2 )
  
}

delete_gcms_data <- function( gcms_input_parameters, current_dataset ) {
  
  req( current_dataset() != "" )
  
  GCMS_Analysis$Preprocessing$delete_data( gcms_input_parameters$output_directory, current_dataset() )
  
}

write_gcms_data <- function( gcms_input_parameters, current_dataset, gcms_data ) {
  
  GCMS_Analysis$Preprocessing$write_csv( gcms_input_parameters$output_directory, gcms_data$data[[1]], gcms_data$data[[2]], current_dataset() )
  
  gcms_data$data <- GCMS_Analysis$Preprocessing$read_csv( gcms_input_parameters$directory, gcms_input_parameters$output_directory, gcms_input_parameters$merge_groups, current_dataset() )
  
  gcms_data$file_data <- as.data.frame( do.call( rbind, lapply( gcms_data$data[[1]], unlist ) ) )
  names( gcms_data$file_data ) <- c( "Resin", "Specimen", "Label", "Description" )
  gcms_data$file_data %<>% mutate( Resin = as.integer( Resin ), Specimen = as.integer( Specimen ) )
  
}

read_global_data <- function( global_input_parameters, current_dataset, global_data, ESCRP_select_model_rb ) {
  
  # Global_Analysis$Utilities$predict_escr_from_shm( global_input_parameters, current_dataset() )
  file.copy( "Backup/Model_Coefficients_27.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/Model_Coefficients_27", current_dataset(), ".csv" ) )
  file.copy( "Backup/Model_Coefficients_23456710.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/Model_Coefficients_23456710", current_dataset(), ".csv" ) )
  file.copy( "Backup/SHM_Actual_vs_Predicted_27.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_Actual_vs_Predicted_27", current_dataset(), ".csv" ) )
  file.copy( "Backup/SHM_Actual_vs_Predicted_23456710.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_Actual_vs_Predicted_23456710", current_dataset(), ".csv" ) )
  file.copy( "Backup/SHM_ESCR_Coefficients.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_ESCR_Coefficients", current_dataset(), ".csv" ) )
  file.copy( "Backup/SHM_ESCR_Prediction_27.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_ESCR_Prediction_27", current_dataset(), ".csv" ) )
  file.copy( "Backup/SHM_ESCR_Prediction_23456710.csv", paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_ESCR_Prediction_23456710", current_dataset(), ".csv" ) )
  
  model_version <- ""
  
  if (ESCRP_select_model_rb == "General") model_version <- "23456710"
  
  if (ESCRP_select_model_rb == "DSC") model_version <- "27"
  
  global_data[["SHM_AvsP"]] <- suppressMessages( read_csv( paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_Actual_vs_Predicted_", model_version, current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
  global_data[["SHM_ESCR_Predictions"]] <- suppressMessages( read_csv( paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/SHM_ESCR_Prediction_", model_version, current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )
  
}

regenerate_global_data <- function( global_input_parameters, current_dataset, global_data ) {

  global_input_parameters$datasets_to_read <- c( 2L, 3L, 4L, 5L, 6L, 7L, 10L )
  global_input_parameters$sample_mask <- c( 11L, 14L, 10L, 4L, 13L, 21L, 23L, 18L, 22L, 20L, 2L, 3L, 17L, 16L, 19L, 1L, 15L, 12L, 6L, 5L, 7L, 9L, 8L, 24L )

  result <- Global_Analysis$Preprocessing$read_files_and_preprocess( global_input_parameters )

  Global_Analysis$Utilities$escr_predictor( global_input_parameters, result[[1]], current_dataset() )

  global_data[["ESCR_Predictions"]] <- suppressMessages( read_csv( paste0( global_input_parameters$output_directory, "Global/Sandbox/ESCR_Prediction/ESCR_Prediction", current_dataset(), ".csv" ) ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )

}

