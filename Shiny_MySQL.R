library(shiny)
library(DBI)

ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
  sidebarPanel(
  #numericInput("nrows", "Enter the number of rows to display:", 5),
  sliderInput('nrows', 'Select row count',
                min = 2, max = 1000, value = 5, step = 2),
  sliderInput("range","Year Released", min = 1, max = 2020, value = c(1900,1905)),
  textInput("cod", "Please Select code contains", 'IND')
  ),

  mainPanel(
    tabsetPanel(
    tabPanel("Plots", plotOutput("myPlot")),
    tabPanel("Population", tableOutput("tbl")),
    tabPanel("Code", tableOutput("code"))
    )
  )
)
)

server <- function(input, output, session) {
  
  output$myPlot = renderPlot({
  rans = c(8,9,10,10,10,11,12,12,12,13,13)
  hist(as.numeric(rans), col = "red", xlab = 'Count')
  })
  
  output$tbl <- renderTable({
  conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")
  on.exit(dbDisconnect(conn), add = TRUE)
  dbGetQuery(conn, paste0(
  "SELECT CountryCode, SUM(Population) FROM City GROUP BY CountryCode ORDER BY SUM(Population) DESC LIMIT ", input$nrows, ";"))
  })
  output$code <- renderTable({
  dbGetQuery(conn, paste0(
  "SELECT * FROM City WHERE CountryCode LIKE '%", input$cod, "%' ORDER BY Population DESC LIMIT ", input$nrows, ";"))
    
  })
}

shinyApp(ui, server)