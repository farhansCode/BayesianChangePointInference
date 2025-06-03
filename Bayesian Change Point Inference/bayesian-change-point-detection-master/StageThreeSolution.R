library(rstan)
library(ggplot2)


rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Load dataset
df <- read.csv("dataset generation/datasetStageThree_50days_Adjusted.csv")  

# Prepare data for Stan
stan_data <- list(
  N = nrow(df),
  Total_Cases = df$Total_Cases  # Match the variable name in the Stan file
)

Sys.time()

# Fit the model
fit <- stan(
  file = "stageThreeSolution.stan",  
  data = stan_data,
  iter = 12000, chains = 4, warmup = 4000,
  control = list(adapt_delta = 0.9995, max_treedepth = 12),
  seed = 42
)
Sys.time()

# Print parameter estimates
print(fit, pars = c("mu1", "sigma1", "alpha", "beta", "tau"))

# Extract posterior samples for change point
tau_samples <- extract(fit)$tau

# Plot posterior distribution of tau
ggplot(data.frame(tau = tau_samples), aes(x = tau)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.6, color = "black") +
  geom_vline(xintercept = median(tau_samples), color = "red", linetype = "dashed") +
  labs(
    title = "Posterior Distribution of Change-Point",
    x = "Estimated Change-Point (τ)", y = "Density"
  ) +
  theme_minimal()

# Save plot
ggsave("change_point_posterior.png", width = 8, height = 6)
