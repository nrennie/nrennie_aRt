bullseyeUI <- function(id) {
  ns <- NS(id)
  tabPanel("Bullseye", id="bullseye",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    wellPanel(
                      plotOutput(ns("bullseyePlot"), height = "auto"),
                      br(),
                      downloadButton(ns('downloadPlot'), 'Download')
                    )
             ), # end first column
             column(8,
                    tabPanel("Bullseye", id="bullseye",
                             br(),
                             selectInput(ns("bullseye_main_col"), "Main colour",
                                         rev(unique(gsub('[0-9]+', '', colors())))),
                             selectInput(ns("bullseye_bg_col"), "Background colour",
                                         unique(gsub('[0-9]+', '', colors())))
                    ),
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

bullseyeServer <- function(id) {
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
        suppressWarnings(bullseye(main_col = input$bullseye_main_col,
                                  bg_col = input$bullseye_bg_col,
                                  s = 1234) +
                            labs(caption = "N. Rennie") +
                            theme(plot.caption = element_text(colour=c("black", "white")[(input$bullseye_bg_col == "black") + 1],
                                                              size=10, hjust = 0.5, vjust = 15, face="italic")))
      }) |>
        bindCache(input$bullseye_main_col,
                  input$bullseye_bg_col)

      output$bullseyePlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("bullseye", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
