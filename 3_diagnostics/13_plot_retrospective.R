
figure_name = "13_retro_"
saveplot = function(label,size=1,type="png",res=800,...) {SavePlot(paste(figure_name,label,sep=""),type=type,size=size,res=res,...)}
savepng = function(label, width=21, height=29.7,units="cm",res=800,bg = "white",...)  { png(paste(figure_name,label,'.png',sep=""),width=width,height=height,units=units,res=res,bg=bg,...)}  #7 inch = 17.78     
library(r4ss)





plotRetro = function(retroSummary,startyrs,endyrs) {
  
  # SpawninBio
  dat = 	retroSummary$SpawnBio
  tstep <- 1950:2024
  n = length(startyrs)
  plot(0,0,xlim=range(tstep),ylim=c(0,Max(dat[,1:n]/1000)),type='n',xlab='Year',ylab='Spawning biomass (1000s t)')
  
  for (i in 1:n) {
    dat2 = subset(dat,Yr >=startyrs[i] & Yr <=endyrs[i])
    tstep = dat2$Yr
    lines(tstep,dat2[,i]/1000,lwd=2,col=i)
  }  
  legend('bottomleft',legend=paste("Data", c(0,-1,-2,-3,-4,-5),"Years"),lwd=2,col=1:6)
  mtext('SSB',line=0.2,cex=1.2)
  
  
  
  dat = 	retroSummary$SpawnBio
  tstep <- 1950:2024
  n = length(startyrs)
  plot(0,0,xlim=range(tstep),ylim=c(0,105),type='n',xlab='Year',ylab='Spawning biomass (1000s t)')
  
  for (i in 1:n) {
    dat2 = subset(dat,Yr >=startyrs[i] & Yr <=endyrs[i])
    tstep = dat2$Yr
    lines(tstep,dat2[,i]/dat[1,i]*100,lwd=2,col=i)
  }  
  mtext('SSB/SSB0',line=0.2,cex=1.2)
  
  # Fratio
  # dat = 	retroSummary$Fvalue
  # tstep <- 1950:2021
  # plot(0,0,xlim=range(tstep),ylim=c(0,0.2),type='n',xlab='Year',ylab='F')
  # for (i in 1:n) {
  #	dat2 = subset(dat,Yr >=startyrs[i] & Yr <=endyrs[i])
  #	tstep = dat2$Yr
  #	lines(tstep,dat2[,i],lwd=2,col=i)
  #}  
  ## abline(h=1.0,lty=2)
  # mtext('F',line=0.2,cex=1.2)
  
  #Rdev
  # dat = 	retroSummary$recdevs
  # dat = dat[!duplicated(dat$Yr),]
  # tstep <- 1950:2021
  # plot(0,0,xlim=range(1970,2021),ylim=c(-0.5,0.5),type='n',xlab='Year',ylab='Recruit dev')
  # for (i in 1:n) {
  #	dat2 = subset(dat,Yr >=startyrs[i] & Yr <=endyrs[i])
  #	tstep = dat2$Yr
  #	lines(tstep,dat2[,i],lwd=2,col=i)
  # }  
  # abline(h=0,lty=2)
  # mtext('Recruitment deviations',line=0.2,cex=1.2)
  
}

load_obj <- function(dir) {
  obj <- list()
  obj$dir <- dir
  obj$dat <- SS_readdat_3.30(make.filename("data.ss",dir))
  #obj$dat <- readLines(make.filename("data.ss",dir))
  obj$ctl <- readLines(make.filename("control.ss",dir))
  obj$starter <- SS_readstarter(make.filename("starter.ss",dir))
  obj$forecast <- readLines(make.filename("forecast.ss",dir))
  #obj$parstart <- readLines(make.filename("SS324z.par",dir))
  return(obj)
}


make_run <- function(obj,SSsource) {
  dir.create(obj$dir)
  if(!missing(SSsource)) file.copy(from=make.filename("ss3_win.exe",SSsource),to=obj$dir)
  if(exists("parstart",where=obj)) write(obj$parstart,file=make.filename("ss.par",obj$dir))
  #write(obj$dat,file=make.filename("data.ss",obj$dir))
  write(obj$ctl,file=make.filename("control.ss",obj$dir))
  write(obj$forecast,file=make.filename("forecast.ss",obj$dir))
  SS_writedat(obj$dat,make.filename("data.ss",obj$dir),version = "3.30",overwrite=T)
  SS_writestarter(obj$starter,dir=obj$dir,overwrite=T)
}

#########################
# base 
#########################

mydir <- base_dir
reference <- load_obj(dir = mydir)
results_retro = list()
no = c(0,1,2,3,4,5)
endyr = c(2025,2024,2023,2022,2021,2020)
lastrecyr = c(2024,2023,2022,2021,2020,2019)
Bmark_years = c('0 0 0 0 0 0 1950 0 1950 0', 
                '-1 -1 -1 -1 -1 -1 1950 -1 1950 -1',
                '-2 -2 -2 -2 -2 -2 1950 -2 1950 -2',
                '-3 -3 -3 -3 -3 -3 1950 -3 1950 -3',
                '-4 -4 -4 -4 -4 -4 1950 -4 1950 -4',
                '-5 -5 -5 -5 -5 -5 1950 -5 1950 -5')
Fcast_years = c('2025 2025 2025 2025 -999 0',
                '2024 2024 2024 2024 -999 0',
                '2023 2023 2023 2023 -999 0',
                '2022 2022 2022 2022 -999 0',
                '2021 2021 2021 2021 -999 0', 
                '2020 2020 2020 2020 -999 0')

for (i in 1:length(no)) {
  results_retro$dir =  paste0(mydir,"/retrospectives/retro-",no[i])
  results_retro$ctl = reference$ctl
  results_retro$dat = reference$dat
  results_retro$forecast = reference$forecast
  results_retro$starter = reference$starter
  results_retro$parstart = NULL
  
  results_retro$starter$F_report_basis = 0
  results_retro$dat$endyr = endyr[i]
  results_retro$dat$CPUE = subset(results_retro$dat$CPUE,year<=endyr[i])
  results_retro$dat$lencomp = subset(results_retro$dat$lencomp,year<=endyr[i])
  results_retro$ctl[c(109,118,119)] = lastrecyr[i] #168,177,178 (2023 revised)
  results_retro$forecast[9] = Bmark_years[i]
  # results_retro$forecast[18] = Fcast_years[i]
  make_run(results_retro)
  setwd(results_retro$dir)
  system("ss3_win.exe  -cbs 1000000000 -gbs 10000000000 -nohess -maxfn 5000")
}



# retro(masterdir=mydir, oldsubdir="", newsubdir="retrospectives", years=c(0,-1,-2,-3,-4,-5), extras = "-nohess -nox")
retroModels <- SSgetoutput(dirvec=file.path(mydir, "retrospectives",paste("retro",c('-0','-1','-2','-3','-4','-5'),sep="")),getcovar = FALSE,forecast=F)
retroSummary <- SSsummarize(retroModels)
startyrs <- retroSummary$startyrs 
endyrs <- retroSummary$endyrs 



savepng('Retrospectives SKJ 3e_update_cpue.png',width = 30,height=20)
par(mfrow=c(1,2), mar=c(3,4,2,1)) 
plotRetro(retroSummary,startyrs,endyrs)
dev.off()



