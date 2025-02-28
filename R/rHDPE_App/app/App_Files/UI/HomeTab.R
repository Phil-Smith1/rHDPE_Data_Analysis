# Tab for Home.

homeTab <- tabPanel( "Home",
                    
  fluidPage(
    
    br(),
    
    wellPanel(
      
      tags$ul(
        
        tags$li( "Welcome to the PCR Predictor Tool. This tool has been designed as a place where HDPE PCR data can be uploaded and analysed." ),
        tags$li( paste0( "If you have any questions, comments or feedback about this tool, please contact Phil Smith via ", email, " who will be happy to hear from you." ) )
        
      )
      
    ),
    
    wellPanel(
      
      p( "Select the type of user for the tool. You can choose from:" ),
      
      tags$ul(
        
        tags$li( "Business User: Displays only the simplest functions." ),
        tags$li( "Analyst: Displays additional functions that allow more in-depth analysis of the dataset." ),
        tags$li( "Development: Displays all functions, including work-in-progress functions and functions useful for developers." )
        
      ),
      
      selectInput( "home_app_mode_si", "Select the app mode", choices = c( "Business User", "Analyst", "Development" ), width = "40%" )
      
    ),
    
    wellPanel(
      
      selectInput( "home_dataset_version_si", "Select the version of the dataset to use", choices = NULL, width = "40%" ),
      
      tags$ul(
        
        tags$li( "'Original' is the original dataset, and can't be deleted or modified." ),
        tags$li( "You can create your own dataset by going to 'Settings' and cloning an existing dataset. Any such dataset can then be modified (e.g. data can be uploaded to it)." ),
        
      )
      
    ),
    
    wellPanel(
      
      p( "Documentation for each tab:" ),
      
      tags$ul(
        
        tags$li( "Home:" ),
        tags$ul(
        
          tags$li( "You are on this tab." ),
          tags$li( "It contains information about the app and certain parameters that you can change, such as the app mode and the dataset version." )
        
        ),
        
        br(),
        
        tags$li( "PP% Prediction (FTIR):" ),
        tags$ul(
          
          tags$li( "In this tab, we take FTIR data for a given HDPE resin and make a prediction of the polypropylene (PP) contamination." ),
          tags$li( "You can select the resin you would like to see the PP contamination of on the left-hand side. If you have uploaded new FTIR data, this will appear here." ),
          tags$li( "The model makes a prediction of the PP content at six characteristic wavenumbers of PP." ),
          tags$li( "Hence, six predictions are made for every repetition of the FTIR experiment on the resin." ),
          tags$li( "In the tab, the final prediction, an average of all predictions made across wavenumbers and repeats, is displayed at the top. Below this gauge is information on predictions for each repeat and each wavenumber" )
          
        ),
        
        br(),
        
        tags$li( "ESCR Prediction:" ),
        tags$ul(
          
          tags$li( "In this tab, we make a prediction of the ESCR for a resin based off its characteristic data." ),
          tags$li( "The model works by predicting the strain hardening modulus (SHM), and using the correlation between SHM and ESCR to make an ESCR prediction." ),
          tags$li( "To make the SHM prediction, you can either use the general model that makes the prediction based off DSC, TGA and rheology data, or you can use the DSC model that just uses DSC data to make the SHM prediction (slightly less good model but only one experiment required)." )
          
        ),
        
        br(),
        
        tags$li( "PCA:" ),
        tags$ul(
          
          tags$li( "In this tab, we can perform Principal Component Analysis (PCA) on the data." ),
          tags$li( "You can select the datasets to include in the PCA on the left-hand side." ),
          tags$li( "The output can be thought of as a 2D visualisation of the data." ),
          tags$li( "Resins that are close to other resins should be thought of as similar, resins that are far apart should be thought of as diffferent." )
          
        ),
        
        br(),
        
        tags$li( "Data Visualisation:" ),
        tags$ul(
          
          tags$li( "In this tab, you can visualise the experimental data for all experiments." )
          
        ),
        
        br(),
        
        tags$li( "Resin Metadata:" ),
        tags$ul(
          
          tags$li( "This tab contains all metadata for the resins in the dataset, such as name and the experimental data available for each resin." )
          
        ),
        
        br(),
        
        tags$li( "Upload:" ),
        tags$ul(
          
          tags$li( "On this tab, you can upload new data to analyse." )
          
        ),
        
        br(),
        
        tags$li( "Save:" ),
        tags$ul(
          
          tags$li( "If you have made changes (e.g. uploaded data, deleted data, created a new dataset) and wish to make the changes permanent so that they will appear next time the app is opened, you must save progress by going to this tab and clicking the save button." )
          
        ),
        
        br(),
        
        tags$li( "Settings:" ),
        tags$ul(
          
          tags$li( "This tab contains settings for the app." ),
          tags$li( "Here, you can create and delete dataset versions." )
          
        ),
        
      )
      
    ), theme = app_theme # Without this, pickerInput breaks because of a compatibility issue, see https://stackoverflow.com/questions/78447375/strange-behavior-of-pickerinput-how-to-resolve-it
    
  )
  
)