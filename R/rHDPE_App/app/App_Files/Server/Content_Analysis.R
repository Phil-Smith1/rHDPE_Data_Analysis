# Content analysis tab server code.

CA_value_pp <- reactive( pp_analysis( pp_percentages, input$CA_select_resin_si )[[1]] )
CA_value_pet <- reactive( content_analysis %>% filter( sample == input$CA_select_resin_si ) %>% pull( 6 ) )

output$CA_PP_po <- renderPlotly({
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = CA_value_pp(), number = list( suffix = "%" ), title = list( text = "Polypropylene Contamination" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 15 ) ),
      steps = list( list( range = c( 0, 2 ), color = "green" ), list( range = c( 2, 5 ), color = "orange" ), list( range = c( 5, 15 ), color = "red" ) ),
      bar = list( color = "lightblue" )
    )
  ) %>% layout( margin = list( l = 20,r = 20, t = 20 ) )
  
})

output$CA_PET_po <- renderPlotly({
  
  fig <- plot_ly( domain = list( x = c( 0, 1 ), y = c( 0, 0.8 ) ), value = CA_value_pet(), title = list( text = "PET Contamination" ),
    type = "indicator", mode = "gauge+number",
    gauge = list(
      axis = list( range = c( 0, 1 ) ),
      steps = list( list( range = c( 0, 0.25 ), color = "green" ), list( range = c( 0.25, 1 ), color = "orange" ) ),
      bar = list( color = "lightblue" )
    )
  ) %>% layout( margin = list( l = 20, r = 20, t = 20 ) )
  
})



