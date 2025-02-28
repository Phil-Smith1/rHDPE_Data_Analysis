#server module for individual key-value filters on the search dialog box
#id_for_visibility (not reactive) - an id used to show/hide the ui
#add_labels (not reactive) - logical - should the UI have labels
#returns a list containing the following elements: Key, Type, Values which
#are converted to JSON in access_data_gateway_by_Search.
key_value_filter <- function(input, output, session, id_for_visibility, add_labels=FALSE){

  ns <- session$ns

  ###
  #functions
  add_labels_to_components <- function(label_text){
    if(add_labels) label_text else ""
  }

  ###
  # reactives
  key_name <- reactive({
    shiny::validate({need(trimws(input$key)!= "","Keys cannot be empty")})
    input$key
  })

  type <- reactive({
    input$type
  })

  values <- reactive({
    if(input$type=="boolean"){
      #normally would use req(input$value_boolean) but that doesn't work as
      #"FALSE" is an allowed value of the component so using req(FALSE)
      #when input$value_boolean is not yet rendered (i.e. is NULL)
      if(!is.null(input$value_boolean)){
        return(as.logical(input$value_boolean)) #as logical needed for the json
      }else{
        req(FALSE)
      }
    }
    if(input$type=="date"){
      req(input$value_date)
      return(list(From=unbox(1000*as.numeric(as.POSIXct(input$value_date[1]))),
                  To=unbox(1000*as.numeric(as.POSIXct(input$value_date[2])))))

    }
    if(input$type=="string"){
      req(!is.null(input$value_string))
      shiny::validate({need(trimws(input$value_string) != "", "String key-values cannot be empty and should be comma separated list")})
      return(unlist(strsplit(input$value_string, ",")))
    }
    if(input$type=="number"){
      req(!is.null(input$value_number))

      splitted_text <- trimws(unlist(strsplit(input$value_number, ":")))
      shiny::validate({need( length(splitted_text)==2, "Number key-values should be in the format from:to")})
      shiny::validate({need( all(!is.na(as.numeric(splitted_text))) &&
                               as.numeric(splitted_text[1]) <= as.numeric(splitted_text[2]),
                             "Number key-values should be in the format from:to with from <= to")})
      return(list(From=unbox(as.numeric(splitted_text[1])),
                  To=unbox(as.numeric(splitted_text[2]))))

    }
  })

  values_for_query <- reactive({
    req(key_name())
    if(input$type!="boolean"){ #Note values can be false in Boolean case...
      req(values())
    }
    list(Key=unbox(key_name()), Type=unbox(type()), Values=values())
  })


  ###
  # outputs
  output$ui <- renderUI(
    div(id=id_for_visibility,
      fluidRow(
        column(2, selectInput(ns("type"), add_labels_to_components("Type"),
                            c("string", "number", "boolean", "date"))),
        column(4, textInput(ns("key"), add_labels_to_components("Enter key"))),
        column(6, uiOutput(ns("value_ui")))
      )
    )
  )

  output$value_ui <- renderUI({
    req(input$type)
    if(input$type == "boolean"){
      return(radioButtons(ns("value_boolean"),
                         add_labels_to_components("Enter value"),
                         c(TRUE, FALSE), inline=TRUE))
    }
    if(input$type == "string"){
      return(textInput(ns("value_string"), add_labels_to_components("Enter value"),
             placeholder="string1, string2, string3"))
    }
    if(input$type == "date"){
      return(dateRangeInput(ns("value_date"), add_labels_to_components("Enter value")))
    }
    if(input$type == "number"){
      return(textInput(ns("value_number"), add_labels_to_components("Enter value"),
                       placeholder = "from:to"))
    }
  })

  return(values_for_query)
}
