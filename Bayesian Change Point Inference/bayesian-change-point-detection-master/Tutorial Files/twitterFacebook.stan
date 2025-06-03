
data {
  int n;
  array[n] int y1;
  array[n] int y2;
}


parameters {
  real<lower=0, upper =1> theta1;
  real<lower=0, upper =1> theta2;

}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  theta1 ~ beta(1,1); //uniform prior
  theta2 ~ beta(1,1); //uniform prior
  y1 ~ bernoulli(theta1); //likelihood
  y2 ~ bernoulli(theta2); //likelihood
}

generated quantities {
  
  real Delta_theta;
  Delta_theta = theta1 - theta2;
  
  
}