 ui <- dashboardPage(
  
  dashboardHeader(title = "Predicciones ML"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("ML Prediction", tabName = "Tab0", icon = icon("info-circle"))
    
    ),
    # add UI elements for selecting the explanatory and explained variables
    selectInput("expl", "Explanatory variable:",
                choices = strsplit(colnames(data)[-1], ";")[[1]],
                selected = colnames(data)[1]),
    
    selectInput("expd", "Explained variable:",
                choices = strsplit(colnames(data)[-1], ";")[[1]],
                selected = colnames(data)[2]),
  
    # add a button to load the data
    actionButton("load", "Load data")
  ),
  
  dashboardBody(
    
    tabItems(
      
      tabItem(
        tabName = "Tab0",
        # add UI elements for other features such as balancing, variable selection, etc.
        # add a plotly plot to display the ROC curve and its AUC
        plotlyOutput("roc_plot")
      )
      
    )
    
  )
  
)
