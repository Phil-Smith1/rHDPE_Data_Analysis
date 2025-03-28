#===============
# File that sets certain parameters depending on the platform the app is running on.

#===============
# Code

# Return options for Sys.info()[["user"]]:
# "philsmith" for running locally.
# "shiny" for running on shinyapps.io.
# "docker" for running on DataLab.

app_user <- Sys.info()[["user"]] # Set the app_user object.

# if (app_user == "philsmith") app_user <- "shiny" # Uncomment if you want the app to behave as if it's being run on shinyapps.io when it's running locally.

include_login <- FALSE # If true, a login is required.
directory <- "" # The working directory of the app.
output_directory <- "www/Output/" # Where outputs are accessed and saved.
email <- "phil.smith@unilever.com" # The displayed contact email.

if (app_user == "shiny") {
  
  include_login <- TRUE
  directory <- "tmp/"
  output_directory <- "tmp/"
  email <- "philip.smith-2@manchester.ac.uk"
  
}