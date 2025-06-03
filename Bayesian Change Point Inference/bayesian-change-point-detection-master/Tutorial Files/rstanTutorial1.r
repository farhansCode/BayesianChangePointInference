#following the rstan tutorial on youtube

data {
  int N;
  real X[N];
}

parameters{
  real mu;
  real sigma;
  
}

model {
  X ~ normal(mu, sigma)
}





