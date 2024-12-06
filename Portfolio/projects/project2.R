# project2UI - UI Function for Project 2
project2UI <- function(id) {
  ns <- NS(id)
  tagList(
    # UI for embedding the PDF
    tags$iframe(style="height:600px; width:100%", src="project2.pdf")
  )
}

# project2Server - Server Function for Project 2
project2Server <- function(input, output, session) {
  # No additional server-side logic needed to display the PDF
}
