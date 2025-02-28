#===============
# Identify user:
# "philsmith" for running locally.
# "shiny" for running on shinyapps.io.
# "docker" for running on DataLab.

app_user <- Sys.info()[["user"]]

if (app_user == "philsmith") {
  
  # app_user <- "shiny"
  
}

if (app_user == "shiny") {
  
  include_login <- TRUE
  
} else {
  
  include_login <- FALSE
  
}

directory <- ""
output_directory <- "www/Output/"

email <- "phil.smith@unilever.com"

if (app_user == "shiny") {
  
  directory <- "tmp/"
  output_directory <- "tmp/"
  
  email <- "philip.smith-2@manchester.ac.uk"
  
}