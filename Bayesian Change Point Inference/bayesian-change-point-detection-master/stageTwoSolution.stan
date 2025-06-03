data {
    int<lower=1> N;  // Number of days
    array[N] real Observed_Cases; // Observed cases from the dataset
}

parameters {
    real<lower=0> amp1;  // Amplitude of first wave
    real<lower=0> amp2;  // Amplitude of second wave
    real<lower=1, upper=N> mu1;  // Peak day for first wave
    real<lower=1, upper=N> mu2;  // Peak day for second wave
    real<lower=0> sigma1; // Spread of first wave
    real<lower=0> sigma2; // Spread of second wave
    real<lower=1, upper=N> tau; // Change-point day (to be estimated)
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
    amp1 ~ normal(100, 20);  // Prior for first wave amplitude
    amp2 ~ normal(80, 20);   // Prior for second wave amplitude
    mu1 ~ normal(15, 5);     // First wave expected around day 15
    mu2 ~ normal(35, 5);     // Second wave expected around day 35
    sigma1 ~ lognormal(0, 0.5);
    sigma2 ~ lognormal(0, 0.5);
    tau ~ normal(25, 5); // Change-point prior centered around day 25
    sigma_obs ~ lognormal(0, 0.5);

    // Likelihood
    for (n in 1:N) {
        Observed_Cases[n] ~ normal(mu_cases[n], sigma_obs);
    }
}
