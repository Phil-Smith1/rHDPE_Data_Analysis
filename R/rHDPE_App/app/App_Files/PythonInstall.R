#===============
# Sets up/installs Python on the platform.

#===============
# Code

PYTHON_DEPENDENCIES = c( 'pip', 'numpy', 'numbers-parser', 'pandas', 'scipy', 'scikit-learn', 'distinctipy', 'matplotlib', 'adjustText', 'openpyxl', 'rpy2', 'colormath', 'rHDPE_Data_Analysis' ) # The Python packages that the tool is dependent on.

virtualenv_name = Sys.getenv( "VIRTUALENV_NAME" )

if (Sys.info()[["user"]] == "shiny") {
  
  python_path = Sys.getenv( "PYTHON_PATH" )
  virtualenv_create( envname = virtualenv_name, python = python_path )
  virtualenv_install( virtualenv_name, packages = PYTHON_DEPENDENCIES, ignore_installed = FALSE )
  use_virtualenv( virtualenv_name, required = TRUE )
  
}