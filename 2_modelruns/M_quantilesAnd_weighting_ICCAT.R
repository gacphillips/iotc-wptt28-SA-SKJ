
#
#     Estimate the 80th quantile and the weighting for each of the quantiles.
#     ICCAT method
#     Rodrigo Sant Ana
#..............................................................................


Amax=8
n=1000000
mu=log(5.4/Amax)


x=rlnorm(n, meanlog = mu, sdlog = 0.31)
median(x)
sd(log(x))

q_low = 0.10 #0.25
q_high = 0.9 #0.75
q_low=qlnorm(q_low, meanlog = mu, sdlog = 0.31)
q_50=qlnorm(0.5, meanlog = mu, sdlog = 0.31)
q_high=qlnorm(q_high, meanlog = mu, sdlog = 0.31)

#
round(c(q_low, q_50, q_high), digits = 2)
round(c(quantile(x, probs = q_low), quantile(x, probs = 0.5), quantile(x, probs = q_high)), digits = 1)


### Check the probabilities
p_low <- plnorm(q_low, meanlog = mu, sdlog = 0.31)
p_50 <- plnorm(q_50, meanlog = mu, sdlog = 0.31)
p_high <- plnorm(q_high, meanlog = mu, sdlog = 0.31)

round(c(p_low, p_50, p_high), digits = 2)


### Normalize the weights
dens <- dlnorm(c(q_low, q_50, q_high), mu, 0.31)
wts <- dens / sum(dens)

## the weightings
round(wts, digits = 2)
