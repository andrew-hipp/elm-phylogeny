library(coda)
dat.log <- read.table('../REVBAYES/out/simple.3state.model.log', header = T, as.is = T)
write.csv(print(apply(dat.log[501:5001, ], 2, effectiveSize)), 'ess.csv')
write.csv(print(apply(dat.log[501:5001, ], 2, quantile, c(0.025, 0.5, 0.975))), 'quantiles.csv')
