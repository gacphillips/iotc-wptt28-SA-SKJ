#GRID_PARAM[["min_lat"]] = -87.5
#GRID_PARAM[["max_lat"]] = 87.5
#GRID_PARAM[["min_long"]] = 2.5
#GRID_PARAM[["max_long"]] = 357.5
#GRID_PARAM[["size_lat"]] = 5
#GRID_PARAM[["size_long"]] = 5
#GRID_PARAM[["IOTC"]] = TRUE
#GRID_PARAM[["size_grid"]] = 6

 setempty = function(set) setequal(set,c())
 Intersect = function(x,y,z) intersect(intersect(x,y),z)
 Union = function(x,y,z) union(union(x,y),z)

 setup_GRID_PARAM = function(min_lat= -67.5,max_lat=27.5,min_long=2.5,max_long=152.5,size_lat=5,size_long=5,size_grid=6) {
	
	GRID_PARAM = list()
	GRID_PARAM[["min_lat"]] = min_lat 
	GRID_PARAM[["max_lat"]] = max_lat
	GRID_PARAM[["min_long"]] = min_long 
	GRID_PARAM[["max_long"]] = max_long 
	GRID_PARAM[["size_lat"]] = size_lat
	GRID_PARAM[["size_long"]] = size_long
	GRID_PARAM[["n_lat"]] = (max_lat - min_lat)/size_lat + 1
	GRID_PARAM[["n_long"]] = (max_long - min_long)/size_long + 1
	GRID_PARAM[["latitude"]] = seq(min_lat,max_lat,by=size_lat)
	GRID_PARAM[["longitude"]] = seq(min_long,max_long,by=size_long)
    GRID_PARAM[["lat_breaks"]] = c(min_lat-size_lat/2,seq(min_lat+size_lat/2,max_lat-size_lat/2,by = size_lat),max_lat+size_lat/2)
    GRID_PARAM[["long_breaks"]] = c(min_long-size_long/2,seq(min_long+size_long/2,max_long-size_long/2,by = size_long),max_long+size_long/2)
	
	return (GRID_PARAM)	
} 

setup_GRID = function(GRID_PARAM) {
	min_lat = GRID_PARAM[["min_lat"]]
	max_lat = GRID_PARAM[["max_lat"]]
	min_long = GRID_PARAM[["min_long"]]
	max_long = GRID_PARAM[["max_long"]]
	size_lat = GRID_PARAM[["size_lat"]]
	size_long = GRID_PARAM[["size_long"]]
	n_lat = GRID_PARAM[["n_lat"]]
	n_long = GRID_PARAM[["n_long"]]
	latitude = GRID_PARAM[["latitude"]]
	longitude = GRID_PARAM[["longitude"]]
	GRID = list()
	i=0
	for(lat in latitude) {
		for(long in longitude) {
			i = i+1
			GRID[[as.character(i)]] = data.frame(id = i,id_lat=lat,id_long=long,
                                         lat = c(lat+size_lat/2,lat+size_lat/2,lat-size_lat/2,lat-size_lat/2),
                                         long = c(long-size_long/2, long+size_long/2,long+size_long/2,long-size_long/2))
		}
	}
	return (GRID)
}
	
get.id.from.lat.long = function(GRID_PARAM,lat,long,approximate=T) {
	min_lat = GRID_PARAM[["min_lat"]]
	max_lat = GRID_PARAM[["max_lat"]]
	min_long = GRID_PARAM[["min_long"]]
	max_long = GRID_PARAM[["max_long"]]
	size_lat = GRID_PARAM[["size_lat"]]
	size_long = GRID_PARAM[["size_long"]]
	n_lat = GRID_PARAM[["n_lat"]]
	n_long = GRID_PARAM[["n_long"]]
	latitude = GRID_PARAM[["latitude"]]
	longitude = GRID_PARAM[["longitude"]]
	if(!approximate) {
		i = which(latitude == lat)
		j = which(longitude == long)
	} else {
		i = which.min(abs(latitude - lat))
		j = which.min(abs(longitude - long))
	}
	as.character((i-1) * n_long + j)
}

	
get.lat.from.id = function(GRID_PARAM,id) {
	n_long = GRID_PARAM[["n_long"]] 
	n_lat = GRID_PARAM[["n_lat"]] 
	longitude = GRID_PARAM[["longitude"]]	
	
	i = as.numeric(id) %/% n_long
	if (as.numeric(id) %% n_long ==0)
		i = i -1
	lat = latitude[i+1]
	lat
}
	
get.long.from.id = function(GRID_PARAM,id) {
	n_long = GRID_PARAM[["n_long"]] 
	longitude = GRID_PARAM[["longitude"]]	
	j = as.numeric(id) %% n_long
	if(j==0)
		long = longitude[n_long]
	else
		long = longitude[j]
	long
}
	




get.lat.long.from.id = function(GRID_PARAM,id) {
	
	list(lat = get.lat.from.id(GRID_PARAM,id),long = get.long.from.id(GRID_PARAM,id))

}

