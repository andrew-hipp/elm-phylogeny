library(ape)
library(vegan)
library(openxlsx)
library(ggplot2)
library(gridExtra)
library(ggrepel)

source('../SCRIPTS/99.distMatFormat.R')
source('../SCRIPTS/99.relabelTree.R')

tr.dist <- rax.conv()
tr.dat <- read.xlsx('../DATA.TABLES/ulmus.table.final_2018-08-22.xlsx', 1)
row.names(tr.dat) <- tr.dat$fastq_label

tr.dist.newLabels <- relabel.tree(dimnames(tr.dist)[[1]], trFormat=F, dewDrop=F)$tip.label
tr.dist.mat <- data.frame(
  new.labels = tr.dist.newLabels,
  include = as.logical(tr.dat$include[match(tr.dist.newLabels, tr.dat$tip_new)]),
  Species = tr.dat$ordinationSp[match(tr.dist.newLabels, tr.dat$tip_new)],
  Hybrid = as.logical(tr.dat$hybridRemoval[match(tr.dist.newLabels, tr.dat$tip_new)]),
  Section = tr.dat$Section[match(tr.dist.newLabels, tr.dat$tip_new)],
  row.names = dimnames(tr.dist)[[1]]
)
tr.dist.mat[grep('ZELSER|HEMDAV', row.names(tr.dist.mat)), 'include'] <- FALSE
tr.dist.mat[grep('americana|laevis|elongata|thomasii|mexicana|serotina|crassifolia|alata|villosa', tr.dist.mat$Species), 'include'] <- FALSE # get rid of non-davidiana / minor clade things
tr.dist <- tr.dist[which(tr.dist.mat$include), which(tr.dist.mat$include)]
tr.dist.mat <- tr.dist.mat[which(tr.dist.mat$include), ]
tr.dist.mat['ULMLAC-1', 'Hybrid'] <- TRUE # the putative U. laciniata x pumila
tr.dist.mat$Section <- tr.dist.mat$Section %>% as.character %>% as.factor # to clean out excess levels
tr.dist.mds <- monoMDS(tr.dist, k = 3)
tr.dist.mds.table <- as.data.frame(
  cbind(tr.dist.mds$points, tr.dist.mat)
)

geomSize = 2

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
p <- ggplot(tr.dist.mds.table, aes(color = Section, shape = Hybrid, label = Species))
p <- p + scale_color_manual(values = cbbPalette)
p1 <- p + geom_point(aes(x = MDS1, y = MDS2), size = geomSize)
p1 <- p1 + geom_text_repel(aes(x = MDS1, y = MDS2), size = geomSize)
p1 <- p1 + theme(legend.position = 'none')
p2 <- p + geom_point(aes(x = MDS1, y = MDS3), size = geomSize)
p2 <- p2 + geom_text_repel(aes(x = MDS1, y = MDS3), size = geomSize)
#p2 <- p2 + theme(legend.position = c(0.9, 0.1))

pdf('../OUT/ordination.pdf', 12, 6)
grid.arrange(p1, p2, nrow = 1, widths = c(2.4,3))
dev.off()
