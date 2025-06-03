data {
  int<lower=1> N;                        // Number of data points
  array[N] real y;                      // Observed data (Total_Cases)
  real<lower=1, upper=N> tau_prior_mean;
  real<lower=0> tau_prior_sd;
}

parameters {
  real<lower=1, upper=N> tau;           // Change-point
  real mu1;                             // Mean before tau
  real mu2;                             // Mean after tau
  real<lower=0> sigma;                  // Common standard deviation
}

model {
  // Priors
  tau ~ normal(tau_prior_mean, tau_prior_sd);
  mu1 ~ normal(0, 2000);
  mu2 ~ normal(0, 2000);
  sigma ~ lognormal(0, 1);

  // Likelihood
  for (n in 1:N) {
    real w = inv_logit(10 * (n - tau));  // Sharp change-point
    real mu = (1 - w) * mu1 + w * mu2;
    y[n] ~ normal(mu, sigma);
  }
}

generated quantities {
  array[N] real log_lik;
  for (n in 1:N) {
    real w = inv_logit(10 * (n - tau));
    real mu = (1 - w) * mu1 + w * mu2;
    log_lik[n] = normal_lpdf(y[n] | mu, sigma);
  }
}
