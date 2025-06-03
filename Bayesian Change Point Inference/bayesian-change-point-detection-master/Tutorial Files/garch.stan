data {
    int<lower=0> T;
    array[T] real r;
    real<lower=0> sigma1; // scale of noise at t=1
}

parameters {
    real mu; // average return
    real<lower=0> alpha0; // intercept
    real<lower=0, upper=1> alpha1; // slope on location
    real<lower=0, upper=(1-alpha1)> beta1; // slope on volatility
}

transformed parameters {
    array[T] real<lower=0> sigma;
    sigma[1] = sigma1;
    for (t in 2:T) {
        sigma[t] = sqrt(alpha0
                        + alpha1 * pow(r[t-1] - mu, 2)
                        + beta1 * pow(sigma[t-1], 2)); // error term
    }
}

model {
    // priors
    alpha0 ~ normal(0, 10);
    alpha1 ~ normal(0, 10);
    beta1 ~ normal(0, 10);

    // likelihood
    r ~ normal(mu, sigma);
}
