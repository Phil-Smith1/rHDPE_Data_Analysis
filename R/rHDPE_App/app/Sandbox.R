library( readxl )
library( magrittr )
library( ggplot2 )
library( reshape2 )
library(diptest)

# ds_paper_1_resins_identifiers <- c( 1:23 )
# 
# resin_data <- read_excel( "List_of_Resins.xlsx", .name_repair = "unique_quiet" )
# 
# names( resin_data ) <- as.list( resin_data[1,] )
# names( resin_data )[names( resin_data ) == "Resin"] <- "Identifier"
# resin_data <- data.frame( resin_data[-1,] %>% mutate( Identifier = as.integer( Identifier ) ), check.names = FALSE )
# 
# ds_paper_1_resins <- resin_data %>% filter( Identifier %in% ds_paper_1_resins_identifiers )
# 
# print( resin_data$Identifier )

# bimodal_data <- read_excel( "Bimodal_Data.xlsx", .name_repair = "unique_quiet" )
# 
# result_dip_five <- dip( bimodal_data$fivemmol, full = TRUE )
# result_dip_ten <- dip( bimodal_data$tenmmol, full = TRUE )
# result_dip_five_test <- dip.test( bimodal_data$fivemmol )
# result_dip_ten_test <- dip.test( bimodal_data$tenmmol )
# 
# print( result_dip_five )
# print( result_dip_ten )
# print( result_dip_five_test )
# print( result_dip_ten_test )

bslib::bs_theme()




                                    
