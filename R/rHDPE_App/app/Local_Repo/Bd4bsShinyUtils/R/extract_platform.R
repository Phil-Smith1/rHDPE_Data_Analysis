#'Server function which corresponds to extract_platformUI
#'
#'The function is used to extract
#'a single user-specified uid from the BD4BS data store and store in the app's filestore
#'@param input shiny input argument
#'@param output shiny output argument
#'@param session shiny session argument
#'@param filestore_location - the location to put extracted files
#'@return a reactive of the file id of the last extracted file which has been stored in the file store
#'or NULL if no files extracted/last file attempted to be extracted failed
#'@export
extract_platform <- function(input, output, session, filestore_location){

  ns <- session$ns

  ####
  ##reactiveVals

  #error message to be displayed on screen
  error_message_rv <- reactiveVal(NULL)
  #the file extracted to be returned from the module
  file_extracted_rv <- reactiveVal(NULL)

  ####
  #outputs

  output$error_message_ui <- renderUI({
    req(error_message_rv())
    p(error_message_rv())
  })

  output$extract_button_ui <- renderUI({
    shiny::validate({need(input$id_input != "", "Please enter an id in the text box")})
    actionButton(ns("extract_button"), "Extract file")
  })

  ####
  #events

  #when extract button is pressed
  observeEvent(input$extract_button, {

    #reset reactiveVals
    error_message_rv(NULL)
    file_extracted_rv(NULL)

    #file id to be extracted
    file_id <- input$id_input

    #attempt to extract file
    tryCatch(
      withProgress(message = "Extracting file from BD4BS", value=1,
        access_data_gateway_by_id(file_id, session, filestore_location)
      ),
      error=function(cond){ #if fail put message in error message reactive Val
        error_message_rv(cond$message)
      }
    )

    #if successful update file extracted reactive val to be returned
    #and close modal
    if(is.null(error_message_rv())){
      file_extracted_rv(file_id)
      removeModal()
    }
  })

  return(reactive(file_extracted_rv()))
}
