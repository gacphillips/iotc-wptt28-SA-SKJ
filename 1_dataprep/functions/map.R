IOTC_REGIONS = list ("1"=list(x=c(20,20),y=c(-35,-45)),
                      "2"=list(x=c(20,80),y=c(-45,-45)),
                      "3"=list(x=c(77,77),y=c(10,0)),
                      "4"=list(x=c(77,80),y=c(0,0)),
                      "5"=list(x=c(80,80),y=c(0,-55)),
                      "6"=list(x=c(80,150),y=c(-55,-55)),
					  "7"=list(x=c(150,150),y=c(-35,-55)),
					  "8"=list(x=c(115,129),y=c(-8,-8)),
					  "9"=list(x=c(129,129),y=c(-8,-15)))

				   
wcpfc.labels <- function(pos=3,cex=4,col="brown") {
 text(155,25,"1",pos=pos,cex=cex,col=col)
 text(155,0,"3",pos=pos,cex=cex,col=col)
 text(155,-30,"5",pos=pos,cex=cex,col=col)
 text(195,25,"2",pos=pos,cex=cex,col=col)
 text(195,0,"4",pos=pos,cex=cex,col=col)
 text(195,-30,"6",pos=pos,cex=cex,col=col) }

iotc.regions <- function(col="brown",lty=2,lwd=2) {
  lines(IOTC_REGIONS[["1"]]$x,IOTC_REGIONS[["1"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["2"]]$x,IOTC_REGIONS[["2"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["3"]]$x,IOTC_REGIONS[["3"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["4"]]$x,IOTC_REGIONS[["4"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["5"]]$x,IOTC_REGIONS[["5"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["6"]]$x,IOTC_REGIONS[["6"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["7"]]$x,IOTC_REGIONS[["7"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["8"]]$x,IOTC_REGIONS[["8"]]$y,col=col,lty=lty,lwd=lwd)
  lines(IOTC_REGIONS[["9"]]$x,IOTC_REGIONS[["9"]]$y,col=col,lty=lty,lwd=lwd)
}
  
SWO_REGIONS = list("NW" = list(x=c(50,70,70,40),y=c(10,10,-15,-15)),
				   "NE" = list(x=c(70,110,110,115,115,70),y=c(10,10,-10,-10,-15,-15)),
				   "SW" = list(x=c(40,60,60,20,20),y=c(-15,-15,-40,-40,-35)),
				   "SE" = list(x=c(60,115,115,60),y=c(-15,-15,-40,-40)))
				   
  

swo.regions <- function(col="black",lty=1,lwd=2,labels=T,cex=1.2) {
	lines(SWO_REGIONS[["NW"]]$x,SWO_REGIONS[["NW"]]$y,lty=lty,lwd=lwd)
	lines(SWO_REGIONS[["NE"]]$x,SWO_REGIONS[["NE"]]$y,lty=lty,lwd=lwd)
	lines(SWO_REGIONS[["SW"]]$x,SWO_REGIONS[["SW"]]$y,lty=lty,lwd=lwd)
	lines(SWO_REGIONS[["SE"]]$x,SWO_REGIONS[["SE"]]$y,lty=lty,lwd=lwd)
	if(labels) {
		text(55,0,"NW",cex=cex,col=col)
		text(85,0,"NE",cex=cex,col=col)
		text(40,-30,"SW",cex=cex,col=col)
		text(85,-30,"SE",cex=cex,col=col)
	}  
}

YFT_REGIONS = list("R1a" = list(x=c(50,75),y=c(10,10)),
				   "R1b" = list(x=c(50,75,75,60,60,40),y=c(10,10,-15,-15,-10,-10)),
				   "R2" = list(x=c(40,60,60,40,40,20,20),y=c(-10,-10,-30,-30,-40,-40,-35)),
				   "R3" = list(x=c(60,125,120,120,40,40,60,60),y=c(-15,-15,-15,-40,-40,-30,-30,-15)),
				   "R4" = list(x=c(75,75,125),y=c(10,-15,-15)))
				   

YFT_REGIONS2 = list("R1a" = list(x=c(50,80),y=c(10,10)),
				   "R1b" = list(x=c(50,80,80,50,NA,45,35),y=c(10,10,-15,-15,NA,-20,-20)),
				   "R2" = list(x=c(35,45,NA, 50,50,20,20),y=c(-20,-20,NA,-15,-40,-40,-35)),
				   "R3" = list(x=c(50,125,120,120,NA,120,120,50,50),y=c(-15,-15,-15,-20,NA,-34,-40,-40,-15)),
				   "R4" = list(x=c(80,80,125),y=c(10,-15,-15)))
				   
				   
yft.regions <- function(yft_region,col="black",lty=1,lwd=2,labels=T,cex=1.2,R1a=T) {
	lines(yft_region[["R1a"]]$x,yft_region[["R1a"]]$y,lty=lty,lwd=lwd,col=col)
	lines(yft_region[["R1b"]]$x,yft_region[["R1b"]]$y,lty=lty,lwd=lwd,col=col)
	lines(yft_region[["R2"]]$x,yft_region[["R2"]]$y,lty=lty,lwd=lwd,col=col)
	lines(yft_region[["R3"]]$x,yft_region[["R3"]]$y,lty=lty,lwd=lwd,col=col)
	lines(yft_region[["R4"]]$x,yft_region[["R4"]]$y,lty=lty,lwd=lwd,col=col)
	if(R1a) lines(yft_region[["R1a"]]$x,yft_region[["R1a"]]$y,col="white",lwd=lwd)
	if(R1a) lines(yft_region[["R1a"]]$x,yft_region[["R1a"]]$y,col=col,lty=2,lwd=lwd)
	if(labels) {
		text(63,20,"R1a",cex=cex,col='black')
		text(52,5,"R1b",cex=cex,col='black')
		text(40,-27,"R2",cex=cex,col='black')
		text(70,-20,"R3",cex=cex,col='black')
		text(85,1,"R4",cex=cex,col='black')
	}  
}



BET_REGIONS = list("R1N" = list(x=c(50,80,80,40),y=c(10,10,0,0)),
				   "R1S" = list(x=c(40,80,80,50,NA,45,35),y=c(0,0,-15,-15,NA,-20,-20)),
				   "R2" = list(x=c(100,80,80,125),y=c(10,10,-15,-15)),
				   "R3" = list(x=c(50,125,NA,120,20,NA,35,45),y=c(-15,-15,NA,-35,-35,NA,-20,-20)))
				 
				   
bet.regions <- function(col="black",lty=1,lwd=2,labels=T,cex=1.2) {
	lines(BET_REGIONS[["R1N"]]$x,BET_REGIONS[["R1N"]]$y,lty=lty,lwd=lwd,col=col)
	lines(BET_REGIONS[["R1S"]]$x,BET_REGIONS[["R1S"]]$y,lty=lty,lwd=lwd,col=col)
	lines(BET_REGIONS[["R2"]]$x,BET_REGIONS[["R2"]]$y,lty=lty,lwd=lwd,col=col)
	lines(BET_REGIONS[["R3"]]$x,BET_REGIONS[["R3"]]$y,lty=lty,lwd=lwd,col=col)
	if(labels) {
		text(60,5,"R1N",cex=cex,col='black')
		text(60,-6,"R1S",cex=cex,col='black')
		text(95,-5,"R2",cex=cex,col='black')
		text(80,-25,"R3",cex=cex,col='black')
		
	}  
}

BET_REGIONS2 = list("R1" = list(x=c(40,80,80,50,NA,45,35),y=c(10,10,-15,-15,NA,-20,-20)),
					"R2" = list(x=c(100,80,80,125),y=c(10,10,-15,-15)),
				   "R3" = list(x=c(50,125,NA,120,20,NA,35,45),y=c(-15,-15,NA,-35,-35,NA,-20,-20)))
				   
				   
bet.regions2 <- function(col="black",lty=1,lwd=2,labels=T,cex=1.2) {
	lines(BET_REGIONS2[["R1"]]$x,BET_REGIONS2[["R1"]]$y,lty=lty,lwd=lwd,col=col)
	lines(BET_REGIONS[["R2"]]$x,BET_REGIONS2[["R2"]]$y,lty=lty,lwd=lwd,col=col)
	lines(BET_REGIONS2[["R3"]]$x,BET_REGIONS2[["R3"]]$y,lty=lty,lwd=lwd,col=col)
	if(labels) {
		text(60,-5,"R1",cex=cex,col='black')
		text(95,-5,"R2",cex=cex,col='black')
		text(80,-25,"R3",cex=cex,col='black')
		
	}  
}


SKJ_REGIONS = list("WEST" = list(x=c(50,70,70,80,80),y=c(10,10,-5,-5,-50)),
				   "EAST" = list(x=c(110,130,130),y=c(-7.5,-7.5,-15)))
				   
skj.regions <- function(col="black",lty=1,lwd=2,labels=T,cex=1.2) {
	lines(SKJ_REGIONS[["WEST"]]$x,SKJ_REGIONS [["WEST"]]$y,lty=lty,lwd=lwd,col=col)
	lines(SKJ_REGIONS[["EAST"]]$x,SKJ_REGIONS[["EAST"]]$y,lty=lty,lwd=lwd,col=col)
	if(labels) {
		text(60,-15,"West",cex=cex,col='black')
		text(90,-15,"East",cex=cex,col='black')		
	}  
}




