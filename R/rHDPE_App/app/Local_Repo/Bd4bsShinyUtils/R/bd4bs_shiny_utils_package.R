#' @import shiny
#' @importFrom httr add_headers GET http_status content POST PUT upload_file status_code
#' @importFrom jsonlite fromJSON toJSON unbox
#' @importFrom DT dataTableOutput renderDataTable
#' @importFrom utils tail
NULL


#returns TRUE if in dev mode, false otherwise
in_dev_mode <- function(){
  (!is.null(getOption("Bd4bsShinyUtils.dev_mode")) && getOption("Bd4bsShinyUtils.dev_mode"))
}


#Return environment variable "param" when not in dev mode
#or "" in dev mode. If not in dev mode and environment variable = ""
#then throw error
getConfigValue <- function(param){
  #Check the environment variable is set up if not in dev mode
  if(in_dev_mode()){
    return("")
  }
  if(Sys.getenv(param) ==""){
    stop(paste(param, "environment variable is not set"))
  }
  return(Sys.getenv(param))
}


.onAttach <- function(libname, pkgname){
  if(in_dev_mode()){
    msg <- "Bd4bsShinyUtils package loaded in development mode"
  }
  else{
    msg <- "Bd4bsShinyUtils package loaded in production mode"
    access_gateway_var <-  Sys.getenv("DATA_ACCESS_GATEWAY")
    if(access_gateway_var ==""){
      msg <- paste(msg, "DATA_ACCESS_GATEWAY variable is not set it must be set before the package can be used")
    }
    else{
      msg <- paste(msg, "DATA_ACCESS_GATEWAY variable =", access_gateway_var)
    }
  }
  packageStartupMessage(msg)
}
