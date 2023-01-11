circlesUI <- function(id) {
  ns <- NS(id)
    tabPanel("Circles", id="circles",
             fluidRow(
             br(),
             column(4,
                    align="center",
                    plotOutput(ns("circlesPlot"), height = "auto"),
                    br()
             ), # end first column
             column(8,
                    numericInput(ns("circles_n"), "Number of circles", value = 10, min = 1, max = 100),
                    sliderInput(ns("circles_smoothness"), "Smoothness", min = 3, max = 100, value = 50),
                    selectInput(ns("circles_col_palette"), "Colour palette",
                               c("Bold" = "Bold",
                                 "Antique" = "Antique",
                                 "Vivid" = "Vivid",
                                 "Safe" = "Safe",
                                 "Prism"="Prism",
                                 "Pastel"="Pastel")),
                    selectInput(ns("circles_bg_col"), "Background colour",
                               c("Pink" = "#e73f74",
                                 "White" = "white",
                                 "Black" = "black")),
                    tags$h5("Click below to download a PNG file:"),
                    downloadButton(ns('downloadPlot'), 'Download')
                    ) # end second column
    ) # end fluid row
  ) # end tab panel
}

circlesServer <- function(id) {
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
          circles(n=input$circles_n,
                  smoothness=input$circles_smoothness,
                  col_palette=rcartocolor::carto_pal(n = 12, input$circles_col_palette),
                  line_col=NA,
                  bg_col=input$circles_bg_col,
                  s=1234) +
            labs(caption = "N. Rennie") +
            theme(plot.caption = element_text(colour= c("black", "white")[(input$circles_bg_col == "black") + 1],
                                              size=10, hjust = 0.5, vjust = 2, face="italic"))
      }) |>
        bindCache(input$circles_n,
                  input$circles_smoothness,
                  input$circles_col_palette,
                  input$circles_bg_col)

      output$circlesPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
          as.numeric(height_value())
        }
       )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("circles", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
