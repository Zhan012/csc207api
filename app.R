#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
  titlePanel("Data Analysis Application"),
  sidebarLayout(
    sidebarPanel(
      textInput("yIndex", "Y Index (e.g., 1):"),
      textInput("xIndex", "X Index (e.g., 1,3,5):"),
      selectInput("modelSelection", "Model Selection:", choices = c("Linear Model")),
      actionButton("predictButton", "Predict")
    ),
    mainPanel(
      h4("Prediction Result:"),
      verbatimTextOutput("prediction"),
      verbatimTextOutput("errorOutput")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$predictButton, {
    # Read the data from your CSV file
    data <- read.csv("City of Toronto Free Public WiFi - 4326.csv", header = TRUE)
    
    # Parse user inputs
    yIndex <- as.numeric(input$yIndex)
    xIndex <- as.numeric(unlist(strsplit(input$xIndex, ",")))
    
    # Check if 'y' variable is numeric
    if (!is.numeric(data[, yIndex])) {
      output$errorOutput <- renderText({
        "Error: 'Y' variable is not numeric."
      })
      return()
    }
    
    # Check if 'x' variables are numeric
    for (index in xIndex) {
      if (!is.numeric(data[, index])) {
        output$errorOutput <- renderText({
          paste("Error: 'X' variable at index", index, "is not numeric.")
        })
        return()
      }
    }
    
    # Data Cleaning: Remove rows with missing values
    data <- na.omit(data)
    
    # Find the shortest column length
    shortest_col_length <- min(sapply(data[, c(yIndex, xIndex)], length))
    
    # Subset data to match the shortest column length
    data <- data[1:shortest_col_length, ]
    
    # Extract selected columns from the data
    y <- data[, yIndex]
    x <- data[, xIndex]
    
    # Perform linear regression
    model <- lm(y ~ x)
    
    # Get the prediction
    prediction <- predict(model)
    
    # Display the prediction
    output$prediction <- renderText({
      paste("Predicted Value:", round(prediction, 2))
    })
  })
}

shinyApp(
  ui = ui,
  server = server,
  options = list(port = 2763)
)


