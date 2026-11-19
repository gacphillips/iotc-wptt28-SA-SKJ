### Plot CPUE fits for a single model ###

######################################
# cpue fit
######################################

figure_name = "1_cpue_"
out <- CPUE_models #plot_model
out <- plot_model

# fleet indices to plot, per model
fleet_index_map <- list(
  "4_update_L50"    = 8:9,
  "s1a_MDV_cpue"     = 8,
  "s1b_PSLS_cpue"    = 9,
  "s1c_BAI_cpue"    = 10,
  "s1d_ABBI_cpue"   = 11,
  "s1e_all_cpue"     = 8:11,
  "s9_catchability" = 8:9,
  "s1f_PL_ABBI_cpue" = c(8,11),
  "s1g_PSLS_BAI_cpue" = c(9:10),
  "s1h_PL_q1_cpue" = 8,
  "s1i_PSLS_q1_cpue" = 9
)

for (MODEL_NAME in names(CPUE_models)) {
  
  model_path <- CPUE_models[[MODEL_NAME]]
  out <- SS_output(dir = model_path, verbose = FALSE, printstats = FALSE)
  
  dat <- out$cpue
  fleet <- fleet_index_map[[MODEL_NAME]]
  fleetNames <- out$FleetNames[fleet]
  
  n_fleet <- length(fleet)
  mfrow_dims <- if (n_fleet == 1) c(1, 1) else if (n_fleet == 2) c(2, 1) else c(2, 2)
  
  # ---- basic fit plot ----
  savepng(paste0('fit - ', MODEL_NAME, '.png'), height = 20, width = 25)
  par(mfrow = mfrow_dims, mar = c(3, 4, 2, 1))
  for (i in seq_along(fleet)) {
    dat3 <- dat[dat$Fleet == fleet[i], ]
    dat3$Yr.frac <- dat3$Yr + (dat3$Seas - 1) / 4 + 1 / 8
    plot(dat3$Yr.frac, dat3$Obs, type = "p", lwd = 2, col = "slategrey",
         ylab = "Index", xlab = "Year",
         xlim = range(dat3$Yr.frac),
         ylim = c(0, max(c(dat3$Obs, dat3$Exp)) * 1.10))
    segments(dat3$Yr.frac, exp(log(dat3$Obs) + 1.96 * dat3$SE),
             dat3$Yr.frac, exp(log(dat3$Obs) - 1.96 * dat3$SE),
             col = "slate grey")
    lines(dat3$Yr.frac, dat3$Exp, lwd = 2, col = "red")
    mtext(paste0('(', letters[i], ') ', fleetNames[i]), line = 0.1, cex = 1.2)
    legend('topright', max(c(dat3$Obs, dat3$Exp)) * 1.10,
           legend = c("Observed", "Predicted"), lwd = 2,
           col = c("slate grey", "red"), bty = 'n', cex = 1.2)

  }
  dev.off()
}
  
for (MODEL_NAME in names(CPUE_models)) {
  # ---- residuals plot ----
  savepng(paste0('Residuals - ', MODEL_NAME, '.png'), width = 30, height = 25)
  par(mfrow = mfrow_dims, mar = c(3, 4, 2, 1))
  for (i in seq_along(fleet)) {
    dat3 <- dat[dat$Fleet == fleet[i], ]
    dat3$Yr.frac <- dat3$Yr + (dat3$Seas - 1) / 4 + 1 / 8
    plot(dat3$Yr.frac, dat3$Dev / sd(dat3$Dev), type = "p", lwd = 2,
         col = "slate grey", ylab = "Standardised Residuals", xlab = "Year",
         xlim = range(dat3$Yr.frac), ylim = c(-2.5, 2.5))
    lines(range(dat3$Yr.frac), rep(0, 2), lwd = 1, col = 1, lty = 3)
    lines(range(dat3$Yr.frac), rep(2, 2), lwd = 1, col = 1, lty = 3)
    lines(range(dat3$Yr.frac), rep(-2, 2), lwd = 1, col = 1, lty = 3)
    lines(lowess(dat3$Yr.frac, dat3$Dev, f = 0.2), lwd = 2)
    abline(h = c(-2, 0, 2), lty = 2, col = 'blue')
    mtext(paste0('(', letters[i], ') ', fleetNames[i]), line = 0.1, cex = 1.2)
  }
  dev.off()
  
}
# basic
dat <- out$cpue
fleet <- sort(unique(dat$Fleet))[c(1,2)]
fleetNames = out$FleetNames[c(8:9)]#[c(8:11)]
savepng(paste0('fit - ', MODEL_NAME,'.png',sep=""), height =20, width = 25)
par(mfrow=c(2,1), mar=c(3,4,2,1))
for (i in seq_along(fleet)) {
  dat3 <- dat[dat$Fleet == fleet[i],]
  dat3$Yr.frac = dat3$Yr + (dat3$Seas-1)/4+1/8
  plot(dat3$Yr.frac, dat3$Obs, type="p", lwd=2, col="slate grey", ylab="Index", xlab="Year",xlim=range(dat3$Yr.frac), ylim=c(0,max(c(dat3$Obs,dat3$Exp))*1.10))
  segments(dat3$Yr.frac,exp(log(dat3$Obs)+1.96*dat3$SE),dat3$Yr.frac,exp(log(dat3$Obs)-1.96*dat3$SE), col="slate grey")
  lines(dat3$Yr.frac, dat3$Exp, lwd=2, col="red")
  mtext(paste0('(',letters[i],') ',fleetNames[i]),line=0.1,cex=1.2)
  legend('topright',max(c(dat3$Obs,dat3$Exp))*1.10, legend=c("Observed", "Predicted"), lwd=2, col=c("slate grey","red"),bty='n',cex=1.2)
}
dev.off()


#######################################
# residuals
######################################

#out <- SS_output(dir= paste0(PATH_MODELRUNS,"0_base_2022",sep=""),covar=TRUE,ncols=500,forecast=FALSE)

savepng(paste0('Residuals - ', MODEL_NAME,'.png',sep=""), width=30, height=25)
par(mfrow=c(2,1), mar=c(3,4,2,1))
for(i in seq_along(fleet)){
  dat3 <- dat[dat$Fleet == fleet[i],]
  dat3$Yr.frac = dat3$Yr + (dat3$Seas-1)/4+1/8
  plot(dat3$Yr.frac, dat3$Dev/sd(dat3$Dev), type="p", lwd=2, col="slate grey", ylab="Standardised Residuals", xlab="Year", xlim=range(dat3$Yr.frac), ylim=c(-2.5,2.5))
  lines(range(dat3$Yr.frac), rep(0,2), lwd=1, col=1, lty=3)
  lines(range(dat3$Yr.frac), rep(2,2), lwd=1, col=1, lty=3)
  lines(range(dat3$Yr.frac), rep(-2,2), lwd=1, col=1, lty=3)
  lines(lowess(dat3$Yr.frac, dat3$Dev, f=0.2), lwd=2)
  abline(h=c(-2,0,2),lty=2,col='blue')
  mtext(paste0('(',letters[i+2],') ',fleetNames[i]),line=0.1,cex=1.2)
}
dev.off()

