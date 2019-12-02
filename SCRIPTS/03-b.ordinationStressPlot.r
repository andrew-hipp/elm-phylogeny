library(magrittr)
if(!exists('tr.dist.mdsStress')) tr.dist.mdsStress <- lapply(1:10, function(x) monoMDS(tr.dist, k = x))
sapply(tr.dist.mdsStress, '[[', 'stress') %>% plot
message('Stress by K')
sapply(tr.dist.mdsStress, '[[', 'stress') %>% print

message('Decreases in stress with increase in K')
sapply(tr.dist.mdsStress, '[[', 'stress') %>% diff %>% print
