library(shiny)
library(ggplot2)
library(dplyr)

# Use the dataset from your package
data("covid19")  # assuming you have a dataset covid19 in your package


ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body { background-color: #e6f2ff; }
      .well { background-color: #ffffff; border-radius: 10px; box-shadow: 2px 2px 5px #aaaaaa; padding: 20px; }
      h4 { color: #333333; font-weight: bold; }
    "))
  ),

  titlePanel("COVID-19 Quarantine Breach Heatmap"),

  sidebarLayout(
    sidebarPanel(
      h4("Filter Scenarios"),
      selectInput(
        inputId = "R0_select",
        label = "Select Basic Reproductive Ratio (R0):",
        choices = c("All", unique(covid19$R0)),
        selected = "All"
      ),
      helpText("R0 = basic reproductive ratio. VE = reduction in susceptibility due to vaccination."),
      helpText("Selecting a range of R0 allows exploration of how breach events scale with transmissibility.")
    ),


    mainPanel(
      h4("Heatmap of Relative Force of Infection"),
      plotOutput("heatmapPlot", height = "600px"),
      br(),
      h4("Interpretation"),
      tags$p("This heatmap shows the relative force of infection from quarantine breaches for different combinations of R0 and VE."),
      tags$p("Higher values (yellow/white) indicate higher risk higher risk of quarantine breaches leading to transmission. The contour lines help identify regions of similar risk."),
      tags$p("Blue dotted box indicates baseline scenario (R0=3, VE=0) consistent with pre-Delta outbreak data in Australia & NZ."),
      tags$p("Green dotted box represents vaccinated pathways before Delta, yellow dashed box corresponds to Delta plausible scenarios.")
    )
  )
)


# --- SERVER ---
server <- function(input, output, session) {
  output$heatmapPlot <- renderPlot({
    if (input$R0_select == "All") {
      # --- Show HEATMAP ---
      p <- ggplot(covid19, aes(x = R0, y = VE, fill = Value)) +
        geom_tile(color = "black", width = 1, height = 0.1) +
        geom_text(aes(label = sprintf("%.3g", Value)), color = "white", size = 3) +
        scale_fill_gradientn(
          colours = c("black", "darkred", "red", "orange", "yellow", "white"),
          name = "Relative\nForce of Infection"
        ) +
        geom_contour(aes(z = Value), color = "cyan", linewidth = 0.7) +
        theme_minimal(base_size = 14) +
        theme(
          panel.grid = element_blank(),
          axis.title = element_text(face = "bold"),
          legend.title = element_text(face = "bold")
        ) +
        labs(
          x = "R0 (Basic Reproductive Ratio)",
          y = "VE (Vaccine Efficacy)",
          subtitle = "Heatmap shows relative force of infection for all R0 values"
        ) +
        scale_y_continuous(breaks = seq(0, 0.9, 0.1), labels = sprintf("%.1f", seq(0, 0.9, 0.1))) +
        scale_x_continuous(breaks = 1:10)

      # Add rectangles
      p +
        annotate("rect",
                 xmin = 2 - 0.5, xmax = 4 + 0.5,
                 ymin = 0.9 - 0.05, ymax = 0.9 + 0.05,  # Row 2 in 0.0-0.9 scale = 0.8
                 color = "limegreen", fill = NA, linetype = "dotted", size = 1.2) +
        annotate("rect",
                 xmin = 5 - 0.5, xmax = 8 + 0.5,
                 ymin = 0.6 - 0.15, ymax = 0.8 + 0.05,  # Rows 4-7 in 0.0-0.9 scale = 0.5-0.2
                 color = "yellow", fill = NA, linetype = "dashed", size = 1.2) +
        annotate("rect",
                 xmin = 2 - 0.5, xmax = 4 + 0.5,
                 ymin = 0.0 - 0.05, ymax = 0.0 + 0.05,  # Row 10 in 0.0-0.9 scale = 0.0
                 color = "cyan", fill = NA, linetype = "dashed", size = 1.2)


    } else {
      # --- Show LINE PLOT for selected R0 ---
      filtered <- covid19 %>% filter(R0 == as.numeric(input$R0_select))

      ggplot(filtered, aes(x = VE, y = Value)) +
        geom_line(color = "blue", size = 1.2) +
        geom_point(color = "darkblue", size = 3) +
        theme_minimal(base_size = 14) +
        labs(
          title = paste("VE vs Relative Force of Infection for R0 =", input$R0_select),
          x = "VE (Vaccine Efficacy)",
          y = "Relative Force of Infection",
          subtitle = "Line plot shows how force of infection changes with VE for selected R0"
        ) +
        theme(
          plot.title = element_text(face = "bold", hjust = 0.5),
          axis.title = element_text(face = "bold")
        )
    }
  })
}


# --- Run App ---
shinyApp(ui, server)
