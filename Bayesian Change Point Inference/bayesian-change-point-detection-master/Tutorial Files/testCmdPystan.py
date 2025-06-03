import cmdstanpy
cmdstanpy.install_cmdstan()
cmdstanpy.install_cmdstan(compiler=True)  # only valid on Windows

from cmdstanpy import CmdStanModel
import numpy as np
import os

# Step 1: Define your Stan model as a string
stan_code = """
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
"""

# Step 2: Write the Stan model to a file
stan_file = 'linear_regression.stan'
with open(stan_file, 'w') as f:
    f.write(stan_code)

# Step 3: Compile the Stan model
model = CmdStanModel(stan_file=stan_file)

# Step 4: Prepare data
N = 100  # number of data points
x = np.linspace(0, 10, N)  # predictor
y = 3 + 2 * x + np.random.normal(0, 1, N)  # outcome with some noise

# Data dictionary to pass to Stan
data = {
    'N': N,
    'x': x,
    'y': y
}

# Step 5: Sample from the posterior distribution
fit = model.sample(data=data, chains=4, iter_warmup=500, iter_sampling=1000)

# Step 6: Print the summary of results
print(fit.summary())

# Optionally, access specific parameter estimates
alpha_samples = fit.stan_variable('alpha')  # Extract samples for alpha
beta_samples = fit.stan_variable('beta')    # Extract samples for beta
sigma_samples = fit.stan_variable('sigma')  # Extract samples for sigma

print(f"Estimated alpha (intercept): {np.mean(alpha_samples)}")
print(f"Estimated beta (slope): {np.mean(beta_samples)}")
print(f"Estimated sigma: {np.mean(sigma_samples)}")

# Step 7: Clean up (remove the Stan model file)
os.remove(stan_file)
