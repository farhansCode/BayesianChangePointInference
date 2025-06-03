data {
  int<lower=0> nt; // number of teams
  int<lower=0> ng; // number of games
  array[ng] int<lower=0> ht; // home team index
  array[ng] int<lower=0> at; // away team index
  array[ng] int<lower=0> s1; // score home team
  array[ng] int<lower=0> s2; // score away team
  int<lower=0> np; // number of predicted games
  array[ng]int<lower=0> htnew; // home team index for prediction
  array[ng] int<lower=0> atnew; // away team index for prediction
}

parameters {
  real home; // home advantage
  vector[nt] att; // attack ability of each team
  vector[nt] def; // defence ability of each team
}

transformed parameters {
  vector[ng] theta1; // score probability of home team
  vector[ng] theta2; // score probability of away team

  theta1 = exp(home + att[ht] - def[at]);
  theta2 = exp(att[at] - def[ht]);
}
model {
  // priors
  att ~ normal(0, 0.0001);
  def ~ normal(0, 0.0001);
  home ~ normal(0, 0.0001);

  // likelihood
  s1 ~ poisson(theta1);
  s2 ~ poisson(theta2);
}

generated quantities {
  // generate predictions
  vector[np] theta1new; // score probability of home team
  vector[np] theta2new; // score probability of away team
  array[np] real s1new; // predicted score
  array[np] real s2new; // predicted score

  theta1new = exp(home + att[htnew] - def[atnew]);
  theta2new = exp(att[atnew] - def[htnew]);
  s1new = poisson_rng(theta1new);
  s2new = poisson_rng(theta2new);
}
