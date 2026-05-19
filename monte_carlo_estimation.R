# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Integral Estimation                                                       ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)
## For all exercises, we use n = 1e4 as a sample size.
n <- 1e4
obs_num <- 1:n

# Estimation of the integral of h(x) = (cos(x) - sin(x)) ^ 2 over the (0, 10)
# interval.
h <- function(x) {
  (cos(x) - sin(x)) ^ 2
}
obs <- 10 * runif(n)
hbar <- 10 * cumsum(h(obs)) / obs_num
df <- data.frame(obs_num, obs, hbar)
real_value <- integrate(h, lower = 0, upper = 10)$value
ggplot(df, aes(obs_num, hbar))+
  geom_line(color = "red")+
  geom_hline(yintercept = real_value, linetype = "dashed")+
  labs(title = "Monte Carlo Integration with Uniform",
       x = "n", y = "Mean")
est <- hbar[n]
est # Final estimation of the integral
abserr <- abs(est - real_value)
abserr # Absolute error

# Estimation of the distribution function F(x) of the Cauchy(0, 1) distribution 
# for x = -1, 0, 10.
my_pcauchy <- function(x, pl = T) {
  h <- function(y) {
    as.numeric(y <= x)
  }
  obs <- rcauchy(n)
  hbar <- cumsum(h(obs)) / obs_num
  if (pl) {
    real_value <- pcauchy(x)
    df <- data.frame(obs_num, hbar)
    print(
      ggplot(df, aes(obs_num, hbar))+
        geom_line(color = "red")+
        geom_hline(yintercept = real_value, linetype = "dashed")+
        labs(title = paste0("Monte Carlo Estimation of F(", x, ")"), 
             x = "n", y = "Mean")
    )
  }
  hbar[n]
}
my_pcauchy(-1)
my_pcauchy(0)
my_pcauchy(10)

# Estimation of the probability P(X < Y) and the probability P(X + Y > 5), where
# X~Gamma(2, 1) and Y~Geom(0.4) are two independent random variables.
a <- 2 ; lambda <- 1 ; p <- .4
obs <- rgeom(n, p)
hbar1 <- mean(pgamma(obs, a, lambda))
hbar1 # P(X < Y)
hbar2 <- 1 - mean(pgamma(5 - obs, a, lambda))
hbar2 # P(X + Y > 5)

# Let X ~ LogNorm(0, 1).
# Calculation of the probability P(X > 150) using importance sampling,
# simulating from the Exponential distribution with scale = 100.
h <- function(y) {
  dlnorm(y) * as.numeric(y > 150) / dexp(y, rate = 1 / 100)
}
obs <- rexp(n, 1 / 100)
hbar <- cumsum(h(obs)) / obs_num
df <- data.frame(obs_num, hbar)
real_value <- plnorm(150, lower.tail = FALSE)
ggplot(df, aes(obs_num, hbar))+
  geom_line(color = "red")+
  geom_hline(yintercept = real_value, linetype = "dashed")+
  labs(title = "Monte Carlo Estimation of P(X > 150)",
       x = "n", y = "Mean")
hbar[n] # P(X > 150)

