## code to prepare `covid19.R` dataset goes here

# Load packages
library(ggplot2)
library(reshape2)

# Data as a matrix (10 rows, 10 columns)
data_matrix <- matrix(c(
  0.017, 0.025, 0.0357, 0.0361, 0.0757, 0.0816, 0.107, 0.134, 0.138, 0.216,
  0.0167, 0.0547, 0.106, 0.175, 0.214, 0.25, 0.22, 0.38, 0.432, 0.528,
  0.037, 0.0487, 0.122, 0.233, 0.345, 0.298, 0.546, 0.635, 1.07, 1.17,
  0.0402, 0.104, 0.224, 0.308, 0.454, 0.74, 1.02, 1.2, 1.49, 1.5,
  0.0607, 0.188, 0.292, 0.469, 0.602, 1.01, 1.02, 1.9, 2.22, 2.4,
  0.0972, 0.21, 0.388, 0.639, 1.06, 1.38, 1.64, 2.04, 2.65, 4.01,
  0.127, 0.286, 0.518, 0.918, 1.26, 1.82, 2.78, 2.83, 3.56, 4.02,
  0.132, 0.341, 0.564, 0.96, 1.65, 2.25, 2.91, 3.58, 4.23, 4.88,
  0.143, 0.366, 0.93, 1.42, 1.9, 2.56, 3.4, 4.38, 5.15, 6.81,
  0.163, 0.539, 1, 1.57, 2.16, 2.98, 4.3, 5.97, 7.34, 7.38
), nrow = 10, ncol = 10, byrow = TRUE)

# Convert to data frame for ggplot
melted_data <- melt(data_matrix)
colnames(melted_data) <- c("Row", "R0", "Value")

# Transform Row to 0.0-0.9 scale (reversed so 0.9 at top)
melted_data$VE <- 0.9 - (melted_data$Row - 1) * 0.1


covid19 <- melted_data
covid19 <- covid19 |> select(-Row)

# Plot with 0.0-0.9 y-axis - USE Row_transformed for y aesthetic!
p <- ggplot(covid19, aes(x = R0, y = VE, fill = Value)) +
  geom_tile(color = "black", width = 1, height = 0.1) +  # Height = 0.1 for 0.0-0.9 scale
  geom_text(aes(label = sprintf("%.3g", Value)), color = "white", size = 3) +
  scale_fill_gradientn(
    colours = c("black", "darkred", "red", "orange", "yellow", "white"),
    name = "Value"
  ) +
  geom_contour(aes(z = Value), color = "cyan", linewidth = 0.7) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold")
  ) +
  labs(x = "R0", y = "VE") +
  scale_y_continuous(breaks = seq(0, 0.9, 0.1), labels = sprintf("%.1f", seq(0, 0.9, 0.1))) +
  scale_x_continuous(breaks = 1:10)

# Add colored boxes - UPDATE coordinates for 0.0-0.9 scale!
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




usethis::use_data(covid19, overwrite = TRUE)

