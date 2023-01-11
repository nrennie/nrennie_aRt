bubblesUI <- function(id) {
  ns <- NS(id)
  tabPanel("Bubbles", id="bubbles",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    wellPanel(
                      plotOutput(ns("bubblesPlot"), height = "auto"),
                      br(),
                      downloadButton(ns('downloadPlot'), 'Download')
                    )
             ), # end first column
             column(8,
                   numericInput(ns("bubbles_n"), "Number of circles", value = 7, min = 1, max = 30),
                   selectInput(ns("bubbles_palette"), "Colour palette",
                               c("Bold" = "Bold",
                                 "Antique" = "Antique",
                                 "Vivid" = "Vivid",
                                 "Safe"="Safe",
                                 "Prism"="Prism",
                                 "Pastel"="Pastel")),
                   selectInput(ns("bubbles_main_col"), "Line colour",
                               unique(gsub('[0-9]+', '', colors()))),
                   selectInput(ns("bubbles_bg_col"), "Background colour",
                               rev(unique(gsub('[0-9]+', '', colors()))))
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

bubblesServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      cdata <- session$clientData

      height_value <- reactive({
        cnames <- names(cdata)
        pos <- grep("Plot_width$", cnames)[1]
        paste(cdata[[cnames[pos]]])
      })

      output$clientdataText <- renderText({
        cnames <- names(cdata)
        pos <- grep("Plot_width$", cnames)[1]
        paste(cdata[[cnames[pos]]])
      })

      plotInput <- reactive({
        suppressWarnings(bubbles(num_circles = input$bubbles_n,
                                 main_col = input$bubbles_main_col,
                                 col_palette = rcartocolor::carto_pal(n = 12, input$bubbles_palette),
                                 bg_col = input$bubbles_bg_col,
                                 s = 1234) +
                           labs(caption = "N. Rennie") +
                           theme(plot.caption = element_text(colour = c("black", "white")[(input$bubbles_bg_col == "black") + 1],
                                                             size=10, hjust = 0.5, vjust = 14, face="italic"),
                                 plot.margin = unit(c(0, -0.1, -0.7, -0.1), unit = "cm")))
      }) |>
        bindCache(input$bubbles_n,
                  input$bubbles_main_col,
                  input$bubbles_palette,
                  input$bubbles_bg_col)

      output$bubblesPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("bubbles", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
