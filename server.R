# Define server ----
server <- function(input, output, session) {

  # Call modules
  circlesServer("circles")
  bubblesServer("bubbles")
  bullseyeServer("bullseye")
  fractalsServer("fractals")
  vortexServer("vortex")
  wavesServer("waves")
  fadingServer("fading")
  linesServer("lines")

  # Source code link
  url <- a("GitHub", href="https://github.com/nrennie/aRt")
  output$gh_link <- renderUI({
    tagList("The source code for this aRt can be found on ", url)
  })

  # Footer
  output$footer <- renderText({
    "© Nicola Rennie. 2023."
  })

}
