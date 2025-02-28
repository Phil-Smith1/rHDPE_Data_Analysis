#' Ui module for searching and importing files from BD4BS
#'@param id required argument for shiny ui modules
#'@param title the title for the modal dialog
#'@param message any message to be displayed above the search input box
#'@param include_cancel_button should there be an option to cancel without importing a file?
#'If TRUE then modalButton is used, If FALSE then no cancel button is displayed and IF "actionButton"
#'then an action button is displayed and when pressed then the returned value of the module is set to the
#'time the Cancel button was pressed (i.e. Sys.time()) see corresponding server module for more details
#'@param search_table_style_string css character string to handle the display of the search results table
#'by default this is: \cr 'word-break: break-all; overflow-x:auto; white-space:nowrap;'
#'@export
search_platform_UI <- function(id, title="Search BD4BS to import files into this shiny app",
                               message=NULL, include_cancel_button=TRUE,
                               search_table_style_string="word-break: break-all; overflow-x:auto; white-space:nowrap;"){

  ns <- NS(id)

  cancel_button_ui <- NULL
  if(is.logical(include_cancel_button) && (include_cancel_button)){
    cancel_button_ui <- modalButton("Cancel")
  }else if(is.character(include_cancel_button) && include_cancel_button == "actionButton" ){
    cancel_button_ui <- actionButton(ns("cancel"), "Cancel")
  }
  else if(!is.logical(include_cancel_button)){
    stop("Invalid include_cancel_button argument")
  }


  modalDialog(title=title, size = "l",
    p(message),
    uiOutput(ns("search")),
    uiOutput(ns("select_from_results_ui")),
    div(style=search_table_style_string,
        DT::dataTableOutput(ns("result_table"))),
    uiOutput(ns("error_message_ui")),
    footer=
      fluidRow(
        column(2, uiOutput(ns("import_button_ui"))),
        column(8, NULL),
        column(2, cancel_button_ui)
      )
  )
}
