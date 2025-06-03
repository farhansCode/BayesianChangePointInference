data {
  int<lower=1> N;          // Number of data points
  vector[N] y;            // Observed data
}

parameters {
  real<lower=0, upper=200> tau1;   // First change-point
  real<lower=0, upper=200> tau2;   // Second change-point
  real mu1;                        // Mean before tau1
  real mu2;                        // Mean between tau1 and tau2
  real mu3;                        // Mean after tau2
  real<lower=0> sigma;             // Common standard deviation
}

model {
  // Priors 
  tau1 ~ normal(60, 20);           // First change-point prior
  tau2 ~ normal(140, 20);          // Second change-point prior
  mu1 ~ normal(0, 1000);
  mu2 ~ normal(0, 1000);
  mu3 ~ normal(0, 1000);
  sigma ~ normal(0, 100);

  // Likelihood with soft transitions
  for (n in 1:N) {
    real w1 = inv_logit((n - tau1) * 2);   // Transition from mu1 to mu2
    real w2 = inv_logit((n - tau2) * 2);   // Transition from mu2 to mu3

    // Soft combination of three segments
    real mu = (1 - w1) * mu1 + (w1 - w2) * mu2 + w2 * mu3;

    y[n] ~ normal(mu, sigma);
  }
}
