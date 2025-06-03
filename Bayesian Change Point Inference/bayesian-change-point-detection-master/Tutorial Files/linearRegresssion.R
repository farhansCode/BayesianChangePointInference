
# Load the iris dataset and extract data for the versicolor species
require(rstan)
data(iris)
versicolor = which(iris$Species == 'versicolor')
x = iris$Sepal.Length[versicolor]
y = iris$Petal.Length[versicolor]

# Prepare the data list for the Stan model
data = list(N = length(x), x = x, y = y)

# Run the Stan model
fit = stan(file = 'linearRegression.stan', data = data)
print(fit)
summary(fit)

# Plot the original data
plot(x, y, main = "Linear Regression with Bayesian Confidence Interval", xlab = "Sepal Length", ylab = "Petal Length")

# Extract posterior samples from the fitted model
params = extract(fit)
alpha = mean(params$alpha)
beta = mean(params$beta)

# Add the regression line to the plot
abline(a = alpha, b = beta, col = "blue", lwd = 2)  # Regression line in blue

# Create a sequence of x-values for plotting the confidence interval
xr = seq(4, 7.5, 0.1)

# Calculate the 90% confidence interval for each x-value in the sequence
yCI = sapply(xr, function(k) quantile(params$beta * k + params$alpha, probs = c(0.05, 0.95)))

# Add the confidence interval lines to the plot
lines(xr, yCI[1, ], col = 'red', lwd = 2, lty = 2)  # Lower bound in red, dashed line
lines(xr, yCI[2, ], col = 'red', lwd = 2, lty = 2)  # Upper bound in red, dashed line
fit=stan(file='linearRegression.stan', data=data)
plot(density(y), xlim = c(2, 6.5), ylim = c(0, 1.4))

params = extract(fit)
for (i in 1:10) {
  lines(density(params$y_sim[i, ]), col = 'red')
}
y_new = params$y_sim[20, ]
data_new = list(N = length(x), x = x, y = y_new)
fit_new = stan(file = 'linearRegression.stan', data = data_new)

params_new = extract(fit_new)
plot(density(params$alpha))
lines(density(params_new$alpha), col = 'red')
plot(density(params$beta))
lines(density(params_new$beta),col='red')

