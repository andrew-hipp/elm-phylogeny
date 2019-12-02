## plot publication tree
library(phytools)
library(ggtree)

saveAncPlot <- FALSE
source('../SCRIPTS/07.plot_anc_range.edited.R')
tr.prettyPlot <- read.nexus(tree_fn)

taxa.sect <- c(
  Blepharocarpus = 'americana|laevis',
  Chaetoptelea = 'alata|crassifolia|elongata|mexicana|serotina|thomas',
  Trichocarpus = 'macrocarpa|lamellosa',
  #Microptelea = 'parvifolia',
  Foliaceae = 'davidiana|castaneifolia|chenmoui|prunifolia|szechuanica|minor|pumila',
  Ulmus = 'glabra|uyematsui|laciniata|wallichiana|rubra'
)

taxa.subg <- c(
  #Indoptelea = 'villosa',
  Oreoptelea = paste(taxa.sect[c('Blepharocarpus', 'Chaetoptelea')], collapse = '|'),
  Ulmus = paste(taxa.sect[c('Trichocarpus', 'Microptelea', 'Foliaceae', 'Ulmus')], collapse = '|')
)

taxa.subg <- sapply(taxa.subg, grep, x = tr.prettyPlot$tip.label, value = T)
taxa.sect <- sapply(taxa.sect, grep, x = tr.prettyPlot$tip.label, value = T)

nodes.sect <- sapply(taxa.sect, findMRCA, tree = tr.prettyPlot)
nodes.subg <- sapply(taxa.subg, findMRCA, tree = tr.prettyPlot)

nodes.sect <- c(nodes.sect,
                Microptelea = which(tr.prettyPlot$tip.label == 'parvifolia')
                )
nodes.subg <- c(nodes.subg,
                Indoptelea = which(tr.prettyPlot$tip.label == 'villosa')
                )

for(i in 1:length(nodes.sect)) {
  pp <- pp + geom_cladelabel(node = as.numeric(nodes.sect)[i],
                             label = paste('sect.', names(nodes.sect)[i], sep = '\n'),
                             offset = 10,
                             fontsize = 3
                            )
} # close i

for(i in 1:length(nodes.subg)) {
  pp <- pp + geom_cladelabel(node = as.numeric(nodes.subg)[i],
                             label = paste('subg.', names(nodes.subg)[i], sep = '\n'),
                             offset = 24,
                             fontsize = 3
                            )
} # close i

pp$coordinates$limits <- list(x = c(-4, 84), y = NULL)

sc = state_colors
names(sc) <- unlist(state_labels)

# print(pp)
ggsave(file = 'PDFs/FigXX.prettyPlot.pdf', plot = pp, width = 7, height = 8.5)

## make a legend
sc.df <- stateCols
sc.df$x <- 1:dim(sc.df)[1]
sc.df$y <- 0
sc.df$Range <- factor(row.names(sc.df), levels = row.names(sc.df))
pp.leg <- ggplot(sc.df, aes(x = x, y = y, color = Range))
pp.leg <- pp.leg + geom_point()
pp.leg <- pp.leg + scale_color_manual(name = "Geographic ranges",
                              values = sc
                              #, breaks = names(sc)
                            )
# pp.leg = pp.leg + guides(colour = guide_legend(ncol=2))
# pp.leg = pp.leg + theme(legend.background = element_rect(color='white'))
ggsave(file = 'PDFs/FigXX.prettyPlot.legend.pdf', plot = pp.leg, width = 7, height = 8.5)
