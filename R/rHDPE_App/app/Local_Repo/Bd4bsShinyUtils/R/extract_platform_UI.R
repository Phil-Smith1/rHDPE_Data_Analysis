#' Ui module for importing file from BD4BS given file id
#' @param id required argument for shiny ui modules
#' @param title the title for the modal dialog
#' @param default_value what should the id input text box have as a default
#' @param label_text what text should be displayed for the input text box
#' @export
extract_platform_UI <- function(id, title="Enter id to extract file from BD4BS platform", default_value="",
                                label_text="Enter file id"){
  ns <- NS(id)
  modalDialog(title=title, size = "s",
    textInput(ns("id_input"), label=label_text , value=default_value, placeholder = label_text),
    uiOutput(ns("error_message_ui")),
    footer=fluidRow(
      column(4, uiOutput(ns("extract_button_ui"))),
      column(4, NULL),
      column(4, modalButton("Cancel"))
    )
  )
}
