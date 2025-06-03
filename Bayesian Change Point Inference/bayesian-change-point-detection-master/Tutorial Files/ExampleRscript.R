

# Load RStan library
library(rstan)

data {
  int<lower=0> N;           # number of data points
  vector[N] x;              # predictor
  vector[N] y;              #response
}

parameters {
  real alpha;               # intercept
  real beta;                # slope
  real<lower=0> sigma;      # noise
}

model {
  y ~ normal(alpha + beta * x, sigma);  #likelihood
}

N <- 100
x <- rnorm(N)
y <- 2.0 + 3.0 * x + rnorm(N)
data_list <- list(N = N, x = x, y = y)

stan_model_code <- '
// Your Stan model code here
'

fit <- stan(model_code = stan_model_code, data = data_list)

print(fit)
plot(fit)

