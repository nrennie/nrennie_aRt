linesUI <- function(id) {
  ns <- NS(id)
  tabPanel("Lines", id="lines",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    plotOutput(ns("linesPlot"), height = "auto"),
                    br()
             ), # end first column
             column(8,
                    sliderInput(ns("lines_n"), "Number of lines",
                                min = 0, max = 500, value = 100,
                                step = 25),
                    sliderInput(ns("lines_linewidth"), "Line width",
                                min = 0, max = 1, value = 0.1),
                    sliderInput(ns("lines_max_length"), "Maximum line length",
                                min = 2, max = 15, value = 7),
                    selectInput(ns("lines_main_col"), "Line colour",
                                unique(gsub('[0-9]+', '', colors())),
                                selected = "lightseagreen"),
                    selectInput(ns("lines_bg_col"), "Background colour",
                                rev(unique(gsub('[0-9]+', '', colors()))),
                                selected = "ghostwhite"),
                    tags$h5("Click below to download a PNG file:"),
                    downloadButton(ns('downloadPlot'), 'Download')
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

linesServer <- function(id) {
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
        suppressWarnings(lines(n = input$lines_n,
                               max_length = input$lines_max_length,
                               linewidth = input$lines_linewidth,
                               main_col = input$lines_main_col,
                               bg_col = input$lines_bg_col,
                               s = 1234) +
                           labs(caption = "N. Rennie") +
                           theme(plot.caption = element_text(colour = c("black", "white")[(input$lines_bg_col == "black") + 1],
                                                             size=10, hjust = 0.5, vjust = 14, face="italic"),
                                 plot.margin = unit(c(0, -0.1, -0.7, -0.1), unit = "cm")))
      }) |>
        bindCache(input$lines_n,
                  input$lines_max_length,
                  input$lines_linewidth,
                  input$lines_main_col,
                  input$lines_bg_col)

      output$linesPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("lines", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
