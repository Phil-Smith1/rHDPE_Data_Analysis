# Settings Home server code.

observeEvent( input$home_app_mode_si, {
  
  if (input$home_app_mode_si == "Business User") {
    
    hideTab( "tabsetPanel", "Content Analysis" )
    hideTab( "tabsetPanel", "Feature Correlations" )
    hideTab( "tabsetPanel", "ESCR Risk Assessment" )
    hideTab( "tabsetPanel", "File Data" )
    hideTab( "tabsetPanel", "DataLab" )
    hideTab( "tabsetPanel", "Dev" )
    
  }
  
  if (input$home_app_mode_si == "Analyst") {
    
    hideTab( "tabsetPanel", "Content Analysis" )
    showTab( "tabsetPanel", "Feature Correlations" )
    hideTab( "tabsetPanel", "ESCR Risk Assessment" )
    hideTab( "tabsetPanel", "File Data" )
    hideTab( "tabsetPanel", "DataLab" )
    hideTab( "tabsetPanel", "Dev" )
    
  }
  
  if (input$home_app_mode_si == "Development") {
    
    showTab( "tabsetPanel", "Content Analysis" )
    showTab( "tabsetPanel", "Feature Correlations" )
    showTab( "tabsetPanel", "ESCR Risk Assessment" )
    showTab( "tabsetPanel", "File Data" )
    showTab( "tabsetPanel", "DataLab" )
    showTab( "tabsetPanel", "Dev" )
    
  }
  
})