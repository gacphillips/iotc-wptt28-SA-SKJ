setwd("C:\\Users\\dfu\\OneDrive - Food and Agriculture Organization\\Projects\\2026\\2026SKJSS3\\Working\\R")
source("init.R")
source("functions/ggtheme.R")
source("functions/LFA_helper.R")
source("functions/mutate_cond.R")


figure_name = "input_growth_"
saveplot = function(label,size=1,type="png",res=800,...) {SavePlot(paste(figure_name,label,sep=""),type=type,size=size,res=res,...)}
savepng = function(label, width=21, height=29.7,units="cm",res=800,bg = "white",...)  { png(paste(figure_name,label,sep=""),width=width,height=height,units=units,res=res,bg=bg,...)}  #7 inch = 17.78     



savepng('growth options.png',height=17.78,width=17.78)
par(xaxs='i',yaxs='i')
temp=vonBert.FUN2(a=c(0:9),k=0.37,Lmin=20,b=0,amin=0,Linf=70,cv=c(0,0)) 
plot.growth(temp,lwd=4,col='red')
temp = vonBert.FUN2(a=c(0:9),k=0.22,Lmin=20,b=0,amin=0,Linf=83,cv=c(0,0)) 
plot.growth(temp,lwd=4,col='blue',add=T)
temp=vonBlogK.FUN(a = c(0:9),Linf=71.6,a0=-0.3, k1=1.12, k2=0.33, alpha=0.95, beta=24.8, cv=c(0,0))
plot.growth(temp,lwd=4,col='green4',add=T)
legend(5,40,c('RH11-70cm K0.37','LEP11-83cm K0.22','VB-logk (Paige 2012)'),lwd=4,col=c('red','blue','green4'),lty=1,,bty='n',cex=1.2)
dev.off()



savepng('growth.png',height=17.78,width=17.78)
par(xaxs='i',yaxs='i')
cv=approx(x=c(0,9),y=c(0.2,0.1),xout=0:9)$y
temp=Richard.FUN2(a=c(0:9),k=0.34809,Lmin=5.89629,b=0,amin=0,Lmax=70.3509, amax=999,delta = 2.9096,cv=cv)  #Lmin should be 20 Lmax=70.3509,amax=999
ALK = get_ALK (temp$mean,temp$sigma,age_bins=0:9,len_bins = 1:80)
plot.growth(temp,lwd=2,col='red',xlim=c(0,max(temp$age)),ylim=c(0,max(temp[,2:4])),CI=FALSE)
add.G(ALK,lwd=1)
plot.growth(temp,lwd=2,col='red',xlim=c(0,max(temp$age)),ylim=c(0,max(temp[,2:4])),CI=FALSE,add=T)
dev.off()


temp=Richard.FUN2(a=c(0:9),k=0.34809,Lmin=5.89629,b=0,amin=0,Lmax=70.3509, amax=999,delta = 2.9096,cv=cv)  #Lmin should be 20 Lmax=70.3509,amax=999
temp2=Richard.FUN2(a=c(0:9),k=0.34809,Lmin=5.89629,b=0,amin=0,Lmax=75, amax=999,delta = 2.9096,cv=cv)  #Lmin should be 20 Lmax=70.3509,amax=999
plot.growth(temp,lwd=2,col='red',xlim=c(0,max(temp$age)),ylim=c(0,max(temp[,2:4])),CI=FALSE)
plot.growth(temp2,lwd=2,col='green',xlim=c(0,max(temp2$age)),ylim=c(0,max(temp2[,2:4])),CI=FALSE,add=T)



