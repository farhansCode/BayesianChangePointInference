data {
  int<lower=1> N;                        // Number of days
  array[N] real Total_Cases;            // Observed total cases
  real<lower=1, upper=N> tau1_prior_mean; // Prior mean for tau1 // Prior mean for tau2
  real<lower=0> tau_prior_sd;           // Shared prior SD
}

parameters {
  real<lower=1, upper=N> tau1;         // First change-point
  real mu1;                            // Mean before tau1
  real mu2;                            // Mean between tau1 and tau2
  real mu3;                            // Mean after tau2
  real<lower=0> sigma_obs;             // Observation noise
}

transformed parameters {
  array[N] real mu_cases;
  for (n in 1:N) {
    real w1 = inv_logit((n - tau1) * 2);  // Smooth transition 1
    real w2 = inv_logit((n - tau2) * 2);  // Smooth transition 2

    mu_cases[n] = (1 - w1) * mu1 + (w1 - w2) * mu2 + w2 * mu3;
  }
}

model {
  // Priors
  tau1 ~ normal(tau1_prior_mean, tau_prior_sd);
  mu1 ~ normal(0, 1000);
  mu2 ~ normal(0, 1000);
  mu3 ~ normal(0, 1000);
  sigma_obs ~ lognormal(0, 0.5);

  // Likelihood
  Total_Cases ~ normal(mu_cases, sigma_obs);
}
