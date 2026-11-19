plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
MODEL_NAME <- '4_update_L50'

figure_name = "8_biomass_"


plotSSB <- function(paths,
                    models,
                    col = NULL,
                    lwd = rep(3, length(models)),
                    lty = rep(1, length(models)),
                    bty = 'n',
                    cex = 0.6,
                    lgd = TRUE,
                    depletion = FALSE,
                    space = FALSE,
                    tstep = 1950:2025) {
  
  # Expand path vector if needed
  if (length(paths) == 1) {
    paths <- rep(paths, length(models))
  } 
  
  # Auto-generate enough distinct colours if not supplied
  if (is.null(col)) {
    if (length(models) <= 12) {
      col <- brewer.pal(length(models), "Paired")
    } else {
      col <- colorRampPalette(brewer.pal(12, "Paired"))(length(models))
    }
  }
  
  SSB <- list()
  YR  <- list()   # years actually matched, parallel to SSB[[i]] by construction
  
  for (i in seq_along(models)) {
    der <- extract.derived_quantities(path = paste0(paths[i], models[i]))
    
    # Adjust tstep per model
    model_tstep <- if (models[i] == "0_base_2023") 1950:2021 else if (models[i] == "s8_mod_time") 1983:2025 else tstep
    
    labs <- paste0('SSB_', model_tstep)
    sub  <- der[der$Label %in% labs, c("Label", "Value")]
    
    # Derive year straight from the matched label -> guarantees same length/order as Value
    sub$Year <- as.numeric(sub("SSB_", "", sub$Label))
    sub <- sub[order(sub$Year), ]
    
    if (nrow(sub) != length(model_tstep)) {
      warning(sprintf(
        "Model %s: expected %d years, matched %d in derived quantities (missing: %s).",
        models[i], length(model_tstep), nrow(sub),
        paste(setdiff(model_tstep, sub$Year), collapse = ", ")
      ))
    }
    
    if (!depletion) {
      SSB[[i]] <- sub$Value / 1000
    } else {
      virgin <- der[der$Label == "SSB_Virgin", "Value"]
      SSB[[i]] <- sub$Value / virgin * 100
    }
    YR[[i]] <- sub$Year
  }
  
  # Y labels and limits
  if (!depletion) {
    ylab <- "Spawning biomass (1000s t)"
    ylim <- c(0, max(unlist(SSB), na.rm = TRUE))
  } else {
    ylab <- "Depletion (%)"
    ylim <- c(0, 100)
  }
  
  # X limits: span the full range actually present across all models
  xlim <- range(unlist(YR), na.rm = TRUE)
  
  # Plot setup
  if (!space) {
    old_par <- par(no.readonly = TRUE)
    on.exit(par(old_par))
    par(mar = c(5, 4, 4, 15), xpd = TRUE)
    plot(NA, xlim = xlim, ylim = ylim, ylab = ylab, xlab = "Year", type = "n")
  }
  
  # Plot lines for each model — yr and ssb_vals are guaranteed equal length now
  for (i in seq_along(models)) {
    lines(YR[[i]], SSB[[i]], col = col[i], lty = lty[i], lwd = lwd[i])
  }
  
  if (lgd) {
    legend(x = 2028, y = 110, inset = .02, #2028,3100 "topright", x = 2028, y = 3500,
           col = col, lty = lty, lwd = lwd,
           legend = models, cex = cex, bty = bty)
  }
  
  # Long-format output instead of rbind, since models can now have different lengths
  out <- do.call(rbind, lapply(seq_along(models), function(i) {
    data.frame(Model = models[i], Year = YR[[i]], Value = SSB[[i]])
  }))
  
  return(out)
}


paths <- paths_for_models
models <- models
savepng('Updates.png', width = 25,height=17.78)
plotSSB(paths = PATH_MODELRUNS, models = mod_update_names)
dev.off()

savepng('Updates_STATUS.png', width = 25,height=17.78)
plotSSB(paths = PATH_MODELRUNS, models = mod_update_names, depletion = TRUE)
dev.off()



savepng('Model Sensitivites.png', width = 25,height=17.78)
plotSSB(paths = PATH_SENSITIVITES, models = mod_sens_names)
dev.off()

savepng('Model Sensitivites STATUS.png', width = 25,height=17.78)
plotSSB(paths = PATH_SENSITIVITES, models = mod_sens_names, depletion = TRUE)
dev.off()


savepng('Model Grid.png', width = 25,height=17.78)
plotSSB(paths = PATH_GRID, models = mod_grid_names)
dev.off()

savepng('Model Grid STATUS.png', width = 25,height=17.78)
plotSSB(paths = PATH_GRID, models = mod_grid_names, depletion = TRUE)
dev.off()

savepng('Model All.png', width = 25,height=17.78)
plotSSB(paths = paths_for_models, models = models)
dev.off()

