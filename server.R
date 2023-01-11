# Define server logic for random distribution app ----
server <- function(input, output, session) {

  #   else if (input$tabs == "Fading"){
  #     p <- suppressWarnings(fading(n_layers=input$fading_n_layers,
  #                                  n_points=input$fading_n_points,
  #                                  col_palette=rcartocolor::carto_pal(n = 12, input$fading_col_palette),
  #                                  s=1234) +
  #       labs(caption = "N. Rennie") +
  #       theme(plot.caption = element_text(colour = "black",
  #                                                  size=10, hjust = 0.5, vjust = 14, face="italic"),
  #                      plot.margin = unit(c(0,-0.1,-0.7,-0.1), unit="cm")))
  #   }
  #
  #   else if (input$tabs == "Fractals"){
  #     p <- suppressWarnings(fractals(N = input$fractals_n,
  #                                    col_palette = MetBrewer::met.brewer(input$fractals_palette, n = 30),
  #                                    shift = 0,
  #                                    left = input$fractals_left,
  #                                    right = input$fractals_right,
  #                                    y_param = input$fractals_y,
  #                                    resolution = 0.005,
  #                                    dist_max = input$fractals_dist) +
  #                             labs(caption = "N. Rennie") +
  #                             theme(plot.caption = element_text(colour = "black",
  #                                                               size=10, hjust = 0.5, vjust = 14, face="italic"),
  #                                   plot.margin = unit(c(0, -0.1, -0.7, -0.1), unit = "cm")))
  #   }
  #
  #   else if (input$tabs == "Vortex"){
  #     p1 <- vortex(n=input$vortex_n, start_val=as.numeric(input$vortex_start_val),
  #                 col_scheme=input$vortex_col_scheme, bg_col=input$vortex_bg_col, s=1234) +
  #       labs(caption = "N. Rennie") +
  #       theme(plot.caption = element_text(colour=c("black", "white")[(input$vortex_bg_col == "black") + 1],
  #                                         size=10, hjust = 0.5, vjust = 4, face="italic"))
  #     p <- ggdraw() +
  #       draw_plot(p1) +
  #       theme(plot.background = element_rect(fill=input$vortex_bg_col, colour=input$vortex_bg_col))
  #   }
  #
  #   else if (input$tabs == "Waves"){
  #     p1 <- waves(a = input$waves_a,
  #                 b = input$waves_b,
  #                 main_col = rcartocolor::carto_pal(n = 12, input$waves_main_col),
  #                 bg_col = input$waves_bg_col,
  #                 s = 1234) +
  #       labs(caption = "N. Rennie") +
  #       theme(plot.caption = element_text(colour= c("black", "white")[(input$waves_bg_col == "black") + 1],
  #                                                  size=10, hjust = 0.5, vjust = 2, face="italic"))
  #     p <- ggdraw() +
  #       draw_plot(p1) +
  #       theme(plot.background = element_rect(fill=input$waves_bg_col, colour=input$waves_bg_coll))
  #   }
  # })
  #

  # Call modules
  circlesServer("circles")
  bubblesServer("bubbles")
  bullseyeServer("bullseye")

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
