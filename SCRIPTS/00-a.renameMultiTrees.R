library(ape)
doNiceFig <- FALSE

tr.file <- dir('../DATA.TREES/raxml.2019-04-04/noTetraploids', patt = 'bipartitions.ulm', full = T)
source('../SCRIPTS/00-b.relabel.tree.R')

tr.file <- dir('../DATA.TREES/raxml.2019-04-04/strictClust', patt = 'bipartitions.ulm', full = T)
source('../SCRIPTS/00-b.relabel.tree.R')

tr.file <- dir('../DATA.TREES/raxml.2019-04-23.noHybs/noTetraploids-noHybs', patt = 'bipartitions.ulm', full = T)
source('../SCRIPTS/00-b.relabel.tree.R')

tr.file <- dir('../DATA.TREES/raxml.2019-04-23.noHybs/strict-noHybs', patt = 'bipartitions.ulm', full = T)
doNiceFig <- TRUE
source('../SCRIPTS/00-b.relabel.tree.R')
