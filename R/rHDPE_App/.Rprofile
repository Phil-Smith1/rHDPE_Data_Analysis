VIRTUALENV_NAME = "rHDPE_env"
Sys.setenv( VIRTUALENV_NAME = VIRTUALENV_NAME )

if (Sys.info()[["user"]] == "shiny"){ # For deployment on shinyapps.io
  
  Sys.setenv( PYTHON_PATH = "/usr/bin/python3" )
  Sys.setenv( RETICULATE_PYTHON = paste0( "/home/shiny/.virtualenvs/", VIRTUALENV_NAME, "/bin/python3" ) )

} else {
  
  options( shiny.port = 7450 )
  Sys.setenv( PYTHON_PATH = "3.8" )
  
}
