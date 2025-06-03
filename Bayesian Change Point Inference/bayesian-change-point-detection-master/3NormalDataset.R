library(rstan)
library(ggplot2)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Load dataset (change the number if needed)
df <- read.csv("dataset generation/3NormalDataset.csv")

# Stan input
stan_data <- list(
  N = nrow(df),
  y = df$Total_Cases
)
Sys.time()
# Run Stan model
fit <- stan(
  file = "3NormalDataset.stan",  # <- Make sure this is the 1-change-point model
  data = stan_data,
  iter = 12000, chains = 4, warmup = 4000,
  control = list(adapt_delta = 0.99, max_treedepth = 15),
  seed = 42
)
Sys.time()
# Print main parameters
print(fit, pars = c("mu1", "mu2", "mu3", "sigma", "tau1", "tau2"))


# Extract samples
tau_samples <- extract(fit)$tau

# Plot posterior
ggplot(data.frame(tau = tau_samples), aes(x = tau)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.6, color = "black") +
  geom_vline(xintercept = median(tau_samples), color = "red", linetype = "dashed") +
  labs(
    title = "Posterior Distribution of Change-Point (τ)",
    x = "Estimated Change-Point (τ)", y = "Density"
  ) +
  theme_minimal()

