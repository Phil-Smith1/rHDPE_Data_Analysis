#ui module for individual filters for the
#key-value filter parts of the search dialog box
key_value_filterInput <- function(id){
  ns <- NS(id)
  uiOutput(ns("ui"))
}
