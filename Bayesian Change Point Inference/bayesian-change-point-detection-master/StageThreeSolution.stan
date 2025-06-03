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
    real tau_unconstrained; // Unconstrained version of tau
    real<lower=0> sigma_obs; // Observation noise
    real<lower=0> alpha;  // Shape parameter for the gamma distribution
    real<lower=0> beta;   // Rate parameter for the gamma distribution
}

transformed parameters {
    real tau = 1 + (N - 1) * inv_logit(tau_unconstrained); // Maps to [1, N]
    array[N] real mu_cases;
    for (n in 1:N) {
        real w = inv_logit(2 * (n - tau));  // Smoothed transition
        real variant1 = amp1 * exp(-((n - mu1)^2) / (2 * sigma1^2));
        real variant2 = amp2 * gamma_cdf(n | alpha, beta);
        mu_cases[n] = (1 - w) * variant1 + w * variant2;  
    }
}

model {
    // Priors
    amp1 ~ normal(100, 20);  
    amp2 ~ normal(1500, 5);
    mu1 ~ normal(10, 3);
    mu2 ~ normal(35, 5);  
    sigma1 ~ lognormal(0, 0.5);
    sigma2 ~ lognormal(0, 0.5);
    
    tau_unconstrained ~ normal(-0.08, 1);  // tau is close to 25
    
    sigma_obs ~ lognormal(0, 0.5);
    alpha ~ gamma(6, 1);
    beta ~ gamma(2, 4);

    // Likelihood
    for (n in 1:N) {
        Total_Cases[n] ~ normal(mu_cases[n], sigma_obs);
    }
}

