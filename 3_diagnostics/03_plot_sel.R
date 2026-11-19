plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
MODEL_NAME <- '4_update_L50'

figure_name = "3_sel_"
out <- plot_model

##########################################
### plot selectivity
##########################################

# basic
# out <- SS_output(dir= paste0(PATH_SS3,'base/'),covar=FALSE,ncols=500,forecast=FALSE)
dat <- out$sizeselex
dat <- dat[dat$Yr == 2025,]
dat <- dat[dat$Factor == "Lsel",]
dat <- dat[dat$Sex == 1,]
len <- as.numeric(colnames(dat)[-c(1:5)])
fleet <- sort(unique(dat$Fleet))
labs <- out$FleetNames[fleet]
tmp <- out$biology

savepng(paste0('sel',MODEL_NAME,'.png',sep=""),width =25,height=35)
par(mfrow=c(4,2), mar=c(4,4,4,4), omi=c(0.5,0.5,0,0))
for(i in c(1:7)){
  plot(len, dat[dat$Fleet==fleet[i],-c(1:5)], pch=3, col=2, type="n", xlab="", ylab="", xlim=c(20,120), ylim=c(0,1))
  lines(len, dat[dat$Fleet==fleet[i],-c(1:5)], col="slate grey", lwd=2)
  lines(tmp$Len_mean,tmp$Mat ,lwd=3,col='purple',lty=2)
  mtext(side=3, line=0.5, paste0(labs[fleet[i]]), cex=2)
  if(i==1) plblank(axes=F)
}
mtext(side=2, outer=T, line=0, "Proportion", cex = 1.5)
mtext(side=1, outer=T, line=0, "Length (cm)", cex = 1.5)
dev.off()

