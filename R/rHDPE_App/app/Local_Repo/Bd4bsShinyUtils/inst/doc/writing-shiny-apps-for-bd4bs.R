## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setupfilestore, eval=FALSE------------------------------------------
#  library("Bd4bsShinyUtils")
#  
#  shinyServer(function(input, output, session){
#  
#    #set up the local filestore (this is session-level storage)
#    #this is stored in working_directory/tmp/filestore/<<session id>>
#    filestore_location <- Bd4bsShinyUtils::setup_local_filestore(session)
#  
#    #destroy the local filestore when user session ends
#    onSessionEnded(function() Bd4bsShinyUtils::destroy_local_filestore(filestore_location))
#  
#    ######
#  
#    #Rest of shiny app here

## ----extract, eval=FALSE-------------------------------------------------
#  observeEvent(input$extract_button, {
#    showModal(Bd4bsShinyUtils::extract_platform_UI("extract_ui", default_value="", title = "Extract file"))
#  })
#  
#  extracted_file <- callModule(Bd4bsShinyUtils::extract_platform, "extract_ui", filestore_location)

## ----access_file_store, eval=FALSE---------------------------------------
#  file_contents <- reactive({
#    req(extracted_file())
#    access_local_filestore(filestore_location, extracted_file(),
#                         file_read_function=readLines, n=100)
#    })

## ----search_mode, eval=FALSE---------------------------------------------
#  observeEvent(input$search_button,{
#    showModal(Bd4bsShinyUtils::search_platform_UI("search_ui"))
#  })
#  
#  saved_files_from_search <- callModule(Bd4bsShinyUtils::search_platform, "search_ui", filestore_location)

## ----search_file_read, eval=FALSE----------------------------------------
#  
#  file_ids <- reactive({
#    req(saved_files_from_search())
#    saved_files_from_search()[, "Id"]
#  })
#  
#  first_file_contents <- reactive({
#    req(file_ids())
#    access_local_filestore(filestore_location, file_ids()[1],
#                         file_read_function=readLines, n=100)
#  })

## ----keyvaluefield, eval=FALSE-------------------------------------------
#  list(list(Key=jsonlite::unbox("string_key"), CategoryPath=character(0),
#            Value=jsonlite::unbox("example_value"), Type=jsonlite::unbox("STRING")),
#       list(Key=jsonlite::unbox("number_key"), CategoryPath=character(0),
#            Value=jsonlite::unbox(67.87), Type=jsonlite::unbox("NUMBER")),
#       list(Key=jsonlite::unbox("boolean_key"), CategoryPath=character(0),
#            Value=jsonlite::unbox(TRUE), Type=jsonlite::unbox("BOOLEAN")),
#       list(Key=jsonlite::unbox("date_key"), CategoryPath=character(0),
#            Value=jsonlite::unbox(1388534400000), Type=jsonlite::unbox("DATE"))
#       )

## ----dev_mode, eval=FALSE------------------------------------------------
#  options(Bd4bsShinyUtils.dev_mode = TRUE)
#  options(Bd4bsShinyUtils.dev_dir="path/to/directory")

