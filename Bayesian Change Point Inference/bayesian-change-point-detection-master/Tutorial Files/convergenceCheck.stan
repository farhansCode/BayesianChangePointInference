data {
    int<lower=0> J; // number of schools
    vector[J] y; // observed treatment effect
    vector<lower=0>[J] sigma; // uncertainty on observed effect
}

parameters {
    vector[J] theta; // true treatment effect
    real mu; // population treatment effect
    real<lower=0> tau; // population scale
}

model {
    // hyper priors
    mu ~ normal(0,5);
    tau ~ cauchy(0,5);

    theta ~ normal(mu, tau);

    // likelihood
    y ~ normal(theta, sigma);
}

