library(ggplot2)
library(rstan)

# Load dataset
df <- read.csv("dataset generation/stage1version2.csv")

# Plot Total Cases Over Time
ggplot(df, aes(x = Day, y = Total_Cases)) +
  geom_line(color = "blue") +
  geom_vline(xintercept = 100, color = "red", linetype = "dashed") +
  labs(title = "Simulated COVID-19 Time Series with Two Outbreaks",
       x = "Day", y = "Total Cases") +
  theme_minimal()

