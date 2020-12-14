library(RADami)
### R1: note that you should be using RADami >= 1.1-3, installed from github:
###   - see README at https://github.com/andrew-hipp/RADami
### source('https://raw.githubusercontent.com/andrew-hipp/RADami/master/R/read.pyRAD.R')

rad.thresh <- 4
### outfileName <- '../DATA.TREES/rad.singletons.m4.phy'

### R1: switching all output to ../OUT
outfileName <- '../OUT/rad.singletons.m4.phy'

rad.single.tips <- c(
  tr.dat$fastq_label[match(tr.pruned$tip.label, tr.dat$ordinationSp)],
  'ZELSER-1', 'HEMDAV-1'
)
if(!exists('elm.rads')) elm.rads <- read.pyRAD('../RADwork/ulmus2018b_strictNoHybrids.loci')
elm.mat <- elm.rads$radSummary$inds.mat
rads.last.char <- sapply(row.names(elm.mat), function(x) substr(x, nchar(x), nchar(x)))
rads.last.char.ab <- which(rads.last.char %in% c('A', 'B'))
row.names(elm.mat)[rads.last.char.ab] <-
  sapply(row.names(elm.mat)[rads.last.char.ab], function(x) substr(x, 1, nchar(x)-1))

elm.single.inds <-
  which(row.names(elm.mat) %in% rad.single.tips)
elm.single.loci <-
  colnames(elm.mat)[which(colSums(elm.mat[elm.single.inds, ]) >= rad.thresh)]
elm.single.inds <- row.names(elm.rads$radSummary$inds.mat)[elm.single.inds]
rad2phy(rad2mat(elm.rads), inds = elm.single.inds, loci = elm.single.loci,
          outfile = outfileName)

message(paste('convert', outfileName, 'to NEXUS, slide into svdQuartets folder, and analyze.'))
