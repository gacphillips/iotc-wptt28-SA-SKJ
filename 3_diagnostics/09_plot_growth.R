plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
MODEL_NAME <- '4_update_L50'

figure_name = "9_growth_"

############
### basic
#############

plot_growth_models <- function(growth_mods,
                               morph = 1,
                               col_fill = NULL,
                               col_line = NULL,
                               alpha_fill = 0.3,
                               ylim = c(0, 100),
                               xlim = c(0, 8),
                               ylab = "Length (cm)",
                               xlab = "Age (year)",
                               add = FALSE) {
  
  n_models <- length(growth_mods)
  
  # Line colours - colourblind-safe, no orange/green
  if (is.null(col_line)) {
    cb_safe <- c("#0072B2", "#CC79A7", "#56B4E9", "#D55E00", "yellow" ) # blue, pink, sky blue, black
    # trimmed to blue/pink/sky-blue/black - drop D55E00 (vermillion/orange-red) if too close to orange
    cb_safe <- c("#0072B2", "#CC79A7", "#56B4E9", "#D55E00")
    
    if (n_models <= length(cb_safe)) {
      col_line <- cb_safe[seq_len(n_models)]
    } else {
      col_line <- colorRampPalette(cb_safe)(n_models)
    }
  }
  
  # Fill colours - same hue as line, lighter
  if (is.null(col_fill)) {
    col_fill <- colorspace::lighten(col_line, amount = 0.6)
    col_fill <- adjustcolor(col_fill, alpha.f = alpha_fill)
  }
  
  # lty per sex/morph (solid, dashed, dotted, ... as needed)
  lty_morph <- setNames(seq_along(morph), morph)
  
  if (!add) {
    plot(0, 0, type = "n", xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab)
  }
  
  for (i in seq_along(growth_mods)) {
    out <- SS_output(dir = growth_mods[i], covar = TRUE, ncols = 500, forecast = FALSE)
    
    for (mo in morph) {
      dat <- out$endgrowth
      dat <- dat[dat$Morph == mo, c('Seas','Morph','Settlement','Age_Mid','Len_Mid','SD_Mid')]
      dat$Len_lower <- dat$Len_Mid - 1.96 * dat$SD_Mid
      dat$Len_upper <- dat$Len_Mid + 1.96 * dat$SD_Mid
      dat <- dat[order(dat$Age_Mid), ]
      
      polygon(c(dat$Age_Mid, rev(dat$Age_Mid)),
              c(dat$Len_lower, rev(dat$Len_upper)),
              col = col_fill[i], border = NA)
      
      lines(dat$Age_Mid, dat$Len_Mid, col = col_line[i],
            lwd = 2, lty = lty_morph[as.character(mo)])
    }
  }
  
  # Legend: model colours
  if (!is.null(names(growth_mods))) {
    legend("topright", legend = names(growth_mods), col = col_line, lwd = 2, cex=0.6,
           fill = col_fill, bty = "n")
  }
  
  # Second legend: sex/morph line types (only if plotting more than one)
  if (length(morph) > 1) {
    sex_labels <- ifelse(morph == 1, "Female", ifelse(morph == 2, "Male", paste("Morph", morph)))
    legend("bottomright", legend = sex_labels, lty = seq_along(morph), lwd = 2,
           col = "black", bty = "n")
  }
}

savepng(paste0('models.png',sep=""), width = 25,height=17.78)
par(mar = c(3,4,2,1))
plot_growth_models(growth_mods = growth_models)
dev.off()

savepng(paste0('base_model.png',sep=""), width = 25,height=17.78)
par(mar = c(3,4,2,1))
plot_growth_models(growth_mods = base_dir)
dev.off()


