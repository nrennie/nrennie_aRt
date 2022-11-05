# Define server logic for random distribution app ----
server <- function(input, output, session) {

  # Generate plots
  plotInput <- reactive({
    if (input$tabs == "Circles"){
      p <- circles(n=input$circles_n,
                   smoothness=input$circles_smoothness,
                   col_palette=rcartocolor::carto_pal(n = 12, input$circles_col_palette),
                   line_col=NA,
                   bg_col=input$circles_bg_col,
                   s=1234) +
        labs(caption = "N. Rennie") +
        theme(plot.caption = element_text(colour= c("black", "white")[(input$circles_bg_col == "black") + 1],
                                                   size=10, hjust = 0.5, vjust = 2, face="italic"))
    }

    else if (input$tabs == "Bubbles"){
      p <- suppressWarnings(bubbles(num_circles = input$bubbles_n,
                                    main_col = input$bubbles_main_col,
                                    col_palette = rcartocolor::carto_pal(n = 12, input$bubbles_palette),
                                    bg_col = input$bubbles_bg_col,
                                    s = 1234) +
                              labs(caption = "N. Rennie") +
                              theme(plot.caption = element_text(colour = c("black", "white")[(input$bubbles_bg_col == "black") + 1],
                                                                size=10, hjust = 0.5, vjust = 14, face="italic"),
                                    plot.margin = unit(c(0, -0.1, -0.7, -0.1), unit = "cm")))
    }

    else if (input$tabs == "Fading"){
      p <- suppressWarnings(fading(n_layers=input$fading_n_layers,
                                   n_points=input$fading_n_points,
                                   col_palette=rcartocolor::carto_pal(n = 12, input$fading_col_palette),
                                   s=1234) +
        labs(caption = "N. Rennie") +
        theme(plot.caption = element_text(colour = "black",
                                                   size=10, hjust = 0.5, vjust = 14, face="italic"),
                       plot.margin = unit(c(0,-0.1,-0.7,-0.1), unit="cm")))
    }

    else if (input$tabs == "Fractals"){
      p <- suppressWarnings(fractals(N = input$fractals_n,
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
    }

    else if (input$tabs == "Bullseye"){
      p <- suppressWarnings(bullseye(main_col = input$bullseye_main_col,
                                     bg_col = input$bullseye_bg_col,
                                     s = 1234) +
                              labs(caption = "N. Rennie") +
                              theme(plot.caption = element_text(colour=c("black", "white")[(input$bullseye_bg_col == "black") + 1],
                                                                size=10, hjust = 0.5, vjust = 15, face="italic")))
    }

    else if (input$tabs == "Vortex"){
      p1 <- vortex(n=input$vortex_n, start_val=as.numeric(input$vortex_start_val),
                  col_scheme=input$vortex_col_scheme, bg_col=input$vortex_bg_col, s=1234) +
        labs(caption = "N. Rennie") +
        theme(plot.caption = element_text(colour=c("black", "white")[(input$vortex_bg_col == "black") + 1],
                                          size=10, hjust = 0.5, vjust = 4, face="italic"))
      p <- ggdraw() +
        draw_plot(p1) +
        theme(plot.background = element_rect(fill=input$vortex_bg_col, colour=input$vortex_bg_col))
    }

    else if (input$tabs == "Waves"){
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
    }
  })

  # Render plots
  output$plot <- renderPlot({
    suppressWarnings(print(plotInput()))
  }, height = function() {
    session$clientData$output_plot_width
  }
  )

  # Download
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$tabs, '.png', sep='') },
    content = function(file) {
      ggsave(file,plotInput())
    }
  )

  # Source code link
  url <- a("GitHub", href="https://github.com/nrennie/aRt")
  output$gh_link <- renderUI({
    tagList("The source code for this aRt can be found on ", url)
  })

  # Footer
  output$footer <- renderText({
    "© Nicola Rennie. 2022."
  })


  }
