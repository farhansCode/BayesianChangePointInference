
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; //integer number if data points
  vector[N] x; //covariates
  vector[N] y; //variates
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real alpha;//intercpet
  real beta;//slope
  real<lower=0> sigma;//scatter
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  //priors
  alpha ~ normal(0,10);
  beta ~ normal(0,10);
  sigma ~ normal(0, 1);
  
  y~ normal(alpha + x, sigma);//likelihood
}

generated quantities {
  vector[N] y_sim;  // Simulated data from the posterior

  for (i in 1:N)
    y_sim[i] = normal_rng(alpha + beta * x[i], sigma);
}



