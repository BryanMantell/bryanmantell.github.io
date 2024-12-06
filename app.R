# Install and Load Required Packages
All_Packages <- c("shiny", "shinylive", "shinythemes", "dplyr", "DT",   "httpuv")

# Install missing packages
New_Packages <- setdiff(All_Packages, installed.packages()[, "Package"])
if (length(New_Packages)) install.packages(New_Packages)

# Load all packages dynamically
invisible(lapply(All_Packages, library, character.only = TRUE))

# Clear Global Environment
rm(list = ls())

# Source the project files
source("projects/project1.R")
source("projects/project2.R")

# Main UI
ui <- navbarPage(
  title = "My Portfolio",
  theme = shinytheme("flatly"),
  collapsible = TRUE,
  
  # Home Tab
  tabPanel(
    "Home",
    fluidPage(
      titlePanel("Welcome to My Portfolio"),
      fluidRow(
        column(12, h3("About Me")),
        column(12, p("I am a Data Scientist with expertise in R, Python, machine learning, and data visualization."))
      ),
      fluidRow(
        column(6,
               h4("Skills"),
               tags$ul(
                 tags$li("R Programming"),
                 tags$li("Python"),
                 tags$li("Machine Learning"),
                 tags$li("Data Visualization"),
                 tags$li("Cloud Computing"),
                 tags$li("EEG and fMRI Data Processing")
               )
        ),
        column(6,
               h4("Experience"),
               p("7+ years of experience, including Stanford University RAPID Project, National Eczema Association, and more.")
        )
      )
    )
  ),
  
  # Projects Tab
  tabPanel(
    "Projects",
    fluidPage(
      titlePanel("My Projects"),
      fluidRow(
        column(4,
               h4("Audience Segmentation Tool"),
               p("A dashboard designed to empower non-technical staff to interact with a database and generate user ID lists based on specific filtering criteria."),
               actionButton("view_proj1", "View Project")
        ),
        column(4,
               h4("Project 2 - PDF Example"),
               p("A sample project demonstrating how to display a PDF."),
               actionButton("view_proj2", "View Project")
        )
      )
    )
  )
)

# Main Server
server <- function(input, output, session) {
  # Manage navigation to Project 1
  observeEvent(input$view_proj1, {
    showModal(modalDialog(
      title = "Audience Segmentation Tool",
      size = "l",
      project1UI("proj1"),
      footer = modalButton("Close")
    ))
  })
  
  # Call Project 1 module
  callModule(project1Server, "proj1")
  
  # Manage navigation to Project 2
  observeEvent(input$view_proj2, {
    showModal(modalDialog(
      title = "Project 2 - PDF Report",
      size = "l",
      project2UI("proj2"),
      footer = modalButton("Close")
    ))
  })
  
  # Call Project 2 module
  callModule(project2Server, "proj2")
}

# Run the app
shinyApp(ui, server)

# Render app
shinylive::export(appdir = "C:\\Users\\bryan\\OneDrive\\Documents\\GitHub\\bryanmantell.github.io", destdir = "docs")
