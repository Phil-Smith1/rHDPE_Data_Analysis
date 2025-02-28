#server module for the key-value filter part of the search dialog box
#max_number_filters (not reactive) the maximum number of filters users allowed to use
#use_filters (reactive) logical are filters being used or not?
#return value: a list of key-value filter lists which will be converted
#    to JSON in access_data_gateway_by_search (this is an empty list if use_filters are false)
key_value <- function(input, output, session, max_number_filters, use_filters){

  ns <- session$ns

  ###
  #functions

  #css style string to show/hide individual key value filters
  #this is being used so that values in the individual filters do not
  #get wiped when number of filters changes
  get_styling_string <- function(number_visible){
    ans <- lapply(seq_len(max_number_filters), function(n){
      paste0("#shiny_utils_key_value_", n,"{ display:", if(n <= number_visible) "block" else "none",";}" )
    })
    paste(ans, collapse="\n")
  }

  #function which defines the indivudal filter UIs
  get_filter_ui <- function(number_filters){
    ui_components <- list()
    for(i in seq_len(number_filters)){
      ui_components[[i]] <- key_value_filterInput(ns(paste0("key_filter_",i)))
    }
    ui_components
  }

  ###
  #reactiveVal
  #styline_string_rv - see get_styling_string
  styling_string_rv  <- reactiveVal(get_styling_string(1))


  ###
  #outputs

  output$ui <- renderUI({
    req(use_filters())
    tagList(
      uiOutput(ns("styling")),
      h4("Key-Value Filters"),
      sliderInput(ns("number_filters_slider"), "Choose number of filters",
                  min=1, step=1, value=1, max=max_number_filters),
      uiOutput(ns("filter_ui"))
    )
  })

  output$styling <- renderUI({
    tags$head(tags$style(HTML(styling_string_rv())))
  })

  output$filter_ui <- renderUI({
    do.call(get_filter_ui, list(number_filters=max_number_filters))
  })

  ###
  #observeEvents

  #when slider for number of filters changes
  observeEvent(input$number_filters_slider,{
    styling_string_rv(get_styling_string(input$number_filters_slider))
  })

  ###
  #reactives
  key_value_data <- lapply(seq_len(max_number_filters), function(n){
    callModule(key_value_filter, paste0("key_filter_",n), id_for_visibility=paste0("shiny_utils_key_value_",n), add_labels=n==1)
  })

  key_value_query_list <- reactive({
    if(use_filters()){
      req(input$number_filters_slider)
      lapply(1:input$number_filters_slider, function(n) key_value_data[[n]]())
    }
    else{
      list()
    }
  })

  return(key_value_query_list)
}
