#ui module for the key-value filter parts of the search dialog box
key_valueInput <- function(id){
  ns <- NS(id)
  uiOutput(ns("ui"))
}
