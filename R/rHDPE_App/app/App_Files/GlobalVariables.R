#===============
# File containing global variables for the app.

#===============
# Global Variables

output_directories <- c( "FTIR", "DSC", "TGA", "Rheology", "Colour", "TT", "SHM", "TLS", "ESCR", "GCMS", "Global", "Raw_Data" )

experiments <- c( "FTIR", "DSC", "TGA", "Rheology", "Colour", "Tensile Testing", "SHM", "TLS", "ESCR", "GCMS" )
resin_data_titles <- output_directories[1:10]

datasets <- c( "FTIR", "DSC", "TGA", "Rheology", "Tensile Testing", "Colour", "SHM", "TLS", "ESCR" )

e <- c( "DSC", "TGA", "Rheology", "Colour", "Tensile Testing", "TLS", "ESCR" )
e_labels <- c( "dsc", "tga", "rheo", "colour", "tt", "tls", "escr" )

content_analysis <- suppressMessages( read_csv( "www/Output/FTIR/Content_Analysis/Mean_Features.csv", col_types = cols() ) %>% select( -...1 ) %>% mutate_at( vars( sample ), as.integer ) )
pp_percentages <- suppressMessages( read_csv( "www/Output/FTIR/PP_Predictions/PP_Predictions.csv" ) %>% mutate_at( vars( "...1" ), as.integer ) %>% rename( sample = "...1" ) )

unnormalised_rheology_data <- suppressMessages( read_csv( "www/Output/Rheology/Features/Mean_Features_Unnormalised.csv" ) %>% select( -...1 ) %>% mutate_at( vars( sample ), as.integer ) )
unnormalised_shm_data <- suppressMessages( read_csv( "www/Output/SHM/Features/Mean_Features_Unnormalised.csv" ) %>% select( -...1 ) %>% mutate_at( vars( sample ), as.integer ) )

features_metadata <- read_excel( "Features_Metadata.xlsx", .name_repair = "unique_quiet" )

# theme = bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( ".btn-secondary { background-color: orange }" )
# theme = bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( ".btn-secondary { --bs-btn-border-color: orange }" )
# theme = bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( ".btn-secondary:hover { background-color: orange }" )
# theme = bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( ".btn-secondary { --bs-btn-font-size: 19px }" )
# theme = bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( ".checkbox input[type = 'checkbox']:checked { background-color: yellow }" )

app_theme <- bs_theme( bootswatch = "cyborg" )

bs_primary <- bs_get_variables( app_theme, "primary" )
bs_light <- bs_get_variables( app_theme, "gray-900" )
bs_bg <- bs_get_variables( app_theme, "body-bg" )

secondary_colour <- "#37deb1"
secondary_colour_light <- "#23ebb5"
text_colour <- "white"

app_theme <- bs_theme( bootswatch = "cyborg" ) %>% bslib::bs_add_rules( list( paste0( ".btn-secondary { --bs-btn-hover-color: ", bs_primary, " }" ), paste0( ".btn-secondary { --bs-btn-hover-border-color: ", secondary_colour, " }" ), paste0( ".btn-secondary { --bs-btn-border-color: ", bs_primary, " }" ), ".btn-secondary { --bs-btn-active-color: green }", paste0( ".btn-secondary { --bs-btn-active-border-color: ", bs_primary, " }" ), ".btn-secondary { --bs-btn-active-border-color: green }", paste0( ".well { border-color: ", bs_primary, " }" ) ) )
app_theme <- app_theme %>% bslib::bs_add_rules( ":root { --bs-emphasis-color-rgb: 255, 255, 255 }" )

ds_paper_1_resins_identifiers <- c( 1:23 )
ds_paper_2_resins_identifiers <- c( 1:24 )
virgin_resins_identifiers <- as.integer( c( 16, 17, 19, 24, 25, 26, 27, 28 ) )
pp_resins_identifiers <- as.integer( c( 18, 20, 21, 22, 23 ) )
component_analysis_resins_identifiers <- as.integer( c( 1:23, 401:416, seq( 500, 518, 2 ), 601:605, 701:712 ) )

resin_types <- c( "HDPE PCR", "HDPE Virgin", "Blend", "PP PCR", "PP Virgin" )

list_of_colours <- suppressMessages( read_csv( "List_of_Colours.csv", col_types = cols() )[, -1] )

dsc_features <- list( "Crystallinity FWHM (DSC_C_HalfPeak)" = 8, "Melt FWHM (DSC_M_HalfPeak)" = 9, "Crystallinity Onset (DSC_C_Onset)" = 11, "Melt Offset (DSC_M_Onset)" = 12, "Crystallinity (DSC_Crystallinity)" = 13, "PP% (DSC_fPP)" = 14 )
tga_features <- list( 0, 7, 14, 18, 22, 23 )
rheo_features <- list( "Complex Viscosity at 100 rad/s (Rhe_100.00)" = 0, "Loss Factor at 100 rad/s (Rhe_Loss_100.00)" = 93, "Complex Viscosity at 0.1 rad/s (Rhe_0.10)" = 30, "Loss Factor at 0.1 rad/s (Rheo_Loss_0.10)" = 123, "Divergence (Rhe_Log)" = 126, "Crossover Point Angular Frequency (Rhe_Crossover)" = 124, "Crossover Point Modulus (Rhe_SMCrossover)" = 125, "V deg (Rhe_V_deg)" = 127, "V deg custom (Rhe_V_deg_custom)" = 128 )
colour_features <- list( 0, 1, 2 )
tt_features <- list( 0, 1, 2 )
tls_features <- list( 0, 1 )
escr_features <- list( 0, 1, 2 )