# Step 1: Load the rstan package and set Stan options
library(rstan)

# Set options for Stan
options(mc.cores = parallel::detectCores())  # Use all available CPU cores
rstan_options(auto_write = TRUE)             # Avoid recompiling unchanged models

# Step 2: Define your Stan model as a string
stan_code <- "
data {
  int<lower=0> N; // number of data points
  vector[N] x;    // predictor
  vector[N] y;    // outcome
}
parameters {
  real alpha;     // intercept
  real beta;      // slope
  real<lower=0> sigma; // standard deviation
}
model {
  y ~ normal(alpha + beta * x, sigma); // likelihood
}
"

# Step 3: Compile the Stan model
stan_model <- stan_model(model_code = stan_code)

# Step 4: Prepare data
N <- 100  # number of data points
x <- seq(0, 10, length.out = N)  # predictor
y <- 3 + 2 * x + rnorm(N, 0, 1)  # outcome with some noise

# Data list to pass to Stan
data <- list(
  N = N,
  x = x,
  y = y
)

# Step 5: Fit the model using Stan
fit <- sampling(stan_model, data = data, chains = 4, iter = 2000, warmup = 500)

# Step 6: Print the summary of the results
print(fit)

# Step 7: Extract specific parameter estimates (optional)
samples <- extract(fit)
alpha_samples <- samples$alpha
beta_samples <- samples$beta
sigma_samples <- samples$sigma

cat("Estimated alpha (intercept):", mean(alpha_samples), "\n")
cat("Estimated beta (slope):", mean(beta_samples), "\n")
cat("Estimated sigma:", mean(sigma_samples), "\n")
