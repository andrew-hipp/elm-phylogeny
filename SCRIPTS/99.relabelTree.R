relabel.tree <- function(tr = tr.ulm,
                         lastCharsToClean = c('A', 'B'),
                         dat = tr.dat,
                         label.columns = c('tip_new'),
            						 label.delim = "|",
                         dewDrop = TRUE,
                         trFormat = TRUE
            						 )
  {
    if(!trFormat) tr <- list(tip.label = tr)
    last.char <- sapply(tr$tip.label, function(x) substr(x, nchar(x), nchar(x)))
		last.char.ab <- which(last.char %in% lastCharsToClean)
		#rm(last.char, last.char.ab)
    tr.origTips <- tr$tip.label
		tr$tip.label[last.char.ab] <-
      sapply(tr$tip.label[last.char.ab], function(x) substr(x, 1, nchar(x)-1))
    if(dewDrop) tr.dropTips <- which(tr$tip.label %in% tr.dat$fastq_label[which(!tr.dat$include)])
      else tr.dropTips <- numeric(0)
    if(length(tr.dropTips) > 0) {
      if(trFormat) tr <- drop.tip(tr, tr.dropTips)
      if(!trFormat) tr <- tr[-tr.dropTips]
      tr.origTips <- tr.origTips[-tr.dropTips]
    }
		if(length(label.columns) > 1) {tr$tip.label <- apply(dat[tr$tip.label, label.columns], 1, paste, collapse = label.delim)
      } else tr$tip.label <- dat[tr$tip.label, label.columns]
    write.csv(cbind(orig = tr.origTips,
                    new = tr$tip.label),
              '../OUT/tree.labels.csv')
		return(tr)
		}
