
figure_name = "14_retro_diags_"

Model = MODEL_NAME
# mod = ss3rep=SS_output(dir=paste0(PATH_SS3,Model),covar=FALSE,ncol=1000)
mod <- plot_model
cpue = mod$cpue
cpue$Fleet = ifelse(cpue$Fleet  %in% c(18,19,20,21),18,cpue$Fleet)
cpue$Fleet_name = ifelse(cpue$Fleet_name  %in% c("SURVEY3Q1","SURVEY3Q2","SURVEY3Q3","SURVEY3Q4"),"SURVEY3",cpue$Fleet_name)
cpue=cpue[order(cpue$Yr),]
mod$cpue=cpue

retros <- retroSummary
end.time= 2024.75
time.steps = 0.25
ss3rep = SSdiagsTime2Year(mod,time.steps,end.time) #initial=1952,base=101,

# subdirs = paste0("retrospectives/retro-",c(0,seq(1,5,1))) # Define SS3 model folders
# retroModels <- SSgetoutput(dirvec=file.path(paste0(PATH_SENSITIVITES,MODEL_NAME, sep=""),subdirs),getcovar=FALSE)


retroSummary = SSdiagsTime2Year(retros,time.steps,end.time) #initial=1952,base=101,
cpue = retroSummary$indices
cpue$Fleet = ifelse(cpue$Fleet  %in% c(18,19,20,21),18,cpue$Fleet)
cpue$Fleet_name = ifelse(cpue$Fleet_name  %in% c("SURVEY3Q1","SURVEY3Q2","SURVEY3Q3","SURVEY3Q4"),"SURVEY3",cpue$Fleet_name)
cpue=cpue[order(cpue$Yr),]
retroSummary$indices=cpue




savepng(paste0(MODEL_NAME,'cpue residuals.png',sep=""),height=17.78,width = 25)
sspar(mfrow=c(3,2),plot.cex =0.7)
SSplotRunstest(ss3rep,add=T)
dev.off()



savepng(paste0(MODEL_NAME,'length residuals.png',sep=""),height=17.78,width = 25)
sspar(mfrow=c(4,3),plot.cex =0.7)
SSplotRunstest(ss3rep,subplots ="len",add=T)
dev.off()



# Do Retro plus Forecast
# sspar(mfrow=c(2,1),plot.cex = 0.7)
# SSplotRetro(retroSummary,add=F,forecast=F,xlim = c(1972,2024),uncertainty =F,ylim=c(0,5000000),endyrvec=c(2024,2023,2022,2021,2020,2019))


# Do HCxval
# Season 1
savepng(paste0(MODEL_NAME,'season 1.png',sep=""),height=17.78,width = 17.78)
sspar(mfrow=c(3,2),plot.cex = 0.7,labs=F)
SSplotHCxval(retroSummary,add=T,Season=1,legendcex = 0.7,indexUncertainty=F,endyrvec=c(2024,2023,2022,2021,2020,2019))
mtext("Year",side=1,outer=T,cex=1,line=0.5)
mtext("Index",side=2,outer=T,line=0.5,cex=1)
dev.off()

# Season 2
savepng(paste0(MODEL_NAME,'season 2.png',sep=""),height=17.78,width = 17.78)
sspar(mfrow=c(3,2),plot.cex = 0.7,labs=F)
SSplotHCxval(retroSummary,add=T,Season=2,legendcex = 0.7,indexUncertainty=F,endyrvec=c(2024,2023,2022,2021,2020,2019))
mtext("Year",side=1,outer=T,cex=1,line=0.5)
mtext("Index",side=2,outer=T,line=0.5,cex=1)
dev.off()

# Season 3
savepng(paste0(MODEL_NAME,'season 3.png',sep=""),height=17.78,width = 17.78)
sspar(mfrow=c(3,2),plot.cex = 0.7,labs=F)
#Specify Season
SSplotHCxval(retroSummary,add=T,Season=3,legendcex = 0.7,indexUncertainty=F,endyrvec=c(2024,2023,2022,2021,2020,2019))
mtext("Year",side=1,outer=T,cex=1,line=0.5)
mtext("Index",side=2,outer=T,line=0.5,cex=1)
dev.off()

# Season 4
savepng(paste0(MODEL_NAME,'season 4.png',sep=""),height=17.78,width = 17.78)
sspar(mfrow=c(3,2),plot.cex = 0.7,labs=F)
#Specify Season
SSplotHCxval(retroSummary,add=T,Season=3,legendcex = 0.7,indexUncertainty=F,endyrvec=c(2024,2023,2022,2021,2020,2019))
mtext("Year",side=1,outer=T,cex=1,line=0.5)
mtext("Index",side=2,outer=T,line=0.5,cex=1)
dev.off()

