VIRTUALENV_NAME = "rhdpe_env"
Sys.setenv( VIRTUALENV_NAME = VIRTUALENV_NAME )

if (Sys.info()[["user"]] == "shiny"){
  
  Sys.setenv( PYTHON_PATH = "/usr/bin/python3" )
  Sys.setenv( RETICULATE_PYTHON = paste0( "/home/shiny/.virtualenvs/", VIRTUALENV_NAME, "/bin/python3" ) )

}

Sys.setenv( ORIGINALWD = getwd() )

# else {
#   
#   options( shiny.port = 7450 )
#   Sys.setenv( PYTHON_PATH = "3.12" )
#   
# }

if (Sys.info()[["user"]] != "shiny"){

  #### -- Packrat Autoloader (version 0.9.1-1) -- ####
  source( "packrat/init.R" )
  #### -- End Packrat Autoloader -- ####
  
}
