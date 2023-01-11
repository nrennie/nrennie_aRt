vortexUI <- function(id) {
  ns <- NS(id)
  tabPanel("Vortex", id="vortex",
           fluidRow(
             br(),
             column(4,
                    align="center",
                    plotOutput(ns("vortexPlot"), height = "auto"),
                    br()
             ), # end first column
             column(8,
                    sliderInput(ns("vortex_n"), "Number of points", min = 1, max = 100, value = 25),
                    selectInput(ns("vortex_start_val"), "Starting value",
                                c("0" = 0, "90" = 90)),
                    selectInput(ns("vortex_col_scheme"), "Colour scheme",
                                c("Rainbow" = "rainbow",
                                  "Monochrome" = "mono")),
                    selectInput(ns("vortex_bg_col"), "Background colour",
                                unique(gsub('[0-9]+', '', colors()))),
                    tags$h5("Click below to download a PNG file:"),
                    downloadButton(ns('downloadPlot'), 'Download')
             ) # end second column
           ) # end fluid row
  ) # end tab panel
}

vortexServer <- function(id) {
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
        p1 <- vortex(n=input$vortex_n,
                     start_val=as.numeric(input$vortex_start_val),
                     col_scheme=input$vortex_col_scheme,
                     bg_col=input$vortex_bg_col, s=1234) +
          labs(caption = "N. Rennie") +
          theme(plot.caption = element_text(colour=c("black", "white")[(input$vortex_bg_col == "black") + 1],
                                            size=10, hjust = 0.5, vjust = 4, face="italic"))
        p <- ggdraw() +
          draw_plot(p1) +
          theme(plot.background = element_rect(fill=input$vortex_bg_col, colour=input$vortex_bg_col))
      }) |>
        bindCache(input$vortex_n,
                  input$vortex_start_val,
                  input$vortex_col_scheme,
                  input$vortex_bg_col)

      output$vortexPlot <- renderPlot({
        suppressWarnings(print(plotInput()))
      }, height = function() {
        as.numeric(height_value())
      }
      )

      # Download
      output$downloadPlot <- downloadHandler(
        filename = function() { paste("vortex", '.png', sep='') },
        content = function(file) {
          ggsave(file, plotInput(), height = 800, width = 800, unit = "px")
        }
      )

    }
  )
}
