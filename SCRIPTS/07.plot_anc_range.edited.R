library('RevGadgets')
library('ips')
library('ggplot2')
# If not installed, install from GitHub:
#   install_github("revbayes/RevGadgets")

# source('../SCRIPTS/plot_anc_range.util.R')
source('../SCRIPTS/make.states2.R')
# if(!exists('plot_ancestral_states2'))
# source('../SCRIPTS/plot_ancestral_states2.R')
if(!exists('saveAncPlot')) saveAncPlot <- TRUE
# file names
fp = "./" # edit to provide an absolute filepath
plot_fn = paste(fp, "../OUT/elm.DEC.phylo-R1-2.pdf",sep="")
#tree_fn = paste(fp, "out/simple.tre", sep="")
### tree_fn = paste(fp, "../REVBAYES/out/simple.ase.tre", sep="") # this should be used, not above
### label_fn = paste(fp, "../REVBAYES/out/simple.state_labels.txt", sep="")
### color_fn = paste(fp, "../REVBAYES/out/range.colors.cbb.txt", sep="")

### updating file names
tree_fn = paste(fp, "../REVBAYES/out/simple.3state.ase.tre", sep="") # this should be used, not above
label_fn = paste(fp, "../REVBAYES/out/simple.3state.state_labels.txt", sep="")
color_fn = paste(fp, "../REVBAYES/out/range.colors.cbb.txt", sep="")

# get state labels and state colors
states = make_states(label_fn, color_fn, fp=fp)
state_labels = states$state_labels
state_colors = states$state_colors

## HARD CODED DUMB FIX FOR NA ISSUE
stateCols <- read.csv(color_fn, as.is = T, row.names = 1)
state_labels[1:dim(stateCols)[1]] <- row.names(stateCols)
state_colors[1:dim(stateCols)[1]] <- stateCols$color

# plot the ancestral states
# pp = plot_ancestral_states2(tree_file=tree_fn,
pp = RevGadgets::plot_ancestral_states(tree_file=tree_fn,
                         include_start_states=T,
                         summary_statistic="PieRange",
#                         summary_statistic="mean",
                         state_labels=state_labels,
                         state_colors=state_colors,
                         tip_label_size=2.5,
                         tip_label_offset=2,
                         tip_point_offset = 1,
                         tip_label_italics = T,
                         node_label_size=0,
                         shoulder_label_size=0,
                         show_posterior_legend=T,
                         tip_pie_diameter=0,
                         node_pie_diameter= 5,
                         pie_nudge_x=0,
                         pie_nudge_y=0,
                         use_state_colors = FALSE, # added AH 2019-08-19
                         show_state_legend = FALSE,
                         alpha=1)

# get plot dimensions
x_phy = max(pp$data$x)       # get height of tree
x_label = 2                # choose space for tip labels
x_start = 40                  # choose starting age (greater than x_phy)
x0 = -(x_start - x_phy)      # determine starting pos for xlim
x1 = x_phy + x_label         # determine ending pos for xlim

# add axis
pp = pp + theme_tree2(legend.position = c(0.1,0.85))
# pp <- pp + theme(legend.position = c(0.1,0.85), axis.line = element_line(color = 'black'),
#                   axis.line.y = element_blank(),
#                   axis.ticks.y = element_blank(),
#                   axis.text.y = element_blank()
#                 )
pp = pp + labs(x="Age (Ma)")

# # change x coordinates
# pp = pp + coord_cartesian(xlim=c(x0,x1), expand=TRUE)

# plot ticks
# x_breaks_major = seq(0,x_start,10) + x0
# x_breaks_minor = seq(0,x_start,5) + x0
# x_labels = rev(seq(0,x_start,10))
# pp = pp + scale_x_continuous(breaks=x_breaks_major, minor_breaks = x_breaks_minor, labels=x_labels)

# save
if(saveAncPlot) ggsave(file=plot_fn, plot=pp, device="pdf", height=7, width=7, useDingbats=F)
