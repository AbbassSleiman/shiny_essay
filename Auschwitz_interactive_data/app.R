library(shiny)
library(ggplot2)
library(dplyr)
library(here)
library(readr)
library(DT)
library(rsconnect)

Auschwitz_data <- read_csv(here("Auschwitz_interactive_data/cleaned_Auschwitz_data.csv"))

# UI
ui <- fluidPage(
  titlePanel("Auschwitz Victims"),
  
  sidebarLayout(
    sidebarPanel(
      # Input for selecting groups
      selectInput("categories", "Select Category:",
                  choices = c("Religion", "Birthplace", "Residence"),
                  selected = "Religion"),
      uiOutput("category_checkbox")
    ),
    
    mainPanel(
      plotOutput("graph"),
      DTOutput("table")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Render checkbox for Religion
  output$category_checkbox <- renderUI({
    if (input$categories == "Religion") {
      checkboxGroupInput("ChosenReligions",
                         "Select Religions:",
                         choices = unique(Auschwitz_data$religion))
    }
  })
  
  # Render graph
  output$graph <- renderPlot({
    if (input$categories == "Religion") {
      specified_religions <- input$ChosenReligions
      categorized_religion_data <- Auschwitz_data |>
        filter(religion %in% specified_religions) |>
        group_by(religion) |>
        summarize(Count = n())
      
      ggplot(categorized_religion_data, aes(x = religion, y = Count, fill = religion)) +
        geom_bar(stat = "identity") +
        theme_classic() +
        labs(x = "Religion", y = "Number of Victims", title = "Auschwitz Victims by Religion") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
    
  })
  
  output$table <- renderDT({
    # Initialize data variable
    data <- NULL
    
    # Filter data based on selected category
    if (input$categories == "Religion") {
      # Count the number of victims for each religion
      data <- Auschwitz_data |>
        group_by(religion) |>
        summarize(Count = n())
    } else if (input$categories == "Birthplace") {
      # Count the number of victims for each birthplace
      data <- Auschwitz_data |>
        group_by(birthplace) |>
        summarize(Count = n())
    } else if (input$categories == "Residence") {
      # Count the number of victims for each residence
      data <- Auschwitz_data |>
        group_by(residence) |>
        summarize(Count = n())
    }
    
    # Render table
    datatable(data)
  })
}

# Run the application
shinyApp(ui = ui, server = server)