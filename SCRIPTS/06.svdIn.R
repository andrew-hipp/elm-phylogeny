library(ape)
tr.svd <- read.nexus('../DATA.TREES/svdQuartets.2019-06-20.strictNoHybs/rad.singletons.v2.tre')
tr.svd$tip.label <- gsub('_', '-', tr.svd$tip.label, fixed = T)
tr.file <- '../DATA.TREES/svdQuartets.2019-06-20.strictNoHybs/rad.singletons.v2.nwk.tre'
write.tree(tr.svd, file = tr.file)

source('../SCRIPTS/00-b.relabel.tree.R')
