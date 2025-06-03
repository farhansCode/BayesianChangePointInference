library(rstan)
library(ggplot2)


rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

df <- read.csv("dataset generation/datasetStageOne.csv")

stan_data <- list(
  N = nrow(df),
  Total_Cases = df$Total_Cases,
  tau_prior_mean = 100,  # YOU SET THIS
  tau_prior_sd = 5     # AND THIS TOO
)

Sys.time()
fit <- stan(
  file = "stage4.stan",
  data = stan_data,
  iter = 12000, chains = 4, warmup = 4000,
  control = list(adapt_delta = 0.9999, max_treedepth = 15),
  seed = 42
)
Sys.time()
cat("\a")  # Terminal bell (depends on system settings)


print(fit, pars = c("tau", "amp1", "amp2", "mu1", "mu2", "sigma1", "sigma2", "sigma_obs"))

