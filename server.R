 server <- function(input, output, session) {
  
  # reactive variable to store the loaded data
  data_loaded <- reactiveVal(FALSE)
  
  # load the data when the button is clicked
  observeEvent(input$load, {
    data <- read.csv("LOGIT.csv", sep = ";", header = TRUE, stringsAsFactors = FALSE)
    data_loaded(TRUE)
    data <- data %>% 
      mutate_all(as.character) # convert all columns to character type
  })
  
  # reactive variable for the explanatory variable
  x_var <- reactive({
    req(input$expl)
    input$expl
  })
  
  # reactive variable for the explained variable
  y_var <- reactive({
    req(input$expd)
    input$expd
  })
  
  # reactive expression to prepare the data for modeling
  data_for_model <- reactive({
    req(data_loaded())
    if (is.data.frame(data_loaded())) {
      data_loaded() %>% 
        drop_na(c(input$expl, input$expd)) %>%
        select(input$expl, input$expd) %>%
        mutate_at(vars(all_of(c(input$expl, input$expd))), as.numeric)
    }
  })
  
  # reactive expression to generate the ROC plot
  roc_plot <- reactive({
    req(data_for_model())
    glm_model <- glm(as.formula(paste0(y_var(), "~", x_var())), data = data_for_model(), family = binomial)
    pred_probs <- predict(glm_model, type = "response")
    roc_data <- data.frame(fpr = 1 - specificity(pred_probs, data_for_model()[[y_var()]]),
                           tpr = sensitivity(pred_probs, data_for_model()[[y_var()]]))
    plot_ly(data = roc_data, x = ~fpr, y = ~tpr, type = "scatter", mode = "lines") %>%
      add_trace(x = c(0, 1), y = c(0, 1), type = "scatter", mode = "lines", line = list(dash = "dash"))
  })
  
  # output the ROC plot
  output$roc_plot <- renderPlotly({
    req(roc_plot())
    roc_plot()
  })
  
}

