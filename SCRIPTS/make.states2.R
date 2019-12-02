makes_states <- function(label_fn, color_fn, fp="./") {

    # generate colors for ranges
    range_color_list = read.csv(color_fn, header=T, sep=",", colClasses="character", as.is = T)

    # get area names
    area_names = unlist(sapply(range_color_list$range, function(y) { if (nchar(y)==1) { return(y) } }))

    # get state labels
    state_descriptions = read.csv(label_fn, header=T, sep=",", colClasses="character")

    # map presence-absence ranges to area names
    range_labels = sapply(state_descriptions$range[2:nrow(state_descriptions)],
        function(x) {
            present = as.vector(gregexpr(pattern="1", x)[[1]])
            paste( area_names[present], collapse="")
        })

    # map labels to colors
    range_colors = range_color_list$color[ match(range_labels, range_color_list$range) ]

    # generate state/color labels
    idx = 1
    st_lbl = list()
    st_colors = c()
    for (j in 1:(nrow(state_descriptions)-1)) {
        st_lbl[[ as.character(j) ]] = range_labels[j]
        st_colors[j] = range_colors[j]
    }
    st_colors[ length(st_colors)+1 ] = "lightgray"
    st_lbl[["..."]] = "..."

    return( list(state_labels=st_lbl, state_colors=st_colors) )
}
