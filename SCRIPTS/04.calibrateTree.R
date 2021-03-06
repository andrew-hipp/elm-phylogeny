## time calibrate tree
## revised 2020-11-20 to calibrate stem instead of crown
##   - added lines indicated with ### comment above
##   - deleted lines commented with ### in front
library(ape)
library(openxlsx)
library(ggtree)

cvVect <- c(0.001, 0.1, 1, 5, 10, 20)
### ulmusCrown = 51

### R1: 51 Ma now a stem calibration; 2020-11-20
ulmusStem = 51
do.cv <- T
do.treePlot <- TRUE
doNiceFig <- FALSE

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

tr.file <- dir('../DATA.TREES/raxml.2020-12-10.noHybs.v2/strict-noHybs', patt = 'bipartitions.ulm', full = T)
source('../SCRIPTS/00-b.relabel.tree.R')

tr.geog <- read.xlsx('../DATA.TABLES/elmGeog_2019-04-27.xlsx', 1, rowNames = TRUE)

tr.tips <- tr.dat$ordinationSp[match(tr.out$tip.label, tr.dat$tip_new)]
tr.pruned <- drop.tip(tr.out, which(duplicated(tr.tips)))
### tr.pruned <- drop.tip(tr.pruned, grep('Hemiptelea|Zelkova|laciniata x pumila', tr.pruned$tip.label))

### R1: leaving Hemiptelea outgroup; 2020-11-20
tr.pruned <- drop.tip(tr.pruned, grep('Zelkova|laciniata x pumila', tr.pruned$tip.label))

tr.pruned.mat <- data.frame(tip.label = tr.pruned$tip.label,
                      sp = tr.dat$ordinationSp[match(tr.pruned$tip.label, tr.dat$tip_new)])
write.csv(tr.pruned.mat, 'SUPPLEMENT.tipsInSingletonsTree.csv')
tr.pruned$tip.label <- as.character(tr.pruned.mat$sp)

if(do.cv) {
  tr.pruned.cv <- lapply(cvVect, function(x) {
    chronopl(tr.pruned, lambda = x, age.min = ulmusStem, node = 'root', CV = TRUE)
  })
  names(tr.pruned.cv) <- as.character(cvVect)
}

### tr.biogeo <- tr.pruned.cv[['0.001']]

### R1: on new tree, rate smoothing CV lowest at 0.001
minCV <- sapply(tr.pruned.cv, attr, 'D2') %>%
  apply(MARGIN=2, FUN = mean) %>%
  sort %>%
  '['(1) %>%
  names
tr.biogeo <- tr.pruned.cv[[minCV]]

### R1: now dropping off Hemiptelea after calibration; 2020-11-20
tr.biogeo <- drop.tip(tr.biogeo, grep('Hemiptelea', tr.biogeo$tip.label))

if(do.treePlot) {
  p <- ggtree(tr.biogeo)
  p <- p + geom_tiplab()
  p <- gheatmap(p, tr.geog[, c(1,3), drop = FALSE], width = 0.1, colnames = F, offset = 15)
  p <- p + scale_fill_manual(values = cbbPalette)
  p <- p + theme(legend.position=c(0.1,0.9))
  pdf('../OUT/tree.w.geog.pdf')
  print(p)
  dev.off()
}

tr.biogeo2 <- tr.biogeo
tr.biogeo2$tip.label <- gsub('[ ()]', '', tr.biogeo2$tip.label)
tr.biogeo2$node.label <- NULL
### write.tree(tr.biogeo2, '../LAGRANGE/biogeographyTreeUsed-2.tre')

### R1: adding write.nexus to integrate REVBAYES more tightly; 2020-11-20
write.nexus(tr.biogeo2, file = '../OUT/tr.biogeo2.nex', translate = F)

### tr.geog.lagrange <- data.frame(row.names = tr.biogeo2$tip.label,
###                                A = ifelse(tr.geog[tr.biogeo$tip.label, 1] == 'North America', 1, 0),
###                                E = ifelse(tr.geog[tr.biogeo$tip.label, 1] == 'Eurasia', 1, 0)
###                              )
### write.table(tr.geog.lagrange, '../LAGRANGE/biogeography.matrix-v2.txt', sep = '\t', quote = F)
