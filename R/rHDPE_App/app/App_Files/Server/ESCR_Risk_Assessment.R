# ESCR risk assessment tab server code.

escrra_pp_results <- reactive( pp_analysis( pp_percentages, input$ESCRRA_select_resin_si ) )

output$ESCRRA_PP_po <- renderPlotly({
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = escrra_pp_results()[[1]], number = list( suffix = "%" ), title = list( text = "Polypropylene Contamination" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 15 ) ),
      steps = list( list( range = c( 0, 2 ), color = "green" ), list( range = c( 2, 5 ), color = "orange" ), list( range = c( 5, 15 ), color = "red" ) ),
      bar = list( color = "lightblue" )
    )
  ) %>% layout( margin = list( l = 20, r = 20, t = 20 ) )
  
})

output$ESCRRA_PP_ui <- renderUI({
  
  HTML(
    
    ifelse( escrra_pp_results()[[1]] < 2,
            
            as.character( div( style = "color: green; font-size: 40px", "This level of PP contamination should not be particularly detrimental to ESCR." ) ),
            
            ifelse( escrra_pp_results()[[1]] < 5,
                    
                    as.character( div( style = "color: orange; font-size: 40px", "This level of PP contamination may be detrimental to ESCR." ) ),
                    
                    as.character( div( style = "color: red; font-size: 40px", "This level of PP contamination will likely be detrimental to ESCR." ) )
                    
            )
            
    )
    
  )
  
})

escrra_mw_value <- reactive( unnormalised_rheology_data %>% filter( sample == input$ESCRRA_select_resin_si ) %>% pull( Rhe_Crossover ) )

output$ESCRRA_MW_po <- renderPlotly({
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = escrra_mw_value(), number = list( suffix = "%" ), title = list( text = "Molecular Weight (Rheology Crossover)" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 2 ) ),
      steps = list( list( range = c( 0, 1.1 ), color = "green" ), list( range = c( 1.1, 1.5 ), color = "orange" ), list( range = c( 1.5, 2 ), color = "red" ) ),
      bar = list( color = "lightblue" )
    )
  ) %>% layout( margin = list( l = 20, r = 20, t = 20 ) )
  
})

output$ESCRRA_MW_ui <- renderUI({
  
  HTML(
    
    ifelse( escrra_mw_value() < 1.1,
            
            as.character( div( style = "color: green; font-size: 40px", "This indicator of molecular weight should not be particularly detrimental to ESCR." ) ),
            
            ifelse( escrra_mw_value() < 1.5,
                    
                    as.character( div( style = "color: orange; font-size: 40px", "This indicator of molecular weight may be detrimental to ESCR." ) ),
                    
                    as.character( div( style = "color: red; font-size: 40px", "This indicator of molecular weight will likely be detrimental to ESCR." ) )
                    
            )
            
    )
    
  )
  
})

escrra_shm_value <- reactive( unnormalised_shm_data %>% filter( sample == input$ESCRRA_select_resin_si ) %>% pull( SHM ) )

output$ESCRRA_SHM_po <- renderPlotly({
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = escrra_shm_value(), number = list( suffix = "%" ), title = list( text = "Strain Hardening Modulus" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 15 ) ),
      steps = list( list( range = c( 0, 6.25 ), color = "red" ), list( range = c( 6.25, 8.75 ), color = "orange" ), list( range = c( 8.75, 15 ), color = "green" ) ),
      bar = list( color = "lightblue" )
    )
  ) %>% layout( margin = list( l = 20, r = 20, t = 20 ) )
  
})

output$ESCRRA_SHM_ui <- renderUI({
  
  HTML(
    
    ifelse( escrra_shm_value() > 8.75,
            
            as.character( div( style = "color: green; font-size: 40px", "This value of SHM should not be particularly detrimental to ESCR." ) ),
            
            ifelse( escrra_shm_value() > 6.25,
                    
                    as.character( div( style = "color: orange; font-size: 40px", "This value of SHM may be detrimental to ESCR." ) ),
                    
                    as.character( div( style = "color: red; font-size: 40px", "This value of SHM will likely be detrimental to ESCR." ) )
                    
            )
            
    )
    
  )
  
})

