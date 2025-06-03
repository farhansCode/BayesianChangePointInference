library(rstan)
library(ggplot2)


rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


df <- read.csv("dataset generation/simulated_stage_two_small_overlap.csv")  # Change if using a different dataset


stan_data <- list(
  N = nrow(df),
  Observed_Cases = df$Observed_Cases
)

# Fit the model
fit <- stan(
  file = "stageTwoSolution.stan",  
  data = stan_data,
  iter = 12000, chains = 4, warmup = 4000,
  control = list(adapt_delta = 0.9999, max_treedepth = 25),
  seed = 42
)


print(fit, pars = c("amp1", "amp2", "mu1", "mu2", "sigma1", "sigma2", "tau", "sigma_obs"))


tau_samples <- extract(fit)$tau


ggplot(data.frame(tau = tau_samples), aes(x = tau)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.6, color = "black") +
  geom_vline(xintercept = median(tau_samples), color = "red", linetype = "dashed") +
  labs(
    title = "Posterior Distribution of Change-Point",
    x = "Estimated Change-Point (τ)", y = "Density"
  ) +
  theme_minimal()


ggsave("change_point_posterior.png", width = 8, height = 6)
