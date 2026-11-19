plot_model <- SS_output(dir= paste0(PATH_MODELRUNS,'/4_update_L50'),covar=TRUE,forecast=FALSE)
plot_model <- SS_output(dir= paste0(PATH_SENSITIVITES,'/s10_sigmaR'),covar=TRUE,forecast=FALSE)
plot_model <- SS_output(dir= paste0(PATH_SENSITIVITES,'/s1h_PL_q1_cpue'),covar=TRUE,forecast=FALSE)
plot_model <- SS_output(dir= paste0(PATH_SENSITIVITES,'/s1i_PSLS_q1_cpue'),covar=TRUE,forecast=FALSE)
plot_model <- SS_output(dir= paste0(PATH_SENSITIVITES,'/s1a_MDV_cpue'),covar=TRUE,forecast=FALSE)
plot_model <- SS_output(dir= paste0(PATH_SENSITIVITES,'/s1b_PSLS_cpue'),covar=TRUE,forecast=FALSE)



MODEL_NAME <- '4_update_L50'
MODEL_NAME <- 's10_sigmaR'
MODEL_NAME <- 's1h_PL_q1_cpue'
MODEL_NAME <- 's1i_PSLS_q1_cpue'
MODEL_NAME <- 's1a_MDV_cpue'
MODEL_NAME <- 's1b_PSLS_cpue'


model <- MODEL_NAME


figure_name = "5_rec_"

##########################################
###  basic 
##########################################

# model = "basic"
# out <- SS_output(dir= paste0(PATH_SS3,'2023\\',model),covar=TRUE,forecast=FALSE) #io_h80_MAt_t3_rttp_tm25

out <- SS_output(dir=paste0(PATH_SENSITIVITES,'/s1h_PL_q1_cpue'),covar=TRUE,forecast=FALSE)
out <- SS_output(dir=paste0(PATH_SENSITIVITES,'/s1i_PSLS_q1_cpue'),covar=TRUE,forecast=FALSE)
out <- SS_output(dir=paste0(PATH_SENSITIVITES,'/s1a_MDV_cpue'),covar=TRUE,forecast = FALSE)
out <- SS_output(dir=paste0(PATH_SENSITIVITES,'/s1b_PSLS_cpue'),covar=TRUE,forecast = FALSE)


# rec devs
recdev <- out$parameters[grep("Main_RecrDev", out$parameters$Label),]
recdev$year <-as.numeric(substring(recdev$Label,14,17))
recdev$lci <- recdev$Value - 1.96 * recdev$Parm_StDev
recdev$uci <- recdev$Value + 1.96 * recdev$Parm_StDev
sigmaR <- 0.3
xx <- rnorm(1000,0,sigmaR)
x1 <- quantile(xx, 0.025)
x2 <- quantile(xx, 0.975)

savepng(paste0('recdev - ',model,".png", sep=""),width = 17.78,height=17.78)
plot(recdev$year, recdev$Value, type="l", lwd=2, xlab="Year", ylab="Rec dev", ylim=c(range(recdev$lci,recdev$uci)), xaxt ="n",cex.lab=1.2)
polygon(c(recdev$year, rev(recdev$year)), c(recdev$uci, rev(recdev$lci)), border=NA, col="light grey" )
lines(recdev$year, recdev$Value, lwd=2)
axis(1, at=seq(1950,2030,5))
lines(range(recdev$year), rep(0,2), lty=3)
lines(range(recdev$year), rep(x1,2), lty=4, col="blue")
lines(range(recdev$year), rep(x2,2), lty=4, col="blue")
dev.off()

# recruits by season
dat <- out$timeseries
dat <- dat[dat$Era == "TIME",]
mat <- tapply(dat$Recruit_0, list(dat$Yr, dat$Seas), sum)
tstep <- sort(unique(dat$Yr))
tot <- apply(mat,1,sum)
mat2 <- mat/tot
savepng(paste0('season - ',model,".png", sep=""),width = 17.78,height=17.78)
par(mar=c(5,4,3,1))
plot(tstep, mat2[,1], ylab="Proportion of recruitment", ylim=c(0,0.8), type="l", lwd=2, col="blue", xlab="Year")
lines(tstep, mat2[,2],type="l",lwd=2, col='green4')
lines(tstep, mat2[,3],type="l",lwd=2, col='orange')
lines(tstep, mat2[,4],type="l",lwd=2, col='red')
legend('topleft',lwd=2,col=c('blue','green4','orange','red'), legend=c("Q1","Q2","Q3","Q4"))
dev.off()

