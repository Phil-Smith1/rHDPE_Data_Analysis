#===============
# Welcome to the PCR Predictor Tool.
# From now on, we refer to the PCR Predictor Tool as the app.
# This is the starting page for all R code of the app.
# The app (an R Shiny app) is designed using R, but the app imports the rHDPE_Data_Analysis Python package to perform the analysis of the data.

#===============
# Sources

source( "App_Files/UI.R" ) # File containing the UI code.
source( "App_Files/Server.R" ) # File containing the server code.

#===============
# Shiny App function.

shinyApp( ui, server )