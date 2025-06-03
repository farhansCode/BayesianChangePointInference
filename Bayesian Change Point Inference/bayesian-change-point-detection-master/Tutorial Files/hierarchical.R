data = read.csv('premiereleague.csv', col.names = c('Home', 'score1', 'score2', 'Away'), stringsAsFactors = FALSE)

head(data)
ng = nrow(data)
nt = length(unique(data$Home))
teams = unique(data$Home)
ht = unlist(sapply(1:ng, function(g) which(teams == data$Home[g])))
at = unlist(sapply(1:ng, function(g) which(teams == data$Away[g])))
np = 5
ngob = ng - np
my_data = list(
  nt = nt,
  ng = ngob,
  ht = ht[1:ngob],
  at = at[1:ngob],
  s1 = data$score1[1:ngob],
  s2 = data$score2[1:ngob],
  np = np,
  htnew = ht[(ngob+1):ng],
  atnew = at[(ngob+1):ng]
)

nhfit = stan(file = 'hierarchical.stan', data = my_data)
nhpoolparams = extract(nhpoolfit)
pred_scores = c(colMeans(nhpoolparams$s1new), colMeans(nhpoolparams$s2new))
pred_errors = c(sapply(1:np, function(x) sd(nhpoolparams$s1new[,x])),
                sapply(1:np, function(x) sd(nhpoolparams$s2new[,x])))
true_scores = c(data$score1[(ngob+1):ng], data$score2[(ngob+1):ng])
plot(true_scores, pred_scores)
abline(a=0, b=1, lty='dashed')
arrows(true_scores, pred_scores+pred_errors, true_scores, 
       pred_scores-pred_errors, length = 0.05, angle = 90, code = 3)

attack = colMeans(nhpoolparams$att)
defense = colMeans(nhpoolparams$def)
plot(attack, defense)

#change priors in .stan file to
#att ~ normal(0, 2);
#def ~ normal(0, 2);
nhfit = stan(file = 'non_hier_model.stan', data = my_data)
#Now change model to this
#model {
#  // hyperpriors
#  mu_att ~ normal(0, 0.1);
#  tau_att ~ normal(0, 1);
#  mu_def ~ normal(0, 0.1);
#  tau_def ~ normal(0, 1);
  
  #// priors
#  att ~ normal(mu_att, tau_att);
#  def ~ normal(mu_def, tau_def);
#  home ~ normal(0, 0.0001);
  
  #// likelihood
 # s1 ~ poisson(theta1);
 # s2 ~ poisson(theta2);
#}

hparams = extract(hfit)
pred_scores = c(colMeans(hparams$s1new), colMeans(hparams$s2new))
pred_errors = c(sapply(1:np, function(x) sd(hparams$s1new[,x])),
                sapply(1:np, function(x) sd(hparams$s2new[,x])))
plot(true_scores, pred_scores)

attack = colMeans(hparams$att)
attacksd = sapply(1:nt, function(x) sd(hparams$att[,x]))
defense = colMeans(hparams$def)
defensesd = sapply(1:nt, function(x) sd(hparams$def[,x]))
plot(attack, defense, pch=20)
arrows(attack-attacksd, defense, attack+attacksd, defense, code=3, angle=90, length=0.04, col=rgb(0,0,0,0.2))
arrows(attack, defense-defensesd, attack, defense+defensesd, code=3, angle=90, length=0.04, col=rgb(0,0,0,0.2))

