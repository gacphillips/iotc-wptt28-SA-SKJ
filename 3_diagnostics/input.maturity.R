setwd("C:\\Users\\dfu\\OneDrive - Food and Agriculture Organization\\Projects\\2026\\2026SKJSS3\\Working\\R")
source("init.R")
source("functions/ggtheme.R")
source("functions/LFA_helper.R")
source("functions/mutate_cond.R")


figure_name = "input_maturity_"
saveplot = function(label,size=1,type="png",res=800,...) {SavePlot(paste(figure_name,label,sep=""),type=type,size=size,res=res,...)}
savepng = function(label, width=21, height=29.7,units="cm",res=800,bg = "white",...)  { png(paste(figure_name,label,sep=""),width=width,height=height,units=units,res=res,bg=bg,...)}  #7 inch = 17.78     


logistic.ogive<-function(x,omega3,omega4) {
  y<- 1/(1+exp(omega3*(x-omega4)))
  return(list("x"=x,"y"=y))
}

plot.maturity = function(x,omega3,omega4,xlim=c(10,80),ylim=c(0,1.04),xlab="Length",ylab="Proportion",col="red",lwd=1,pch=16,cex=1.0) {
	plot(0,0,xlab=xlab,ylab=ylab,xlim=xlim,ylim=ylim,type="n",cex.lab=1.4)
	points(logistic.ogive(x,omega3,omega4)$x,logistic.ogive(x,omega3,omega4)$y,lwd=lwd,col=col)
	lines(logistic.ogive(x,omega3,omega4)$x,logistic.ogive(x,omega3,omega4)$y,lwd=lwd,col=col)
	box()
}

savepng('maturity.png',width=17.78, height=17.78)
plot.maturity (20:80,omega3=-1.25,omega4=38)
dev.off()

# Zudaire 2023：
alpha = -13.78
beta = 0.333

# Zudaire 2022
alpha2 = -5.46
beta2 = 0.054
MatureLength2 = exp(alpha2+beta2*Length)/(1+exp(alpha2+beta2*Length))
