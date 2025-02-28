# Feature correlation tab server code.

# Table output.

output$corr_table_ro <- renderReactable({
  
  req( nrow( correlation_resins_r$correlation_resins_r ) > 0 )
  
  reactable( data = correlation_resins_r$correlation_resins_r, filterable = TRUE, rownames = FALSE, selection = "multiple", showPageSizeOptions = TRUE, paginationType = "jump",
             showSortable = TRUE, highlight = TRUE, resizable = TRUE, rowStyle = list(cursor = "pointer"), onClick = "select", bordered = TRUE )
  
})

outputOptions( output, "corr_table_ro", suspendWhenHidden = FALSE )

correlation_selected_resins <- reactive( correlation_resins_r$correlation_resins_r[getReactableState( "corr_table_ro", "selected" ), "Identifier"] )

observe({
  
  selected_resins <- isolate( correlation_selected_resins() )
  
  if (!input$corr_dv1_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (!input$corr_dv2_cb) {
    
    selected_resins <- setdiff( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$corr_dv1_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_1_resins_identifiers )
    
  }
  
  if (input$corr_dv2_cb) {
    
    selected_resins <- union( selected_resins, ds_paper_2_resins_identifiers )
    
  }
  
  if (input$corr_no_virgin_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, virgin_resins_identifiers )
    
  }
  
  if (input$corr_no_pp_resins_cb) {
    
    selected_resins <- setdiff( selected_resins, pp_resins_identifiers )
    
  }
  
  updateReactable( "corr_table_ro", correlation_resins_r$correlation_resins_r, selected = match( selected_resins, correlation_resins_r$correlation_resins_r$Identifier ), page = isolate( getReactableState( "corr_table_ro", "page" ) ) )
  
})

scatterplot_x <- eventReactive( input$corr_plot_ab, input$corr_select_x_si )
scatterplot_y <- eventReactive( input$corr_plot_ab, input$corr_select_y_si )

obtain_scatterplot_data <- eventReactive( input$corr_plot_ab, {
  
  validate( need( length( correlation_selected_resins() ) > 0, "Please select the resins for which you want to do the feature correlation." ) )
  
  obtain_scatterplot_data_to_plot( global_input_parameters, scatterplot_x(), scatterplot_y(), correlation_selected_resins() )
  
})

regression_model <- reactive({
  
  model <- lm( obtain_scatterplot_data()$Y ~ obtain_scatterplot_data()$X )
  
  model
  
})

pearson <- reactive({
  
  cor( obtain_scatterplot_data()$X, obtain_scatterplot_data()$Y, method = 'pearson' )
  
})

exponential_fit_model <- reactive({
  
  if (input$corr_exponential_fit_cb) {
    
    popt <- Global_Utilities$exponential_curve_fit( obtain_scatterplot_data()$X, obtain_scatterplot_data()$Y )
    
    popt
    
  }
  
})

exponential_fit_r2 <- reactive({
  
  exp_fn <- function (x) exponential_fit_model()[[1]] * exp( exponential_fit_model()[[2]] * x ) + exponential_fit_model()[[3]]
  
  predict_values <- c()
  
  for (i in obtain_scatterplot_data()$X) {
    
    predict_values <- c( predict_values, exp_fn( i ) )
    
  }
  
  cor( obtain_scatterplot_data()$X, predict_values ) ^ 2
  
})

output$corr_po <- renderPlot({
  
  resin_colours <- c()
  resin_names <- c()
  labels <- c()
  
  for (s in seq_along( obtain_scatterplot_data()[[5]] )) {
    
    resin_colours <- c( resin_colours, rgb( list_of_colours[obtain_scatterplot_data()[[5]][s] + 1,] ) )
    resin_names <- c( resin_names, obtain_scatterplot_data()[[5]][s] )
    labels <- c( labels, resin_data_r()$Label[match( obtain_scatterplot_data()[[5]][s], resin_data_r()$Identifier )] )
    
  }
  
  resin_names_and_colours <- setNames( resin_colours, resin_names )
  
  g <- ggplot( data = obtain_scatterplot_data(), aes( x = X, y = Y, color = fct_inorder( as.factor( Resin ) ) ) )
  
  g <- g + labs( title = paste0( "Scatterplot of ", features_metadata$Axis_Label[match( scatterplot_x(), features_metadata$Feature_Label )], " vs ", features_metadata$Axis_Label[match( scatterplot_y(), features_metadata$Feature_Label )] ), x = features_metadata$Axis_Label[match( scatterplot_x(), features_metadata$Feature_Label )], y = features_metadata$Axis_Label[match( scatterplot_y(), features_metadata$Feature_Label )] )
  
  if (input$corr_add_labels_cb) {
    
    g <- g + geom_point( size = 5, show.legend = FALSE )
    
    g <- g + geom_label_repel( aes( label = labels ), size = 8, show.legend = FALSE, box.padding = 1.5, point.padding = 0.5, min.segment.length = 0.2, segment.color = 'grey50' )
    
  }
  
  else {
    
    g <- g + geom_point( size = 5 )
    
  }
  
  g <- g + scale_colour_manual( name = "Resin", values = resin_names_and_colours, label = labels )
  
  g <- g + theme( title = element_text( size = 24, hjust = 0.5 ), aspect.ratio = 1, axis.title = element_text( size = 24 ), legend.title = element_text( size = 24 ), legend.text = element_text( size = 24 ), axis.text = element_text( size = 24 ) )
  
  g <- g + geom_errorbar( aes( ymin = Y - EY, ymax = Y + EY ), size = 1.5, show.legend = FALSE ) + geom_errorbarh( aes( xmin = X - EX, xmax = X + EX ), size = 1.5, show.legend = FALSE )
  
  if (input$corr_limits_cb) {
    
    g <- g + xlim( min( obtain_scatterplot_data()$X ), max( obtain_scatterplot_data()$X ) ) + ylim( min( obtain_scatterplot_data()$Y ), max( obtain_scatterplot_data()$Y ) )
    
  }
  
  if (input$corr_regression_line_cb) {
    
    g <- g + geom_smooth( aes( group = 1 ), method = "lm", se = FALSE, show.legend = FALSE )
    
  }
  
  if (input$corr_exponential_fit_cb) {
    
    g <- g + geom_function( fun = function(x) exponential_fit_model()[[1]] * exp( exponential_fit_model()[[2]] * x ) + exponential_fit_model()[[3]], show.legend = FALSE )
    
  }
  
  if (input$corr_savefig_cb) {
    
    ggsave( "www/Output/Global/Scatterplots/App_Scatterplot_Output.png" )
    
  }
  
  g
  
})  %>% bindEvent( c( input$corr_plot_ab, input$corr_regression_line_cb, input$corr_exponential_fit_cb, input$corr_add_labels_cb, input$corr_limits_cb, input$corr_savefig_cb ) )

output$corr_r2_to <- renderText( paste0( "The R-squared value is ", summary( regression_model() )$r.squared, " and the equation of the line is y = ", regression_model()$coefficient[[2]], "x + ", regression_model()$coefficient[[1]] ) )

output$corr_pearson_to <- renderText( paste( "The Pearson correlation coefficient is", pearson() ) )

output$corr_exponential_fit_to <- renderText( paste0( "The exponential fit equation is y = ", exponential_fit_model()[[1]], " * e^(", exponential_fit_model()[[2]], " * x) + ", exponential_fit_model()[[3]] ) )

output$corr_exponential_fit_r2_to <- renderText( paste0( "The R-squared value is ", exponential_fit_r2() ) )

