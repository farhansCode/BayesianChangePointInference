data {
  int<lower=1> N;                        // Number of days
  array[N] real Total_Cases;            // Observed total cases
  real<lower=1, upper=N> tau_prior_mean; // Passed from R
  real<lower=0> tau_prior_sd;            // Passed from R
}

parameters {
  real<lower=0> amp1;
  real<lower=0> amp2;
  real<lower=1, upper=N> mu1;
  real<lower=1, upper=N> mu2;
  real<lower=0> sigma1;
  real<lower=0> sigma2;
  real<lower=1, upper=N> tau;           // Still a parameter
  real<lower=0> sigma_obs;
}

transformed parameters {
  array[N] real mu_cases;
  for (n in 1:N) {
    real w = inv_logit(5 * (n - tau));
    real variant1 = amp1 * exp(-((n - mu1)^2) / (2 * sigma1^2));
    real variant2 = amp2 * exp(-((n - mu2)^2) / (2 * sigma2^2)) * w;
    mu_cases[n] = variant1 + variant2;
  }
}

model {
  // Priors
  amp1 ~ normal(1000, 10);
  amp2 ~ normal(800, 10);
  mu1 ~ normal(50, 5);
  mu2 ~ normal(150, 5);
  sigma1 ~ lognormal(log(10), 0.5);
  sigma2 ~ lognormal(log(10), 0.5);
  tau ~ normal(tau_prior_mean, tau_prior_sd); // Prior now controlled from R
  sigma_obs ~ lognormal(0, 0.5);

  // Likelihood
  Total_Cases ~ normal(mu_cases, sigma_obs);
}
