# Define UI for random distribution app ----
ui <- fluidPage(
  theme = shinytheme("slate"),

  # App title ----
  titlePanel(
    h1("aRt: Generative Art in R", align = "center"),
    windowTitle = "aRt: Generative Art in R"
  ),

  hr(),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Add spacing
      br(),

      # Plot
      fluidRow(
        column(12, align="center",
               plotOutput("plot", height="auto")
               )
        ),

      # Add spacing
      br(),

      # Download button
      fluidRow(
        column(12, align="center",
               downloadButton('downloadPlot', 'Download')
        )
      ),

      # Edit width
      width=4

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs", id = "tabs",

                  #circles
                  tabPanel("Circles", id="circles",
                           br(),
                           numericInput("circles_n", "Number of circles", value = 10, min = 1, max = 100),
                           sliderInput("circles_smoothness", "Smoothness", min = 3, max = 100, value = 50),
                           selectInput("circles_col_palette", "Colour palette",
                                       c("Bold" = "Bold",
                                         "Antique" = "Antique",
                                         "Vivid" = "Vivid",
                                         "Safe"="Safe",
                                         "Prism"="Prism",
                                         "Pastel"="Pastel")),
                           selectInput("circles_bg_col", "Background colour",
                                       c("Pink" = "#e73f74",
                                         "White" = "white",
                                         "Black" = "black"))
                  ),

                  #bubbles
                  tabPanel("Bubbles", id="bubbles",
                           br(),
                           numericInput("bubbles_n", "Number of circles", value = 7, min = 1, max = 30),
                           selectInput("bubbles_palette", "Colour palette",
                                       c("Bold" = "Bold",
                                         "Antique" = "Antique",
                                         "Vivid" = "Vivid",
                                         "Safe"="Safe",
                                         "Prism"="Prism",
                                         "Pastel"="Pastel")),
                           selectInput("bubbles_main_col", "Line colour",
                                       unique(gsub('[0-9]+', '', colors()))),
                           selectInput("bubbles_bg_col", "Background colour",
                                       rev(unique(gsub('[0-9]+', '', colors()))))
                  ),

                  #fading
                  tabPanel("Fading", id="fading",
                           br(),
                           sliderInput("fading_n_layers", "Number of layers", min = 2, max = 10, value = 6),
                           sliderInput("fading_n_points", "Number of points", min = 1, max = 10, value = 1),
                           selectInput("fading_col_palette", "Colour palette",
                                       c("Sunset" = "Sunset",
                                         "Dark Sunset" = "SunsetDark",
                                         "Teal" = "Teal",
                                         "Peach" = "Peach",
                                         "Teal Green" = "TealGrn",
                                         "Red Orange" = "RedOr",
                                         "Purple Orange" = "PurpOr",
                                         "Purple" = "Purp",
                                         "Orange Yellow" = "OrYel",
                                         "Mint" = "Mint",
                                         "Dark Mint" = "DarkMint",
                                         "Magenta" = "Magenta",
                                         "Emerald" = "Emrld",
                                         "Burgundy" = "Burg"))
                  ),

                  #bubbles
                  tabPanel("Fractals", id="fractals",
                           br(),
                           numericInput("fractals_n", "Number of iterations", value = 25, min = 5, max = 30),
                           selectInput("fractals_palette", "Colour palette",
                                       names(MetBrewer::MetPalettes)),
                           numericInput("fractals_y", "Growth rate", value = 3, min = 1, max = 5),
                           sliderInput("fractals_left", "Left limit", min = -3, max = 0, value = -1, step = 0.1),
                           sliderInput("fractals_right", "Right limit", min = 0, max = 3, value = 1, step = 0.1),
                           numericInput("fractals_dist", "Maximum distance", value = 4, min = 2, max = 10)
                  ),

                  #bullseye
                  tabPanel("Bullseye", id="bullseye",
                           br(),
                           selectInput("bullseye_main_col", "Main colour",
                                       rev(unique(gsub('[0-9]+', '', colors())))),
                           selectInput("bullseye_bg_col", "Background colour",
                                       unique(gsub('[0-9]+', '', colors())))
                  ),

                  #vortex
                  tabPanel("Vortex", id="vortex",
                           br(),
                           sliderInput("vortex_n", "Number of points", min = 1, max = 100, value = 25),
                           selectInput("vortex_start_val", "Starting value",
                                       c("0" = 0,
                                         "90" = 90)),
                           selectInput("vortex_col_scheme", "Colour scheme",
                                       c("Rainbow" = "rainbow",
                                         "Monochrome" = "mono")),
                           selectInput("vortex_bg_col", "Background colour",
                                       unique(gsub('[0-9]+', '', colors())))
                  ),

                  #waves
                  tabPanel("Waves", id="waves",
                           br(),
                           numericInput("waves_a", "Parameter 1", value = 23, min = 1, max = 25),
                           numericInput("waves_b", "Parameter 2", value = 6, min = 1, max = 25),
                           selectInput("waves_main_col", "Main colour",
                                       c("Prism" = "Prism",
                                         "Bold" = "Bold",
                                         "Antique" = "Antique",
                                         "Vivid" = "Vivid",
                                         "Safe"="Safe",
                                         "Pastel"="Pastel")),
                           selectInput("waves_bg_col", "Background colour",
                                       unique(gsub('[0-9]+', '', colors())))
                  )
            ),
      width = 8
    )
  ),
  fluidRow(column(12, align="center", uiOutput("gh_link"))),
  fluidRow(column(12, align="center", textOutput("footer")))
)
