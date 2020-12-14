## relabel a tree
library(ape)
library(openxlsx)
library(magrittr)

#tr.file <- dir('../DATA.TREES/2018-08-ff/', patt = 'bipartitions.ulm', full = T) # only does one at a time
tr.svd <- read.nexus('../DATA.TREES/svdQuartets.2019-06-20.strictNoHybs/rad.singletons.m4.svdQuartetsBootstrap_2019-07-02.tre')
tr.ulm <- read.tree(tr.file)
tr.ulm.outFile <- strsplit(tr.file, "bipartitions.|.tre")[[1]][2]
tr.dat <- read.xlsx('../DATA.TABLES/ulmus.table.final_2018-08-22.xlsx', 1)
row.names(tr.dat) <- tr.dat$fastq_label
### og <- c('ZELSER-1', 'HEMDAV-1')

### R1: changing outgroup to Zelkova only; 2020-11-20
og <- c('ZELSER-1')
dropsies <- c('ZELSER-1', 'HEMDAV-1')
if(all(og %in% tr.ulm$tip.label)) tr.ulm <- root(tr.ulm, og) %>% ladderize
if(doNiceFig) tr.ulm <- drop.tip(tr.ulm, dropsies)

source('../SCRIPTS/99.relabelTree.R')

tr.out <- relabel.tree()
tr.ulm.outFile <- paste('../OUT/', tr.ulm.outFile, format(Sys.time(), "_%Y-%m-%d_%H%M%S.pdf"), sep = '')
pdf(tr.ulm.outFile, 8.5, 11)
plot(tr.out, cex = 0.6, label.offset = sort(tr.out$edge.length)[10] * 3)
nodelabels(node = seq(from = length(tr.out$tip.label) + 1,
                      to = max(tr.out$edge)),
            text = tr.out$node.label,
            cex = 0.5, adj = c(1.2,1.2),
          frame = 'n')
if(doNiceFig) {
  dat.singletons <- read.csv('../DATA.TABLES/SUPPLEMENT.tipsInSingletonsTree.csv', as.is = T, row.names = 1)
  tiplabels(tip = which(tr.out$tip.label %in% dat.singletons$tip.label),
            pch = 19)
}
dev.off()
