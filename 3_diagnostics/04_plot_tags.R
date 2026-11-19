plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
MODEL_NAME <- '4_update_L50'

figure_name = "4_tag_"
out <- plot_model

############
### recovery by release group 
#############

# basic
# out <- SS_output(paste0(PATH_SS3,'base/')) #io_h80_MAt_t3_rttp_tm25
model <- MODEL_NAME
dat1 <- out$tagdbase1
dat2 <- out$tagdbase2
tagrel <- out$tagrelease
dat1$YrQtr = dat1$Yr + (dat1$Seas-1)/4+1/8
dat2$YrQtr = dat2$Yr + (dat2$Seas-1)/4+1/8
tagrel$program = ifelse(tagrel$TAG %in% c(1:49),'1','2')
tagrel$YrQtr = tagrel$Yr + (tagrel$Seas-1)/4+1/8
tagrel$index <- paste(tagrel$program, tagrel$Area, tagrel$YrQtr)
labs <- out$FleetNames
dat2$indexTAG <- tagrel$index[match(dat2$Rep, tagrel$TAG)]
dat1$indexTAG <- tagrel$index[match(dat1$Rep, tagrel$TAG)]

fleet= c(2,3)
for (k in 1:length(fleet)) {
  junk <- dat1[dat1$Fleet == fleet[k],] 
  junk2 <- aggregate.data.frame(junk$Obs, list(junk$YrQtr,junk$Rep), sum)
  junk3 <- aggregate.data.frame(junk$Exp, list(junk$YrQtr,junk$Rep), sum)
  obstag <- tapply(dat2$Obs * junk2[,3], list(dat2$indexTAG,dat2$YrQtr), sum)
  predtag <- tapply(dat2$Exp * junk3[,3], list(dat2$indexTAG,dat2$YrQtr), sum)
  tagmix <- out$tagfirstperiod/4
  RelYrQtr <- tapply(dat2$YrQtr, list(dat2$indexTAG), min)
  tgrp <- sort(unique(dat2$indexTAG))
  yrqtr <- sort(unique(dat2$YrQtr))
  
  for(p in 1) {
    for (a in 1) { 
      idrow = substr(tgrp,1,1)==p & substr(tgrp,3,3)==a
      tgrp2 = tgrp[idrow]
      obstag2 = obstag[idrow,]
      predtag2 = predtag[idrow,]	
      RelYrQtr2 = RelYrQtr[idrow]
      savepng(paste0('ByRelGrp ',labs[fleet[k]],c(' RTTP',' SS')[p],c(' Area1','Area2')[a],' ',model,'.png'),width=20,height=23)
      par(mfrow=c(5,3),mar=c(3,3,2,2),oma=c(2,2,2,0),cex.axis=1.2)
      for(i in 1:length(tgrp2)){
        idcol = yrqtr >= (RelYrQtr2[i]+tagmix)
        obstag2[i,!idcol] = 0
        predtag2[i,!idcol] = 0 			
        plot(yrqtr[idcol], obstag2[i,idcol], type ="n", xlim=range(yrqtr), ylim=range(0,obstag2[i,idcol],predtag2[i,idcol],na.rm=T), ylab="",xlab="",xaxt="n")
        points(yrqtr[idcol], predtag2[i,idcol], pch=16, col=2)
        points(yrqtr[idcol],  obstag2[i,idcol], pch=16, col=4)
        lines(yrqtr[idcol],obstag2[i,idcol],col=4,lty=3)
        yearqtr = as.numeric(substr(tgrp2[i],5,12))
        mtext(side=3,paste0(floor(yearqtr), ' Q',(yearqtr-floor(yearqtr) -1/8) * 4 +1), line=0.7,cex=1.2)
        axis(1, at=yrqtr, labels=yrqtr)
        if(i == 1) legend('topright', pch=16, col=c(4,2), lty=c(3,NA), legend=c("Observed","Predicted"))
      }
      predtag2 <- apply(predtag2,2,sum,na.rm=T)
      obstag2 <- apply(obstag2,2,sum,na.rm=T)
      predtag2 <- predtag2[-c(1:(tagmix*4))]
      obstag2 <- obstag2[-c(1:(tagmix*4))]
      yr <- as.numeric(names(obstag2))
      par(ylog=TRUE)
      plot(yr, obstag2, type ="n", xlim=range(yrqtr),  ylab="",xlab="",xaxt="n")
      points(yr, predtag2, pch=16, col=2)
      points(yr, obstag2, pch=16, col=4)
      lines(yr,obstag2,col=4,lty=3)
      axis(1, at=yrqtr, labels=yrqtr)	
      mtext(side=3, 'Total', line=0.7,cex=1.2)	
      box()	
      dev.off()
    }
  }
}



############
### recovery for all fleets: base case
#############
pred = rbind()
obs =rbind()
models = c("4_update_L50")

for (i in 1:length(models)) {
  out <- SS_output(paste0(PATH_MODELRUNS,'',models[i])) 
  dat1 <- out$tagdbase1
  dat2 <- out$tagdbase2
  tagrel <- out$tagrelease
  dat1$YrQtr = dat1$Yr + (dat1$Seas-1)/4+1/8
  dat2$YrQtr = dat2$Yr + (dat2$Seas-1)/4+1/8
  tagrel$YrQtr = tagrel$Yr + (tagrel$Seas-1)/4+1/8
  tagrel$index <- paste(tagrel$Area, tagrel$YrQtr)
  labs <- out$FleetNames
  dat2$indexTAG <- tagrel$index[match(dat2$Rep, tagrel$TAG)]
  dat1$indexTAG <- tagrel$index[match(dat1$Rep, tagrel$TAG)]
  obstag <- tapply(dat2$Obs, list(dat2$indexTAG,dat2$YrQtr), sum)
  predtag <- tapply(dat2$Exp, list(dat2$indexTAG,dat2$YrQtr), sum)
  tagmix <- out$tagfirstperiod/4
  RelYrQtr <- tapply(dat2$YrQtr, list(dat2$indexTAG), min)
  tgrp <- sort(unique(dat2$indexTAG))
  yrqtr <- sort(unique(dat2$YrQtr))
  for(t in 1:length(tgrp)){
    obstag[t,] <- ifelse(yrqtr >= (RelYrQtr[t]+tagmix), obstag[t,], 0)
    predtag[t,] <- ifelse(yrqtr >= (RelYrQtr[t]+tagmix), predtag[t,], 0)
  }
  pred <- rbind(pred,apply(predtag,2,sum,na.rm=T))
  obs <- rbind(obs,apply(obstag,2,sum,na.rm=T))
}


savepng(paste0("fit",'.png', sep=""),width=17.78,height=17.78)
par(mfrow=c(1,1),mar=c(4.5,4.5,2,3))
x = barplot(obs[1,],  ylab="Number recovered", xlab="Year/quarter", axes = FALSE,axisnames = FALSE,ylim=c(0,max(obs[1,],pred[1,])))
#plot(yrqtr,obs[1,], ylab="Number recovered", xlab="Year/quarter",log="y")
lines(x, pred[1,], lwd=2, col="black")
# lines(x, pred[2,], lwd=2, col="red")
axis(1, at=x[seq(1,length(yrqtr),by=4)], labels=yrqtr[seq(1,length(yrqtr),by=4)])
axis(2)
#legend('topright',col=c("black","red"),lwd=2,lty=1,legend=c("basic","io2"),bty="n")
dev.off()




