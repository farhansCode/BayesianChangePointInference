library(rstan)
library(loo)
library(ggplot2)
library(furrr)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Load your dataset
df <- read.csv("dataset generation/datasetStageOne.csv")

# Grid of tau_prior_mean values
tau_grid <- c(60, 80, 100, 120, 140)

# Parallel plan
plan(multisession, workers = parallel::detectCores())

# Model run function
run_model <- function(tau_val) {
  cat("Running model with tau_prior_mean =", tau_val, "\n")
  
  stan_data <- list(
    N = nrow(df),
    y = df$Total_Cases,
    tau_prior_mean = tau_val,
    tau_prior_sd = 5
  )
  
  fit <- stan(
    file = "stage4v3.stan",
    data = stan_data,
    iter = 2000,
    warmup = 1000,
    chains = 4,
    seed = 42,
    refresh = 0,
    control = list(adapt_delta = 0.99, max_treedepth = 15)
  )
  
  log_lik <- extract_log_lik(fit, parameter_name = "log_lik", merge_chains = FALSE)
  loo_result <- loo(log_lik)
  
  data.frame(tau_mean = tau_val, looic = loo_result$estimates["looic", "Estimate"])
}

# Run grid in parallel
Sys.time()
results <- future_map_dfr(tau_grid, run_model)
Sys.time()

# Plot LOOIC vs tau_prior_mean
ggplot(results, aes(x = tau_mean, y = looic)) +
  geom_line(color = "steelblue") +
  geom_point(size = 2) +
  labs(title = "LOOIC vs tau_prior_mean", x = "tau_prior_mean", y = "LOOIC") +
  theme_minimal()

