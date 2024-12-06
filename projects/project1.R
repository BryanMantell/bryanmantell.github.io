# Generate placeholder data
PlaceholderData1 <- data.frame(
  userid = 1:100,
  gender = sample(c("male", "female", "non_binary", "other"), 100, replace = TRUE),
  race = sample(c("white", "black", "asian", "native", "islander", "other", "unknown"), 100, replace = TRUE),
  type = sample(c("type_1", "type_2", "type_3"), 100, replace = TRUE),
  zip = sample(10000:99999, 100, replace = TRUE)
)

# UI for Project 1
project1UI <- function(id) {
  ns <- NS(id)
  fluidPage(
    titlePanel("Audience Segmentation Tool (Example)"),
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput(ns("gender"), "Gender", 
                           choices = c("Male" = "male", 
                                       "Female" = "female", 
                                       "Non Binary" = "non_binary", 
                                       "Other" = "other")),
        checkboxGroupInput(ns("race"), "Race", 
                           choices = c("White" = "white", 
                                       "Black" = "black",
                                       "Asian" = "asian", 
                                       "Native (American Indian or Alaska Native)" = "native", 
                                       "Islander (Native Hawaiian or Other Pacific Islander)" = "islander", 
                                       "Other" = "other", 
                                       "Unknown" = "unknown")),
        checkboxGroupInput(ns("type"), "Type", 
                           choices = c("Type 1" = "type_1", 
                                       "Type 2" = "type_2", 
                                       "Type 3" = "type_3")),
        textInput(ns("zipcode"), "Enter ZIP Code(s)", placeholder = "e.g. 94707, 89402")
      ),
      mainPanel(
        h4("Filtered Data"),
        DTOutput(ns("filteredData")),
        uiOutput(ns("summary")),
        downloadButton(ns("downloadData"), "Export Filtered User IDs")
      )
    )
  )
}

# Server for Project 1
project1Server <- function(input, output, session) {
  ns <- session$ns
  total_users <- nrow(PlaceholderData1)
  
  # Filtered data logic
  filteredData <- reactive({
    filtered <- PlaceholderData1
    
    if (!is.null(input$gender)) filtered <- filtered %>% filter(gender %in% input$gender)
    if (!is.null(input$race)) filtered <- filtered %>% filter(race %in% input$race)
    if (!is.null(input$type)) filtered <- filtered %>% filter(type %in% input$type)
    
    if (input$zipcode != "") {
      user_zipcodes <- unlist(strsplit(input$zipcode, ",\\s*"))
      filtered <- filtered %>% filter(zip %in% as.integer(user_zipcodes))
    }
    
    filtered
  })
  
  # Render the filtered table
  output$filteredData <- renderDT({
    datatable(
      filteredData(),
      options = list(pageLength = 10, dom = 't'),
      style = "bootstrap",
      class = "display nowrap cell-border stripe",
      rownames = FALSE
    )
  })
  
  # Render summary of excluded/remaining users
  output$summary <- renderUI({
    remaining_users <- nrow(filteredData())
    excluded_users <- total_users - remaining_users
    HTML(paste0("<p><b>Total Users:</b> ", total_users, 
                "<br><b>Remaining Users:</b> ", remaining_users, 
                "<br><b>Excluded Users:</b> ", excluded_users, "</p>"))
  })
  
  # Download filtered data
  output$downloadData <- downloadHandler(
    filename = function() { paste("filtered_userids", Sys.Date(), ".csv", sep = "") },
    content = function(file) { write.csv(filteredData(), file, row.names = FALSE) }
  )
}
