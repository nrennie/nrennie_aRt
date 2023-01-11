fadingUI <- function(id) {
  ns <- NS(id)
  tabPanel("Fading", id="fading",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    plotOutput(ns("fadingPlot"), height = "auto"),
                    br()
             ), # end first column
             column(8,
                    sliderInput(ns("fading_n_layers"), "Number of layers", min = 2, max = 10, value = 6),
                    sliderInput(ns("fading_n_points"), "Number of points", min = 1, max = 10, value = 1),
                    selectInput(ns("fading_col_palette"), "Colour palette",
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
                                  "Burgundy" = "Burg")),
                    tags$h5("Click below to download a PNG file:"),
                    downloadButton(ns('downloadPlot'), 'Download')
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

fadingServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      cdata <- session$clientData

      height_value <- reactive({
        cnames <- names(cdata)
        pos <- grep("Plot_width$", cnames)[1]
        paste(cdata[[cnames[pos]]])
      })

      plotInput <- reactive({
        suppressWarnings(fading(n_layers=input$fading_n_layers,
                                n_points=input$fading_n_points,
                                col_palette=rcartocolor::carto_pal(n = 12, input$fading_col_palette),
                                s=1234) +
                           labs(caption = "N. Rennie") +
                           theme(plot.caption = element_text(colour = "black",
                                                             size=10, hjust = 0.5, vjust = 14, face="italic"),
                                 plot.margin = unit(c(0,-0.1,-0.7,-0.1), unit="cm")))
      }) |>
        bindCache(input$fading_n_layers,
                  input$fading_n_points,
                  input$fading_col_palette)

      output$fadingPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("fading", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
