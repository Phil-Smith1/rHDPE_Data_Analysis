library( shiny )
library( ggplot2 )
library( reticulate )
library(shinyauthr)
library(tidyverse)
library(plotly)
library(thematic)

user_base <- tibble::tibble(
  
  user = c( "psmith", "admin", "tmcdonald", "standard" ),
  password = sapply( c( "pass1", "pass2", "pass3", "pass4" ), sodium::password_store ),
  permissions = c( "admin", "admin", "admin", "standard" ),
  name = c( "Phil", "Admin", "Tom", "User1" )
  
)

datasets <- c( "FTIR", "DSC", "TGA", "Rheology", "Tensile Testing", "Colour", "SHM", "TLS", "ESCR" )
samples <- c( "rHDPE Mothylene PC-B 111 (natural)", "rHDPE Mothylene PC-B 121 (white)", "White HD E80 PWP rHDPE (sire)", "Suminco Sum rHDPE 32SF03 Gry04 (grey)", "AKPOL resin P-201008-00009", "AKPOL resin P-201116-00003", "AKPOL resin P-201008-00006", "Veolia Multithene 1070 white", "AKPOL resin P-201008-00008", "rHDPE Mothylene PC-B 151 (blue)", "Umincorp rHDPE Batch 2 (HDPE+antioxidants+antiodour)", "Natural HD E80 PWP rHDPE (sire)", "rHDPE Mothylene PC-B 141 (green)", "Umincorp rHDPE Batch 1(HDPE + antioxidants)", "Veolia Natural rHDPE", "Hostalen ACP 5231D HDPE", "HHM5502BN Resin", "KWR102BM rHDPE Resin-HBPC STOCK", "Lyondell Basell ACP 5831D", "HDPE 19889B", "HDPE 42920J (3573)", "HDPE 142366GO (3508)", "HDPE 42593J (3478)", "Cabelma Grey", "Cabelma White", "Cipitene Jazz", "Envicco Natural LotA", "Envicco Natural LotB", "Envicco White", "Extrupet", "Lucro", "Mothylene White", "MrGreen", "Myplas Mypolen", "PACT", "Reciclar Grey", "Reciclar Silk", "Recraft", "Viridor deo P2" )

content_analysis <- read_csv( "Input/Content_Analysis/Mean_Features.csv" ) %>% select( -...1 ) %>% mutate_at( vars(sample), as.integer )

ui <- fluidPage(
  
  theme = bslib::bs_theme( bootswatch = "cyborg" ),

  titlePanel( "Welcome to the PCR Predictor Tool" ),
  
  div( class = "float-right", shinyauthr::logoutUI( id = "logout" ) ),
  
  shinyauthr::loginUI( id = "login" ),

  tabsetPanel(
    tabPanel("PCA",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput( "cb", "Select datasets:", choiceNames = datasets, choiceValues = c( 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L ) ),
          actionButton( "compute", "Compute PCA of selected datasets" )
        ),
        mainPanel(
          imageOutput( "PCA" ),
          # htmlOutput( "PCA" ),
          verbatimTextOutput( "info" )
        )
      )
    ),
    
    tabPanel("Content Analysis",
       sidebarLayout(
         sidebarPanel(
           selectInput( "si", "Select resin:", choices = setNames( c( 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 22L, 23L, 401L, 402L, 403L, 404L, 405L, 406L, 407L, 408L, 409L, 410L, 411L, 412L, 413L, 414L, 415L, 416L ), samples ) )
         ),
         mainPanel(
          plotlyOutput( "PP" ),
          plotlyOutput( "PET" )
         )
       )
    ),
    
    # tabPanel("Content Analysis",
    #   fluidRow(
    #     column(4, style = "height:200px;background-color:#4d3a7d;",
    #       selectInput( "si", "Select resin:", choices = setNames( c( 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 22L, 23L, 401L, 402L, 403L, 404L, 405L, 406L, 407L, 408L, 409L, 410L, 411L, 412L, 413L, 414L, 415L, 416L ), samples ), width = "100%" )
    #     ),
    #     column(8,
    #       plotlyOutput( "PP" ),
    #       plotlyOutput( "PET" )
    #     )
    #   )
    # ),
    
    tabPanel("Sample List",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput( "cb2", "Select datasets:", choiceNames = datasets, choiceValues = c( 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L ) ),
          actionButton( "compute2", "Compute PCA of selected datasets" )
        ),
        mainPanel(
          imageOutput( "PCA2" ),
          # htmlOutput( "PCA2" ),
          verbatimTextOutput( "info2" )
        )
      )
    )
  )
)