get.grid.from.lat.long = function(GRID_PARAM,lat,long,approximate=T) {

	min_lat = GRID_PARAM[["min_lat"]]
	max_lat = GRID_PARAM[["max_lat"]]
	min_long = GRID_PARAM[["min_long"]]
	max_long = GRID_PARAM[["max_long"]]
	size_lat = GRID_PARAM[["size_lat"]]
	size_long = GRID_PARAM[["size_long"]]
	n_lat = GRID_PARAM[["n_lat"]]
	n_long = GRID_PARAM[["n_long"]]
	latitude = GRID_PARAM[["latitude"]]
	longitude = GRID_PARAM[["longitude"]]

	
	if(!approximate) {
		i = which(latitude == lat)
		j = which(longitude == long)
	} else {
		i = which.min(abs(latitude - lat))
		j = which.min(abs(longitude - long))
	}
	lat = latitude[i]
	long = longitude[j]
	data.frame(lat = c(lat+size_lat/2,lat+size_lat/2,lat-size_lat/2,lat-size_lat/2),
               long = c(long-size_long/2, long+size_long/2,long+size_long/2,long-size_long/2))
}

get.grid.from.id = function(GRID_PARAM,id) {

	lat = get.lat.from.id(GRID_PARAM,id)
	long = get.long.from.id(GRID_PARAM,id)
	data.frame(lat = c(lat+size_lat/2,lat+size_lat/2,lat-size_lat/2,lat-size_lat/2),
               long = c(long-size_long/2, long+size_long/2,long+size_long/2,long-size_long/2))
}
	
	
    
v.get.lat.from.id =Vectorize(get.lat.from.id)
v.get.long.from.id =Vectorize(get.long.from.id)


add.grid = function(grid,border="gray",col="white",label=F,...) {
        polygon(grid$long,grid$lat,border=border,col=col,...)
        if(label) text(grid$id_long,grid$id_lat,grid$id,col="gray50",...)
}
v.add.grid =Vectorize(add.grid)

add.fraction = function(grid,fraction=1,border="gray",col="white",...) {
  grid$long[3]=grid$long[2] = grid$long[1] + fraction*(grid$long[2]-grid$long[1])
  polygon(grid$long,grid$lat,border=border,col=col,...)
}
v.add.fraction =Vectorize(add.fraction)


add.symbol = function(grid,pch=1,size=0,scale=1,...) {
  points(grid$id_long[1],grid$id_lat[1],pch=pch,cex=sqrt(size)*scale,...)
  invisible()
}
v.add.symbol =Vectorize(add.symbol)

add.pie = function(grid,size,proportion,scale=1,col = terrain.colors(length(proportion)),fg="black",...) {
	inches = sqrt(size*scale)
	if (sum(proportion,na.rm=T) == 0) return 
	tp <- pi/2 - 2*pi*c(0,cumsum(proportion))
	for (i in 1:length(proportion)) {
		if (tp[i+1]==tp[i]) next
		pp <- seq(tp[i], tp[i+1],length=floor((tp[i]-tp[i+1])*4)+2) #polygon-pontok
        rx <- xinch(inches)
        ry <- yinch(inches)
        xi <- grid$id_long[1]+c(0,rx*cos(pp))
        yi <- grid$id_lat[1]+c(0,ry*sin(pp))
        polygon(xi,yi, col=col[i], border=NA)
    }
	polygon(grid$id_long[1]+rx*cos((1:180)*pi/90),grid$id_lat[1]+ry*sin((1:180)*pi/90), col=NA, border=fg)
  
  
}
v.add.pie =Vectorize(add.pie)

GRID.plot = function(GRID_PARAM,width = 12,height=7,xaxs="i",yaxs="i",xlab="Longitude",ylab="Latitude",xlim=c(min_long,max_long),ylim=c(min_lat,max_lat),col="gray90",new=T,bg=NA,...) {
    
    #if (new) {
    #    windows(width = width, height =height)
    #    par(xaxs="i",yaxs="i")
    #}
	min_lat = GRID_PARAM[["min_lat"]]
	max_lat = GRID_PARAM[["max_lat"]]
	min_long = GRID_PARAM[["min_long"]]
	max_long = GRID_PARAM[["max_long"]]
	size_lat = GRID_PARAM[["size_lat"]]
	size_long = GRID_PARAM[["size_long"]]
	latitude = GRID_PARAM[["latitude"]]
	longitude = GRID_PARAM[["longitude"]]

    if(new) {
		plot(0,0,type="n",xlim=xlim,ylim=ylim,xlab=xlab,ylab=ylab,...)
		polygon(c(xlim[1]-5, xlim[2]+5, xlim[2]+5, xlim[1]-5), c(ylim[1]-5, ylim[1]-5, ylim[2]+5, ylim[2]+5), col = bg)
	}
    abline(h=seq(min_lat+size_lat/2,max_lat-size_lat/2,by = size_lat),col=col,...)
    abline(v=seq(min_long+size_long/2,max_long-size_long/2,by = size_long),col=col,...)
}
