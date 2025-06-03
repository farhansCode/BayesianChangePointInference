data{
    int N;
    array[N] real X;
}

parameters {

real mu;
real sigma;
}

model {
    X ~ normal(mu,sigma);
}