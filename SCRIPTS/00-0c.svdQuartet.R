library(ape)
tr.svd <- read.tree('../DATA.TREES/svdQuartets.2019-07-02.tre')
tr.svd$tip.label <- gsub('_', '-', tr.svd$tip.label, fixed = T)
tr.svd <- relabel.tree(tr.svd)
tr.svd <- root(tr.svd, c("Hemiptelea davidii","Zelkova serrata"))
tr.svd <- ladderize(tr.svd)
tr.svd$edge.length[
  which(tr.svd$edge[, 2] %in% seq(length(tr.svd$tip.label)))
  ] <- NA

pdf('Fig.S2.svdQuartets.pdf')
plot(tr.svd, use.edge.length = FALSE)
edgelabels(text = tr.svd$edge.length, frame = 'n', adj= c(1, 1.2), cex = 0.5)
dev.off()
