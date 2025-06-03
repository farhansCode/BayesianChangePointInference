data {
    int<lower=1> N;  // Number of days
    array[N] real Total_Cases; // Observed total cases
}

parameters {
    real<lower=0> amp1;  // Amplitude of first variant
    real<lower=0> amp2;  // Amplitude of second variant
    real<lower=1, upper=N> mu1;  // Peak day for first variant
    real<lower=1, upper=N> mu2;  // Peak day for second variant
    real<lower=0> sigma1; // Spread of first variant
    real<lower=0> sigma2; // Spread of second variant
    real<lower=1, upper=N> tau; // Change-point day
    real<lower=0> sigma_obs; // Observation noise
}

transformed parameters {
    array[N] real mu_cases;
    for (n in 1:N) {
        real w = inv_logit(5 * (n - tau));  // Smooth transition between outbreaks
        real variant1 = amp1 * exp(-((n - mu1)^2) / (2 * sigma1^2));
        real variant2 = amp2 * exp(-((n - mu2)^2) / (2 * sigma2^2)) * w;
        mu_cases[n] = variant1 + variant2;
    }
}

model {
    // Priors
    amp1 ~ normal(1000, 10);  // Amplitudes
    amp2 ~ normal(800, 10);
    mu1 ~ normal(50, 5);
    mu2 ~ normal(150, 5);
    sigma1 ~ lognormal(log(10), 0.5);
    sigma2 ~ lognormal(log(10), 0.5);
    tau ~ normal(100, 5);
    sigma_obs ~ lognormal(0, 0.5);

    // Likelihood
    for (n in 1:N) {
        Total_Cases[n] ~ normal(mu_cases[n], sigma_obs);
    }
}