PYTHON_DEPENDENCIES = c( 'pip', 'numpy', 'numbers-parser', 'pandas', 'scipy', 'scikit-learn', 'distinctipy', 'matplotlib', 'adjustText', 'openpyxl', 'rpy2' )

virtualenv_name = Sys.getenv( "VIRTUALENV_NAME" )
python_path = Sys.getenv( "PYTHON_PATH" )

virtualenv_create( envname = virtualenv_name, python = python_path )
virtualenv_install( virtualenv_name, packages = PYTHON_DEPENDENCIES, ignore_installed = FALSE )
use_virtualenv( virtualenv_name, required = T )

Global_Analysis <- import( "Global_Analysis_2" )

directory = ""

input_parameters = Global_Analysis$Input_Parameters_Class$Input_Parameters()

input_parameters$datasets_to_read = c( 1L, 2L, 3L, 4L, 5L, 6L )
input_parameters$sample_mask = c( 11L, 14L, 10L, 4L, 13L, 21L, 23L, 18L, 22L, 20L, 2L, 3L, 17L, 16L, 19L, 1L, 15L, 12L, 6L, 5L, 7L, 9L, 8L, 24L )
input_parameters$read_files = TRUE
input_parameters$pca = TRUE

server <- function( input, output ) {
  
  thematic::thematic_shiny()
  
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    log_out = reactive( logout_init() )
  )
  
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  read_cb <- eventReactive( input$compute, input$cb )
  int_cb <- eventReactive( input$compute, list( strtoi( read_cb() ) )[[1]] )
  
  output$PCA <- renderImage({
    
    req(credentials()$user_auth)
    
    input_parameters$datasets_to_read <- int_cb()
    
    Global_Analysis$Analysis$Global_Analysis_Main( directory, input_parameters )
    
    list(
      src = file.path( "www/Output/PCA/Overall.png" ),
      contentType = "image/png",
      width = 400,
      height = 400
    )
    
  }, deleteFile = FALSE )
  
  value_pp <- reactive( content_analysis %>% filter(sample == input$si) %>% pull( 2 ) )
  value_pet <- reactive( content_analysis %>% filter(sample == input$si) %>% pull( 6 ) )
  
  output$PP <- renderPlotly({
    
    fig <- plot_ly(
    domain = list(x = c(0, 1), y = c(0, 0.8)),
    value = value_pp(),
    title = list(text = "Polypropylene Contamination"),
    type = "indicator",
    mode = "gauge+number",
    gauge = list(
      axis = list(range = c(0, 1)),
      steps = list(
      list(range = c(0, 0.08), color = "green"),
      list(range = c(0.08, 0.5), color = "orange"),
      list(range = c(0.5, 1), color = "red")),
      bar = list(color = "lightblue"))) %>%
      layout(margin = list(l=20,r=20, t=20))})
  
  output$PET <- renderPlotly({

    fig <- plot_ly(
      domain = list(x = c(0, 1), y = c(0, 0.8)),
      value = value_pet(),
      title = list(text = "PET Contamination"),
      type = "indicator",
      mode = "gauge+number",
      gauge = list(
        axis = list(range = c(0, 1)),
        steps = list(
          list(range = c(0, 0.25), color = "green"),
          list(range = c(0.25, 1), color = "orange")),
        bar = list(color = "lightblue"))) %>%
      layout(margin = list(l=20,r=20, t=20))})
  
  # output$PCA <- renderUI({
  #   input_parameters$datasets_to_read <- int_cb()
  #   # Global_Analysis_Main( directory, input_parameters )
  #   Global_Analysis$Analysis$Global_Analysis_Main(directory, input_parameters)
  #   tags$iframe(style = 'height: 650px; width: 500px;', src = "Output/PCA/Overall.pdf")
  #   # return(paste('<iframe style="height:600px; width:500px" src="Output/PCA/Overall.pdf"></iframe>', sep = ""))
  #   })
  # output$myImage <- renderUI({
  #   if (input$toggle == "PDF") {
  #     tags$iframe(style = 'height: 680px; width: 960px;',
  #                 src = 'test.pdf')
  #   } else if (input$toggle == "PNG") {
  #     tags$img(style = 'height: 680px; width: 960px;',
  #              src = 'test.pdf')
  #   }
  # })
  
  output$info <- renderPrint({
    
    req(credentials()$user_auth)
    
    print( "Datasets included are:" )
    print( datasets[int_cb()] )
    
  })
}

shinyApp( ui, server )