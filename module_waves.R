wavesUI <- function(id) {
  ns <- NS(id)
  tabPanel("Waves", id="waves",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    plotOutput(ns("wavesPlot"), height = "auto"),
                    br()
             ), # end first column
             column(8,
                    numericInput(ns("waves_a"), "Parameter 1", value = 23, min = 1, max = 25),
                    numericInput(ns("waves_b"), "Parameter 2", value = 6, min = 1, max = 25),
                    selectInput(ns("waves_main_col"), "Main colour",
                                c("Prism" = "Prism",
                                  "Bold" = "Bold",
                                  "Antique" = "Antique",
                                  "Vivid" = "Vivid",
                                  "Safe"="Safe",
                                  "Pastel"="Pastel")),
                    selectInput(ns("waves_bg_col"), "Background colour", unique(gsub('[0-9]+', '', colors()))),
                    tags$h5("Click below to download a PNG file:"),
                    downloadButton(ns('downloadPlot'), 'Download')
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

wavesServer <- function(id) {
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
        p1 <- waves(a = input$waves_a,
                    b = input$waves_b,
                    main_col = rcartocolor::carto_pal(n = 12, input$waves_main_col),
                    bg_col = input$waves_bg_col,
                    s = 1234) +
          labs(caption = "N. Rennie") +
          theme(plot.caption = element_text(colour= c("black", "white")[(input$waves_bg_col == "black") + 1],
                                            size=10, hjust = 0.5, vjust = 2, face="italic"))
        p <- ggdraw() +
          draw_plot(p1) +
          theme(plot.background = element_rect(fill=input$waves_bg_col, colour=input$waves_bg_coll))
      }) |>
        bindCache(input$waves_a,
                  input$waves_b,
                  input$waves_main_col,
                  input$waves_bg_col)

      output$wavesPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("waves", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
