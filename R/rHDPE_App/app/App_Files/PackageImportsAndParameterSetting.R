#===============
# Python package import and parameters.

Global_Analysis <- import( "rHDPE_Data_Analysis.Global_Analysis" )
FTIR_Analysis <- import( "rHDPE_Data_Analysis.FTIR_Analysis" )
DSC_Analysis <- import( "rHDPE_Data_Analysis.DSC_Analysis" )
TGA_Analysis <- import( "rHDPE_Data_Analysis.TGA_Analysis" )
Rheology_Analysis <- import( "rHDPE_Data_Analysis.Rheology_Analysis" )
Colour_Analysis <- import( "rHDPE_Data_Analysis.Colour_Analysis" )
TT_Analysis <- import( "rHDPE_Data_Analysis.TT_Analysis" )
SHM_Analysis <- import( "rHDPE_Data_Analysis.SHM_Analysis" )
TLS_Analysis <- import( "rHDPE_Data_Analysis.TLS_Analysis" )
ESCR_Analysis <- import( "rHDPE_Data_Analysis.ESCR_Analysis" )
GCMS_Analysis <- import( "rHDPE_Data_Analysis.GCMS_Analysis" )

Global_Utilities <- import( "rHDPE_Data_Analysis.Global_Utilities" )

global_input_parameters <- Global_Analysis$Input_Parameters_Class$Input_Parameters()

global_input_parameters$shiny <- TRUE
global_input_parameters$directory <- ""
global_input_parameters$output_directory <- "www/Output/"
global_input_parameters$datasets_to_read <- c( 1L, 2L, 3L, 4L, 5L, 6L )
global_input_parameters$sample_mask <- c( 11L, 14L, 10L, 4L, 13L, 21L, 23L, 18L, 22L, 20L, 2L, 3L, 17L, 16L, 19L, 1L, 15L, 12L, 6L, 5L, 7L, 9L, 8L, 24L )
global_input_parameters$user <- app_user

if (app_user == "shiny") {
  
  global_input_parameters$directory <- "tmp/"
  global_input_parameters$output_directory <- "tmp/"
  
}

ftir_input_parameters <- FTIR_Analysis$Input_Parameters_Class$Input_Parameters()

ftir_input_parameters$shiny <- TRUE
ftir_input_parameters$directory <- ""
ftir_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  ftir_input_parameters$directory <- "tmp/"
  ftir_input_parameters$output_directory <- "tmp/"
  
}

dsc_input_parameters <- DSC_Analysis$Input_Parameters_Class$Input_Parameters()

dsc_input_parameters$shiny <- TRUE
dsc_input_parameters$directory <- ""
dsc_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  dsc_input_parameters$directory <- "tmp/"
  dsc_input_parameters$output_directory <- "tmp/"
  
}

tga_input_parameters <- TGA_Analysis$Input_Parameters_Class$Input_Parameters()

tga_input_parameters$shiny <- TRUE
tga_input_parameters$directory <- ""
tga_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  tga_input_parameters$directory <- "tmp/"
  tga_input_parameters$output_directory <- "tmp/"
  
}

rheo_input_parameters <- Rheology_Analysis$Input_Parameters_Class$Input_Parameters()

rheo_input_parameters$shiny <- TRUE
rheo_input_parameters$directory <- ""
rheo_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  rheo_input_parameters$directory <- "tmp/"
  rheo_input_parameters$output_directory <- "tmp/"
  
}

colour_input_parameters <- Colour_Analysis$Input_Parameters_Class$Input_Parameters()

colour_input_parameters$shiny <- TRUE
colour_input_parameters$directory <- ""
colour_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  colour_input_parameters$directory <- "tmp/"
  colour_input_parameters$output_directory <- "tmp/"
  
}

tt_input_parameters <- TT_Analysis$Input_Parameters_Class$Input_Parameters()

tt_input_parameters$shiny <- TRUE
tt_input_parameters$directory <- ""
tt_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  tt_input_parameters$directory <- "tmp/"
  tt_input_parameters$output_directory <- "tmp/"
  
}

shm_input_parameters <- SHM_Analysis$Input_Parameters_Class$Input_Parameters()

shm_input_parameters$shiny <- TRUE
shm_input_parameters$directory <- ""
shm_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  shm_input_parameters$directory <- "tmp/"
  shm_input_parameters$output_directory <- "tmp/"
  
}

tls_input_parameters <- TLS_Analysis$Input_Parameters_Class$Input_Parameters()

tls_input_parameters$shiny <- TRUE
tls_input_parameters$directory <- ""
tls_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  tls_input_parameters$directory <- "tmp/"
  tls_input_parameters$output_directory <- "tmp/"
  
}

escr_input_parameters <- ESCR_Analysis$Input_Parameters_Class$Input_Parameters()

escr_input_parameters$shiny <- TRUE
escr_input_parameters$directory <- ""
escr_input_parameters$data_directory <- "www/Output/Raw_Data/ESCR/"
escr_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  escr_input_parameters$directory <- "tmp/"
  escr_input_parameters$output_directory <- "tmp/"
  
}

gcms_input_parameters <- GCMS_Analysis$Input_Parameters_Class$Input_Parameters()

gcms_input_parameters$shiny <- TRUE
gcms_input_parameters$directory <- ""
gcms_input_parameters$output_directory <- "www/Output/"

if (app_user == "shiny") {
  
  gcms_input_parameters$directory <- "tmp/"
  gcms_input_parameters$output_directory <- "tmp/"
  
}