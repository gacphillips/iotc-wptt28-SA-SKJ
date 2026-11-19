plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
MODEL_NAME <- '4_update_L50'

figure_name = "2_LF_"
out <- plot_model

#################
# Obs vs. pred Mean length 
#################

## basic
# out <- SS_output(paste0(PATH_MODELRUNS,'0_base_2022')) 
dat <- out$lendbase
#dat[dat %in% c(12,13,14),"Fleet"]=3
labs <- out$FleetNames
dat$obsX <- dat$Bin * dat$Obs
dat$expX <- dat$Bin * dat$Exp
obs <- aggregate.data.frame(dat[,c(17,33)], list(dat$Fleet, dat$Yr), sum)
obs$avg <- obs[,4]/obs[,3]
names(obs) <- c("fleet", "yr", "x","y", "avg")
obs$fleet <- as.numeric(as.character(obs$fleet))
obs$yrqtr <- as.numeric(as.character(obs$yr))

Pred <- aggregate.data.frame(dat[,c(18,34)], list(dat$Fleet, dat$Yr), sum)
Pred$avg <- Pred[,4]/Pred[,3]
names(Pred) <- c("fleet", "yr", "x","y", "avg")
Pred$fleet <- as.numeric(as.character(Pred$fleet))
Pred$yr <- as.numeric(as.character(Pred$yr))
Pred$fleet <- as.numeric(as.character(Pred$fleet))
Pred$yrqtr <- as.numeric(as.character(Pred$yr))
fleet <- sort(unique(obs$fleet))

savepng(paste0('Mean ', MODEL_NAME, '.png',sep=""),width =25,height=35)
par(mfrow=c(4,2), mar=c(3,3,2,1), omi=c(0,0.2,0,0))
for(i in 1:7){
  obs2 <- obs[obs$fleet == fleet[i],]
  Pred2 <- Pred[Pred$fleet == fleet[i],]
  plot(obs2$yrqtr, obs2$avg, pch=16, col="slate grey", type="p", xlab="", ylab="", xlim=c(min(obs$yrqtr),max(obs$yrqtr)), ylim=c(min(c(obs2$avg,Pred2$avg)), max(c(obs2$avg,Pred2$avg))),cex=1.1)
  points(Pred2$yrqtr, Pred2$avg,col="red",pch=3,cex=1.1)
  mtext(side=3, line=0.5, paste(fleet[i],labs[fleet[i]],sep=". "))
}
mtext(side=2, outer=T, line=0, "Average length (cm)")
mtext(side=1, outer=T, line=-20, "Year")
dev.off()


#################
# Obs vs. pred Aggregated length 
#################


## basic

# out <- SS_output(dir= paste0(PATH_SS3,'/base'),covar=TRUE,ncols=500,forecast=FALSE)
fleet <- sort(unique(out$lendbase$Fleet))
Seas <- sort(unique(out$lendbase$Seas))
LBin <- sort(unique(out$lendbase$Bin))
LBin2 <- c(20,50,80)
x <- match(LBin2, LBin)
labs <- out$FleetNames
savepng(paste0('Aggregate ', MODEL_NAME, '.png',sep=""),width =25,height=35)
par(mfrow=c(7,4), mar=c(3,3,2,0), omi=c(0.2,0.2,0,0))
for (i in 1:length(fleet)) {
  dat <- subset(out$lendbase,Fleet==fleet[i])
  obs <- tapply(dat$Obs, list(dat$Bin,dat$Seas), sum)
  obs <- ifelse(is.na(obs) == TRUE, 0, obs)
  obs <- t(t(obs)/apply(obs,2,sum))
  Pred <- tapply(dat$Exp, list(dat$Bin,dat$Seas), sum)
  Pred <- ifelse(is.na(Pred) == TRUE, 0, Pred)
  Pred <- t(t(Pred)/apply(Pred,2,sum))
  LBin <- sort(unique(dat$Bin))
  LBin2 <- c(20,50,80)
  x <- match(LBin2, LBin)
  for(j in 1:length(Seas)){
    a <- barplot(obs[,j], col="slate grey", xlab="", ylab="", ylim=range(0, obs[,j], Pred[,j]), border=NA, main ="", xaxt="n")
    lines(a, Pred[,j], col="red", lwd=2)
    axis(1, at=a[x], labels=LBin2)
    mtext(side=3, line=0.5, paste(labs[fleet[i]],Seas[j],sep=". "), cex=1.0)
  }	
}
mtext(side=1, outer=T, line=0, "Fork length (cm)")

dev.off()

#################
# Obs vs. pred length for fleets
#################

fleet <- sort(unique(out$lendbase$Fleet))
fleetNames = out$FleetNames[fleet]
for (i in 1:length(fleet)) {
  dat <- subset(out$lendbase,Fleet==fleet[i])
  obs <- tapply(dat$Obs, list(dat$Bin,dat$Yr), sum)
  obs <- ifelse(is.na(obs) == TRUE, 0, obs)
  obs <- t(t(obs)/apply(obs,2,sum))
  Pred <- tapply(dat$Exp, list(dat$Bin,dat$Yr), sum)
  Pred <- ifelse(is.na(Pred) == TRUE, 0, Pred)
  Pred <- t(t(Pred)/apply(Pred,2,sum))
  Yr <- sort(unique(dat$Yr))
  LBin <- sort(unique(dat$Bin))
  LBin2 <- c(20,50,80)
  x <- match(LBin2, LBin)
  
  savepng(paste0(fleetNames[fleet[i]],'.png',sep=""),width=21, height=29.7)
  par(mfrow=c(8,5),mar=c(0,0,0,0), oma=c(3,3,2,0))
  for(j in 1:length(Yr)){
    #a <- barplot(obs[,j], col="slate grey", xlab="", ylab="", ylim=range(0, obs[,j], Pred[,j]), border=NA, main ="", xaxt="n")
    plot(LBin,obs[,j],col='blue', type='l', lwd=2,pch=16, xlab="", ylab="",ylim=range(0, obs[,j], Pred[,j]),xaxt="n",yaxt='n',cex=1.1)
    #x=barplot(obs[,j],col='slate grey', border=NA,xlab="", ylab="",ylim=range(0, obs[,j], Pred[,j]),xaxt="n",yaxt='n')
    lines(LBin, Pred[,j], col="red", lwd=2)
    mtext(side=3, adj=0,line=-1.5 ,Yr[j], cex=0.8)
    if(j>length(Yr)-5) axis(1,at = LBin2,labels=LBin2)   #axis(1, at=LBin2, labels=LBin2)
  }
  mtext(side=3, outer=T, line=0.5,fleetNames[i],cex=1.2)
  if(i==1){
    mtext(side=2, outer=T, line=1, "Proportion",adj=0.775)
    mtext(side=1, outer=T, line=-30, "Fork length (cm)")
  } else if(i==4) {
    mtext(side=2, outer=T, line=1, "Proportion",adj=0.55)
    mtext(side=1, outer=T, line=-5, "Fork length (cm)")
  } else {
    mtext(side=2, outer=T, line=1, "Proportion")
    mtext(side=1, outer=T, line=0.5,"Fork length (cm)")
  }
  dev.off()
}


