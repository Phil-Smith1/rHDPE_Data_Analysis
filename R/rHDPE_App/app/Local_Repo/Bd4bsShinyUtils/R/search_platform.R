#'Server module which is used to search the platform
#'
#'This module corresponds to search_platformUI - it is used to search (and then extract)
#'files from the BD4BS data store and store them in the app's filestore.
#'
#'@param input shiny input argument
#'@param output shiny output argument
#'@param session shiny session argument
#'@param filestore_location the location to put extracted files
#'@param action_button_label the label for the import button
#'@param number_files reactive if NULL then any number of files can be selected for importing, if a number
#'then the given number of files must be imported
#'@param default_search_term reactive string to give a default value to the search term textInput
#'@param default_tags reactive comma separated string to give a default value to the tags textInput
#'@param allow_key_value_filters logical - if true then key value filters are allowed to be entered by user
#'for searching, otherwise they not
#'@param max_number_filters numeric, the maximum number of key value filters to be shown on the UI
#'(ignored if allow_key_value_filters is FALSE)
#'@param selected_columns_for_results_table a vector of columns chosen from:
#'"Name", "Description", "Tags", "Id", "Key-Values" and "RepoId" for search/cart results to be shown on the UI
#'(note this argument does not affect the return value of this module only the output show to users)
#'@return a reactive dataframe of the files last extracted and stored in the file store
#'or NULL if no files extracted/last file extraction attempted failed.
#'
#'The dataframe contains the following columns:
#'Name, Description, Tags, Id and RepoId columns
#'contains the filenames of the extracted files
#'
#'@details If the include_cancel_button argument of the corresponding UI function is set to "actionButton"
#'then when the Cancel button is pressed Sys.time() is returned (including milliseconds).
#'
#'We need to be able to fire actions based on a cancel button press and for an action to trigger in Shiny, the button needs to return a value.
#'The value needs to differ each time, so we use the system time. The actual return value is unimportant.
#'
#'Setting include_cancel_button to TRUE will use a modalButton and FALSE will not include a cancel button
#'
#'@export
search_platform <- function(input, output, session, filestore_location,
                            action_button_label="Import into shiny app", number_files=reactive(NULL),
                            default_search_term=reactive(""), default_tags=reactive(""), allow_key_value_filters=TRUE,
                            max_number_filters=4, selected_columns_for_results_table=c("Name", "Description", "Tags", "Id")){

  ns <- session$ns

  ####
  #reactiveVals

  #data frame containing the results of the search query or request to "/cart"
  search_result_rv <- reactiveVal(NULL)
  #error message to be displayed on screen
  error_message_rv <- reactiveVal(NULL)
  #the files extracted to be returned from the module
  files_extracted_rv <- reactiveVal(NULL)

  ####
  #modules
  key_value_fields <- callModule(key_value, "key_values",max_number_filters,
                        reactive(allow_key_value_filters && input$use_key_value_filter))


  ####
  #reactives
  #inputs for search
  search_description <- reactive(input$search_description)
  search_tags <- reactive(format_tag_list(input$search_tags))

  ####
  #outputs
  output$search <- renderUI({
    fluidRow(
        column(4,
        textInput(ns("search_description"), "Search term", placeholder="Enter search term here", value=default_search_term()),
        textInput(ns("search_tags"), "Tags", placeholder="Enter a comma separated list of tags", value=default_tags()),
        if(allow_key_value_filters) checkboxInput(ns("use_key_value_filter"), "Use key-value filters") else NULL,
        p(),
        uiOutput(ns("search_button_ui"))),
        column(8, key_valueInput(ns("key_values")))
      )
  })

  #Search button displayed (if valid inputs)
  output$search_button_ui <- renderUI({
    req(key_value_fields())
    shiny::validate({need( search_description() != "", "The search term field cannot be empty")})
    actionButton(ns("search_button"), "Search")
  })


  #results from search
  output$result_table <- DT::renderDataTable({
                           req(search_result_rv())
                           results <- search_result_rv()
                           results[, selected_columns_for_results_table]},
                           selection=list(mode="multiple",
                           selected=NULL),
                           server=FALSE, rownames=FALSE, escape=FALSE)

  #error message if exists
  output$error_message_ui <- renderUI({
    req(error_message_rv())
    p(error_message_rv())
  })

  #message to tell users to select desired rows (if any search terms displayed)
  output$select_from_results_ui <- renderUI({
    req(search_result_rv())
    if(nrow(search_result_rv())==0){
      return(h5("No search results found"))
    }
    h5(paste0("Select the required files from the table above and press the '", action_button_label, "' button"))
  })

  #import button displayed if some files have been selected
  output$import_button_ui <- renderUI({
    req(nrow(search_result_rv()) != 0 ,input$result_table_rows_selected)
    if(!is.null(number_files())){
      if(length(input$result_table_rows_selected) != number_files()){
        validate({need(FALSE, paste("Exactly",number_files(), " file(s) must be selected for importing into the app"))})
      }
    }
    actionButton(ns("import_button"), action_button_label)
  })

  ####
  #functions

  import_files <- function(){
    #selected files
    file_ids <- search_result_rv()[input$result_table_rows_selected,"Id"]

    #reset
    error_message_rv(NULL)
    files_extracted_rv(NULL)

    #attempt to extract files and place in local file store
    tryCatch({
      extract_selected_files(file_ids, session, filestore_location)
    },error=function(cond){
      error_message_rv(cond$message) #if fail then update error message
      NULL
    })

    #if succeed - update files which have been extracted reactive val and close modal
    if(is.null(error_message_rv())){
      files_extracted_rv(search_result_rv()[input$result_table_rows_selected, ])
      removeModal()
    }
  }

  ####
  #observeEvents

  #when press search button
  observeEvent(input$search_button, {
    error_message_rv(NULL)
    search_result_rv(NULL)

    #try access search
    result_data_frame <- tryCatch(
      access_data_gateway_by_search(session, query=search_description(), tags=search_tags(), key_value_query=key_value_fields())
    ,error=function(cond){
      error_message_rv(cond$message) #if fail update error message
      NULL
    })

    #if succeed then set search result reactive val to contain the results
    if(!is.null(result_data_frame)){
      data <- tryCatch(
        format_search_results(result_data_frame),
        error=function(cond){
          error_message_rv(cond$message)
          NULL
        }
      )

      if(!is.null(data)) search_result_rv(data)
    }
  })

  #when press import button
  observeEvent(input$import_button, {
    import_files()
  })

  observeEvent(input$cancel, {
    old_option_value <- options()$digits.secs
    options(digits.secs=6)
    files_extracted_rv(Sys.time())
    options(digits.secs=old_option_value)
    removeModal()
  })

  return(reactive(files_extracted_rv()))
}
