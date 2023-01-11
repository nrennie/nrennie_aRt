fractalsUI <- function(id) {
  ns <- NS(id)
  tabPanel("Fractals", id="fractals",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    wellPanel(
                      plotOutput(ns("fractalsPlot"), height = "auto"),
                      br(),
                      downloadButton(ns('downloadPlot'), 'Download')
                    )
             ), # end first column
             column(8,
                    numericInput(ns("fractals_n"), "Number of iterations", value = 25, min = 5, max = 30),
                    selectInput(ns("fractals_palette"), "Colour palette", names(MetBrewer::MetPalettes)),
                    numericInput(ns("fractals_y"), "Growth rate", value = 3, min = 1, max = 5),
                    sliderInput(ns("fractals_left"), "Left limit", min = -3, max = 0, value = -1, step = 0.1),
                    sliderInput(ns("fractals_right"), "Right limit", min = 0, max = 3, value = 1, step = 0.1),
                    numericInput(ns("fractals_dist"), "Maximum distance", value = 4, min = 2, max = 10)
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

fractalsServer <- function(id) {
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
        suppressWarnings(fractals(N = input$fractals_n,
                                  col_palette = MetBrewer::met.brewer(input$fractals_palette, n = 30),
                                  shift = 0,
                                  left = input$fractals_left,
                                  right = input$fractals_right,
                                  y_param = input$fractals_y,
                                  resolution = 0.005,
                                  dist_max = input$fractals_dist) +
                           labs(caption = "N. Rennie") +
                           theme(plot.caption = element_text(colour = "black",
                                                             size=10, hjust = 0.5, vjust = 14, face="italic"),
                                 plot.margin = unit(c(0, -0.1, -0.7, -0.1), unit = "cm")))
      }) |>
        bindCache(input$fractals_n,
                  input$fractals_palette,
                  input$fractals_left,
                  input$fractals_right,
                  input$fractals_y,
                  input$fractals_dist)

      output$fractalsPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("fractals", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
