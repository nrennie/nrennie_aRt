# Define UI ----
ui <- fluidPage(

  # Add waiting screen ----
  autoWaiter(),

  # Set theme ----
  theme = shinytheme("slate"),

  # App title ----
  titlePanel(
    h1("aRt: Generative Art in R", align = "center"),
    windowTitle = "aRt: Generative Art in R"
  ),

  hr(),

  # Tab panels ----
  tabsetPanel(type = "tabs", id = "tabs",
              circlesUI("circles"),
              bubblesUI("bubbles"),
              bullseyeUI("bullseye"),
              fractalsUI("fractals"),
              vortexUI("vortex"),
              wavesUI("waves"),
              fadingUI("fading")
  ),

  hr(),

  # Footer ----
  fluidRow(column(12, align="center", uiOutput("gh_link"))),
  fluidRow(column(12, align="center", textOutput("footer")))
)
