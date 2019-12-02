## prune your tree and ultrametricize

source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/label.elements.R')

elm.pruner <- function(tr, delim = '|') {
  tips <- label.elements(tr, delim, fixed = T)
  tr.out <- drop.tip(tr, which(duplicated(tips)))
  tr.out$tip.label <- tips[which(!duplicated(tips))]
  return(tr.out)
  }
  
