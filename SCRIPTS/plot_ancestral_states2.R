plot_ancestral_states2 <-
  function (tree_file, summary_statistic = "MAP", tree_layout = "rectangular",
    include_start_states = FALSE, xlim_visible = c(0, 40), ylim_visible = NULL,
    tip_label_size = 4, tip_label_offset = 5, tip_label_italics = FALSE,
    tip_node_size = 2, tip_node_shape = 16,
    tip_point_offset =5,
    node_label_size = 4,
    node_pp_label_size = 0, node_label_nudge_x = 0.1, node_pp_label_nudge_x = 0.1,
    shoulder_label_size = 3, shoulder_label_nudge_x = -0.1, node_pie_diameter = 10,
    tip_pie_diameter = 1.08, pie_nudge_x = 0, pie_nudge_y = 0,
    alpha = 0.5, node_size_range = c(6, 15), color_low = "#D55E00",
    color_mid = "#F0E442", color_high = "#009E73", show_state_legend = TRUE,
    show_posterior_legend = TRUE, show_tree_scale = TRUE, state_labels = NULL,
    state_colors = NULL, title = "", fig_height = 7, fig_width = 7,
    ...)
{
    if ((summary_statistic %in% c("MAP", "mean", "MAPChromosome",
        "MAPRange", "PieRange", "PieState")) == FALSE) {
        print("Invalid summary statistic.")
        return()
    }
    t = read.beast(tree_file)
    attributes(t)$data <- attributes(t)$stats # needed to make other functions work
    t = RevGadgets:::assign_state_labels(t, state_labels, include_start_states)
    t = RevGadgets:::set_pp_factor_range(t, include_start_states)
    # use_state_colors = !is.null(state_colors)
    use_state_colors = F
    if (!is.null(state_colors) && !is.null(state_labels)) {
        names(state_colors) = unlist(state_labels)
    }
    tree = attributes(t)$phylo
    n_node = ggtree:::getNodeNum(tree)
    attributes(t)$phylo$tip.label = gsub("_", " ", attributes(t)$phylo$tip.label)
    if (tip_label_italics) {
        attributes(t)$phylo$tip.label = paste("italic('", attributes(t)$phylo$tip.label,
            "')", sep = "")
    }
    trPrettyPrintTemp <- t
    save(trPrettyPrintTemp, file='trPrettyPrintTemp.Rdata')
    p = ggtree(t, layout = tree_layout, ladderize = TRUE)
    p = p + geom_tiplab(size = tip_label_size, offset = tip_label_offset,
        parse = tip_label_italics)
    if (summary_statistic == "MAPChromosome") {
        if (include_start_states) {
            if (!("start_state_1" %in% colnames(attributes(t)$data))) {
                print("Start states not found in input tree.")
                return()
            }
            attributes(t)$data$start_state_1[n_node] = NA
            x = RevGadgets:::getXcoord(tree)
            y = RevGadgets:::getYcoord(tree)
            x_anc = numeric(n_node)
            node_index = numeric(n_node)
            for (i in 1:n_node) {
                if (RevGadgets:::getParent(tree, i) != 0) {
                  x_anc[i] = x[RevGadgets:::getParent(tree, i)]
                  node_index[i] = i
                }
            }
            shoulder_data = data.frame(node = node_index, x_anc = x_anc,
                y = y)
            p = p %<+% shoulder_data
            p = p + geom_text(aes(label = start_state_1, x = x_anc,
                y = y), hjust = "right", nudge_x = shoulder_label_nudge_x,
                size = shoulder_label_size, na.rm = TRUE)
            p = p + geom_text(aes(label = end_state_1), hjust = "left",
                nudge_x = node_label_nudge_x, size = node_label_size)
            p = p + geom_nodepoint(aes(colour = as.numeric(end_state_1_pp),
                size = as.numeric(end_state_1)), alpha = alpha)
        }
        else {
            p = p + geom_text(aes(label = anc_state_1), hjust = "left",
                nudge_x = node_label_nudge_x, size = node_label_size)
            p = p + geom_nodepoint(aes(colour = as.numeric(anc_state_1_pp),
                size = as.numeric(anc_state_1)), alpha = alpha)
        }
        min_low = 0
        max_up = 1
        p = p + scale_colour_gradient2(low = color_low, mid = color_mid,
            high = color_high, limits = c(min_low, max_up), midpoint = 0.5)
        if (show_state_legend) {
            p = p + guides(size = guide_legend("Chromosome Number"))
        }
        else {
            p = p + guides(size = FALSE)
        }
        if (show_posterior_legend) {
            p = p + guides(colour = guide_legend("Posterior Probability",
                override.aes = list(size = 8)))
        }
        else {
            p = p + guides(colour = FALSE)
        }
    }
    else if (summary_statistic == "MAPRange") {
        if (!include_start_states) {
            warning("Ignoring that include_start_states is set to FALSE")
        }
        if (!("start_state_1" %in% colnames(attributes(t)$data))) {
            print("Start states not found in input tree.")
            return()
        }
        attributes(t)$data$start_state_1[n_node] = NA
        x = RevGadgets:::getXcoord(tree)
        y = RevGadgets:::getYcoord(tree)
        x_anc = numeric(n_node)
        node_index = numeric(n_node)
        for (i in 1:n_node) {
            if (RevGadgets:::getParent(tree, i) != 0) {
                x_anc[i] = x[RevGadgets:::getParent(tree, i)]
                node_index[i] = i
            }
        }
        shoulder_data = data.frame(node = node_index, x_anc = x_anc,
            y = y)
        p = p %<+% shoulder_data
        p = p + geom_text(aes(label = start_state_1, x = x_anc,
            y = y), hjust = "right", nudge_x = shoulder_label_nudge_x,
            size = shoulder_label_size, na.rm = TRUE)
        p = p + geom_nodepoint(aes(colour = factor(start_state_1),
            x = x_anc, y = y, size = as.numeric(end_state_1_pp)),
            na.rm = TRUE, alpha = alpha)
        p = p + geom_tippoint(aes(colour = factor(start_state_1),
            x = x_anc, y = y, size = as.numeric(end_state_1_pp)),
            na.rm = TRUE, alpha = alpha)
        p = p + geom_tippoint(aes(colour = factor(end_state_1)),
            size = tip_node_size, alpha = alpha, shape = tip_node_shape, offset = tip_point_offset)
        p = p + geom_nodepoint(aes(colour = factor(end_state_1),
            size = as.numeric(end_state_1_pp)), alpha = alpha)
        if (show_state_legend) {
            p = p + guides(colour = guide_legend("Range", override.aes = list(size = 8),
                order = 1))
        }
        else {
            p = p + guides(colour = FALSE)
        }
        if (show_posterior_legend) {
            p = p + guides(size = guide_legend("Posterior probability",
                order = 2))
        }
        else {
            p = p + guides(size = FALSE)
        }
    }
    else if (summary_statistic == "MAP") {
        if (include_start_states) {
            print("Start states not yet implemented for MAP ancestral states.")
            return()
        }
        if (!("anc_state_1" %in% colnames(attributes(t)$data))) {
            anc_data = data.frame(node = names(attributes(t)$data$end_state_1),
                anc_state_1 = levels(attributes(t)$data$end_state_1)[attributes(t)$data$end_state_1],
                anc_state_1_pp = as.numeric(levels(attributes(t)$data$end_state_1_pp))[attributes(t)$data$end_state_1_pp])
            p = p %<+% anc_data
        }
        p = p + geom_text(aes(label = anc_state_1), hjust = "left",
            nudge_x = node_label_nudge_x, size = node_label_size)
        p = p + geom_nodepoint(aes(colour = factor(anc_state_1),
            size = as.numeric(anc_state_1_pp)), alpha = alpha)
        pp = as.numeric(as.vector(attributes(t)$data$anc_state_1_pp))
        if (!F) {
            pp_offset_range = 2 * (c(min(pp), max(pp)) - 0.5)
            nd_offset_interval = node_size_range[2] - node_size_range[1]
            nd_offset = node_size_range[1]
            node_size_range = pp_offset_range * nd_offset_interval +
                nd_offset
        }
        if (node_label_size == 0) {
            p = p + geom_text(aes(label = sprintf("%.02f", as.numeric(anc_state_1_pp))),
                hjust = "left", nudge_x = node_label_nudge_x,
                size = node_pp_label_size)
        }
        p = p + geom_tippoint(aes(colour = factor(anc_state_1)),
            size = tip_node_size, alpha = alpha, shape = tip_node_shape, offset = tip_point_offset)
        if (show_state_legend) {
            p = p + guides(colour = guide_legend("State"), order = 1)
        }
        else {
            p = p + guides(colour = FALSE, order = 2)
        }
        if (show_posterior_legend) {
            p = p + guides(size = guide_legend("Posterior Probability"),
                order = 3)
        }
        else {
            p = p + guides(size = FALSE, order = 4)
        }
    }
    else if (summary_statistic == "mean") {
        if (include_start_states) {
            print("Start states not implemented for mean ancestral states.")
            return()
        }
        p = p + geom_text(aes(label = round(mean, 2)), hjust = "left",
            nudge_x = node_label_nudge_x, size = node_label_size)
        lowers = as.numeric(levels(attributes(t)$data$lower_0.95_CI))[attributes(t)$data$lower_0.95_CI]
        uppers = as.numeric(levels(attributes(t)$data$upper_0.95_CI))[attributes(t)$data$upper_0.95_CI]
        diffs = uppers - lowers
        diffs_df = data.frame(node = names(attributes(t)$data$lower_0.95_CI),
            diff_vals = diffs)
        p = p %<+% diffs_df
        min_low = min(diffs, na.rm = TRUE)
        max_up = max(diffs, na.rm = TRUE)
        mid_val = min_low + (max_up - min_low)/2
        p = p + scale_colour_gradient2(low = color_low, mid = color_mid,
            high = color_high, limits = c(min_low, max_up), midpoint = mid_val)
        p = p + geom_nodepoint(aes(size = mean, colour = diff_vals),
            alpha = alpha)
        p = p + geom_tippoint(aes(size = mean), color = "grey",
            alpha = alpha)
        if (show_state_legend) {
            legend_text = "Mean State"
            p = p + guides(size = guide_legend(legend_text))
        }
        else {
            p = p + guides(size = FALSE)
        }
        if (show_posterior_legend) {
            p = p + guides(colour = guide_legend("95% CI Width",
                override.aes = list(size = 4)))
        }
        else {
            p = p + guides(colour = FALSE)
        }
    }
    else if (summary_statistic == "PieState") {
        if (include_start_states) {
            print("Start states not yet implemented for PieState ancestral states.")
            return()
        }
        if (!("anc_state_1" %in% colnames(attributes(t)$data))) {
            anc_data = data.frame(node = names(attributes(t)$data$end_state_1),
                anc_state_1 = levels(attributes(t)$data$end_state_1)[attributes(t)$data$end_state_1],
                anc_state_1_pp = as.numeric(levels(attributes(t)$data$end_state_1_pp))[attributes(t)$data$end_state_1_pp])
        }
        p = p + geom_tippoint(aes(colour = factor(anc_state_1)),
            size = 0.01)
        p = p + geom_nodepoint(aes(colour = factor(anc_state_1),
            size = 0), na.rm = TRUE, alpha = 0)
        p = p + geom_nodepoint(aes(colour = factor(anc_state_2),
            size = 0), na.rm = TRUE, alpha = 0)
        p = p + geom_nodepoint(aes(colour = factor(anc_state_3),
            size = 0), na.rm = TRUE, alpha = 0)
        if (show_state_legend) {
            p = p + guides(colour = guide_legend("State", override.aes = list(size = 5)),
                order = 1)
        }
        else {
            p = p + guides(colour = FALSE, order = 2)
        }
        p = p + guides(size = FALSE)
        if (use_state_colors) {
            p = p + scale_color_manual(values = state_colors,
                breaks = unlist(state_labels))
        }
        # p = p + theme(legend.position = "left")
        dat_state_anc = build_state_probs(t, state_labels, include_start_states)$anc
        n_tips = length(tree$tip.label)
        n_nodes = 2 * n_tips - 1
        node_idx = (n_tips + 1):n_nodes
        tip_idx = 1:n_tips
        all_idx = 1:n_nodes
        pies_anc = nodepie(dat_state_anc, cols = 1:(ncol(dat_state_anc) -
            1), color = state_colors, alpha = alpha)
        pd = c(rep(tip_pie_diameter, n_tips), rep(node_pie_diameter,
            n_nodes - n_tips))
        p_node = RevGadgets:::inset.revgadgets(tree_view = p, insets = pies_anc[all_idx],
            x = "node", height = pd, width = pd, hjust = pie_nudge_x,
            vjust = pie_nudge_y)
            message('state colors:')
            print(state_colors)
            message('state_labels')
            print(unlist(state_labels))
        return(p_node)
    }
    else if (summary_statistic == "PieRange") {
        if (!("start_state_1" %in% colnames(attributes(t)$data))) {
            print("Start states not found in input tree.")
            return()
        }
        p = p + geom_tippoint(aes(colour = factor(end_state_1)),
            size = 0.01, alpha = alpha)
        p = p + geom_nodepoint(aes(colour = factor(start_state_1),
            size = 0), na.rm = TRUE, alpha = 0)
        p = p + geom_nodepoint(aes(colour = factor(start_state_2),
            size = 0), na.rm = TRUE, alpha = 0)
        p = p + geom_nodepoint(aes(colour = factor(start_state_3),
            size = 0), na.rm = TRUE, alpha = 0)
        if (show_state_legend) {
            p = p + guides(colour = guide_legend("Geographic distribution"), order = 1)
        }
        else {
            p = p + guides(colour = FALSE, order = 2)
        }
        p = p + guides(size = FALSE)
        #p = p + guides(colour = guide_legend(override.aes = list(size = 5)))
        if (use_state_colors) {
            warning('using state colors...')
            used_states = RevGadgets:::collect_probable_states(p)
            p = p + scale_color_manual(values = state_colors,
                breaks = unlist(state_labels), name = "Geographic distribution", limits = used_states)
        }
        p = p + theme(legend.position = "left")
        dat_state_end = RevGadgets:::build_state_probs(t, state_labels, include_start_states)$end
        dat_state_start = RevGadgets:::build_state_probs(t, state_labels,
            include_start_states)$start
        n_tips = length(tree$tip.label)
        n_nodes = 2 * n_tips - 1
        node_idx = (n_tips + 1):n_nodes
        tip_idx = 1:n_tips
        all_idx = 1:n_nodes
        pies_end = nodepie(dat_state_end, cols = 1:(ncol(dat_state_end) -
            1), color = state_colors, alpha = alpha)
        # pies_start = nodepie(dat_state_start, cols = 1:(ncol(dat_state_start) -
        #     1), color = state_colors, alpha = alpha)
        pd = c(rep(tip_pie_diameter, n_tips), rep(node_pie_diameter,
            n_nodes - n_tips))
        message('line 317')
        message('state colors:')
        print(state_colors)
        message('state_labels')
        print(unlist(state_labels))
        p_node = RevGadgets:::inset.revgadgets(tree_view = p, insets = pies_end[all_idx],
            x = "node", height = pd, width = pd, hjust = pie_nudge_x,
            vjust = pie_nudge_y)
        # p_shld = RevGadgets:::inset.revgadgets(tree_view = p_node, insets = pies_start,
        #     x = "parent_shoulder", height = node_pie_diameter *
        #         0.9, width = node_pie_diameter * 0.9, hjust = pie_nudge_x,
        #     vjust = pie_nudge_y)
        # p_all = p_shld + coord_cartesian(xlim = xlim_visible,
        #     ylim = ylim_visible, expand = TRUE)
        p_all = p_node + coord_cartesian(xlim = xlim_visible,
             ylim = ylim_visible, expand = TRUE)
        write.csv(dat_state_start, 'date_state_start.csv')
        write.csv(dat_state_end, 'dat_state_end.csv')
        # return(p_shld)
        message('state colors:')
        print(state_colors)
        message('state_labels')
        print(unlist(state_labels))
        return(p_all)
    }
    if (use_state_colors) {
      warning('using state colors...')
        p = p + scale_color_manual(values = state_colors, breaks = unlist(state_labels))
    }
    p = p + scale_radius(range = node_size_range)
    # p = p + theme(legend.position = "left")
    p = p + ggtitle(title)
    # p = p + coord_cartesian(xlim = xlim_visible, ylim = ylim_visible,
    #     expand = TRUE)
    write.csv(anc_data, 'anc_data.csv')
    write.csv(shoulder_data, 'shoulder_data.csv')
    message('state colors:')
    print(state_colors)
    message('state_labels')
    print(unlist(state_labels))
    return(p)
}
