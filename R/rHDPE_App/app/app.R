# Sourcing

source( "App_Files/UI.R" ) # File containing the UI code.
source( "App_Files/Server.R" ) # File containing the server code.

#===============
# Shiny App function.

shinyApp( ui, server )