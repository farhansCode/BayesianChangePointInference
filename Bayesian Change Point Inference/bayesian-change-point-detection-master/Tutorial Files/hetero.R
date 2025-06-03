n=100
a=0.4
b=1.3
x = runif(n,0,10)
y = a + b * x +rnorm(n,0,0.3)*x
plot(x,y,pch=20)



require(rstan)
data = list(n = length(y), y=y, X=x)
#fit=stan(model_code = my_model, data=data)
fit=stan(file = 'hetero.stan', data=data)
pairs(fit, pars=c('alpha','beta','sigma'))
ts = data.frame(year = time(EuStockMarkets))
stock = data.frame(EuStockMarkets)
stocks

t = ts$year #time
y = stock$FTSE #stock price
pc_dif = diff(y)/y[-length(y)]*100 #calculate percentage change
plot(t, y, ty='l', xlab='year', ylab='price')
plot(t[-1], pc_dif, ty='l', xlab='year', ylab='percentage change')

data = list(T = length(pc_dif), r = pc_dif)
fit = stan(file='arch.stan', data=data)
params = extract(fit)
mu = mean(params$mu)

alpha0 = mean(params$alpha0)
alpha1 = mean(params$alpha1)
pred = sapply(2:1860, function(x) mu + 
                sqrt(alpha0 + alpha1 * (pc_dif[x-1] - mu)^2) )

plot(t[-1], pc_dif, ty='l', xlab='time', ylab='percentage change')
lines(t[-1], pred, lty='solid', col='red')
lines(t[-1], -pred, lty='solid', col='red')

data = list(T = length(pc_dif), r = pc_dif, sigma1 = 0.1)
fit = stan(file = 'garch.stan', data = data)

