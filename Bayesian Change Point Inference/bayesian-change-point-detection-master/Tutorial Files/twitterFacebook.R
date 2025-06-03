require(rstan)
y_fb = c(0,0,0,0,0,1,0,0,0,1)
y_tw = c(1,1,0,0,0,1,0,0,0,1)
data = list(y1 = y_fb, y2=y_tw, n=length(y_fb))
fit = stan(file='twitterFacebook.stan', data=data)
print(fit)
params = extract(fit)
plot(density(params$theta1))
lines(density(params$theta2))


#So the click through rate for x is greater than y
#quantify the uncertainty in the data

y_fb = c(0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0,
         0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0,
         0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0,
         0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1)

y_tw = c(1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
         1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0,
         0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0,
         1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0)

data = list(y1 = y_fb, y2 = y_tw, n = length(y_fb))
fit = stan(file='twitterFacebook.stan', data=data)
print(fit)
params = extract(fit)
#Facebook is plotted first
plot(density(params$theta1), col = "blue", main = "Density Plot of Theta Parameters", xlab = "Theta", ylab = "Density")
lines(density(params$theta2), col = "red")
#theta on the graph is the click through rate
#Density here is the probility