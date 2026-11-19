## vertical
fat.arrow<-function(size.x=0.5,size.y=0.5,ar.col="grey")
{
size.x<-size.x*(par("usr")[2]-par("usr")[1])*0.1
size.y<-size.y*(par("usr")[4]-par("usr")[3])*0.1
pos<-locator(1)
#xc<-c(0,1,0.5,0.5,-0.5,-0.5,-1,0)
#yc<-c(0,1,1,6,6,1,1,0)
xc<-c(0,1,0.5,0.5,1,0,-1,-0.5,-0.5,-1,0)
yc<-c(0,1,1,6, 6, 7,6,6,1,1,0)
polygon(pos$x+size.x*xc,pos$y+size.y*yc,col=ar.col) }

##horizontal
fat.arrow2<-function(size.x=0.5,size.y=0.5,ar.col="grey"){
size.x<-size.x*(par("usr")[2]-par("usr")[1])*0.1
size.y<-size.y*(par("usr")[4]-par("usr")[3])*0.1
pos<-locator(1)
#xc<-c(0,1,0.5,0.5,-0.5,-0.5,-1,0)
#yc<-c(0,1,1,6,6,1,1,0)
yc<-c(0,1,0.5,0.5,1,0,-1,-0.5,-0.5,-1,0)
xc<-c(0,1,1,6, 6, 7,6,6,1,1,0)
polygon(pos$x+size.x*xc,pos$y+size.y*yc,col=ar.col) 
}

