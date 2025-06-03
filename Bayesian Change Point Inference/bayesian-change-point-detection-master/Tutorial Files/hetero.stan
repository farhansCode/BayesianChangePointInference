data {
  int<lower=1> n;           // Number of samples
  vector[n] X;              // Predictor variables
  vector[n] y;              // Response variable
}

parameters {
  real alpha;               // Intercept 
  real beta;                // Slope
  real<lower=0> sigma;      // Scatter (standard deviation)
}

model {
  // Priors
  alpha ~ normal(0, 10);
  beta ~ normal(0, 10); 
  sigma ~ cauchy(0, 1); // Use ~ to define the prior

  // Likelihood
  y ~ normal(alpha + beta * X, sigma);
}
