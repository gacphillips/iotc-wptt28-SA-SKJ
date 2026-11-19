
vonBert.FUN <- function(a,Linf,k,t0,cv) {
  VB<-Linf*(1-exp(-k*(a-t0)))
  sigma<-VB*cv
  lower.CI<-VB-(1.96*sigma)
  upper.CI<-VB+(1.96*sigma)
  return(data.frame("age"=a,"mean"=VB,lower.CI,upper.CI,sigma=sigma))
}

vonBert.FUN2 <- function(a,k,Lmin,b,amin,Lmax,amax,Linf,cv) {
  L1 = Lmin + b*amin
  if(length(k)==1) k = rep(k,length(a)) 
  if(missing(Linf)) Linf = Lmin + (Lmax-Lmin)/(1-exp(-k[length(k)]*(amax-amin)))
  n = length(a)
  VB = ifelse(a <= amin, Lmin+b*a, Linf + (L1-Linf)*exp(-k*(a-amin)))
  # need to be implemented as difference equations with age specific k
  for (i in 1:n) {
	if (a[i] <= amin)
		VB[i] = Lmin+b*a[i]
	else 
		VB[i] = Linf+(VB[i-1]-Linf)*(exp(-k[i-1]))
	}  
  sigma<-VB*cv
  lower.CI<-VB-(1.96*sigma)
  upper.CI<-VB+(1.96*sigma)
  return(data.frame("age"=a,"mean"=VB,lower.CI,upper.CI,cv=cv,sigma=sigma))
}

Richard.FUN <- function(a,Linf,k,t0,delta,cv) {
  VB<-Linf*(1-(1/delta)*exp(-k*(a-t0)))^delta
  sigma<-VB*cv
  lower.CI<-VB-(1.96*sigma)
  upper.CI<-VB+(1.96*sigma)
  return(data.frame("age"=a,"mean"=VB,lower.CI,upper.CI))
}

Richard.FUN2 <- function(a,k,Lmin,b,amin,Lmax,amax,delta,cv) {
  L1 = Lmin + b*amin
  Linf =(L1^delta+(Lmax^delta-L1^delta)/(1-exp(-k*(amax-amin))))^(1/delta)
  if(amax==999) 
	VB = ifelse(a <= amin, Lmin+b*a, (L1^delta+(Lmax^delta-L1^delta)*(1-exp(-k*(a-amin))))^(1/delta))  # This assumes Lmax = Linf, amax=999
  else
    VB = ifelse(a <= amin, Lmin+b*a, (L1^delta+(Lmax^delta-L1^delta)*(1-exp(-k*(a-amin)))/(1-exp(-k*(amax-amin))))^(1/delta))  

  sigma<-VB*cv
  lower.CI<-VB-(1.96*sigma)
  upper.CI<-VB+(1.96*sigma)
  return(data.frame("age"=a,"mean"=VB,lower.CI,upper.CI,cv=cv,sigma=sigma))
}


vonBlogK.FUN <- function(a, Linf,a0,k1,k2,alpha,beta,cv) {

	
  VB <- Linf*(1 - exp(-k2*(a- a0))* ((1+exp(-beta*(a-a0-alpha)))/(1+exp(alpha*beta)))^(-(k2-k1)/beta)) 
  sigma<-VB*cv
  lower.CI<-VB-(1.96*sigma)
  upper.CI<-VB+(1.96*sigma)
  return(data.frame("age"=a,"mean"=VB,lower.CI,upper.CI,sigma))

}

plot.growth = function(data,xlim=c(0,10),ylim=c(0,80),xlab="Age",ylab="Length (cm)",col="red",lty=1,lwd=1,CI=FALSE,add=F,...) {
	if(!add) plot(0,0,xlab=xlab,ylab=ylab,xlim=xlim,ylim=ylim,type="n",...)
	lines(data$age,data$mean,lty=lty,lwd=lwd,col=col)
	if(CI==TRUE) lines(data$age,data$lower.CI,lty=2,lwd=lwd,col=col)
	if(CI==TRUE) lines(data$age,data$upper.CI,lty=2,lwd=lwd,col=col)
	box()
}



add.G <- function(G,scale=1,col='red',lwd=2){
    x = as.numeric(rownames(G))
    x = x[x %% 1==0]
    for(i in x){
        g <- G[as.character(i),]
        g <- g/max(g)*scale
        y <- names(g)
        y <- y[g> 0.01]
		polygon(c(rep(i,length(y)),rev(i+g[y])),c(y,rev(y)),col='gray',border='gray')
    }
    for(i in x){
        g <- G[as.character(i),]
        g <- g/max(g)*scale
        y <- names(g)
        y <- y[g> 0.01]
        lines(i+g[y],y,col=col,lwd=lwd)
		lines(rep(i,length(y)),y,col='gray')

    }	
}



distribution = function(class_mins, plus_group,  mu, sigma) {
  first_class = 1;
  last_class = ifelse(plus_group, length(class_mins), length(class_mins)-1);
  result = vector('numeric',length=last_class);

  if (class_mins[first_class] < mu-5*sigma){
    so_far = 0;
  } else {
      so_far = pnorm(class_mins[first_class],mu,sigma);
  }
  for (d in first_class:(last_class-1)){
    if (class_mins[d+1] > mu+5*sigma){
      result[d] = 1-so_far;
      so_far = 1;
    } else if (class_mins[d+1] < mu-5*sigma){
      result[d] = 0;
      so_far = 0;
    } else {
      result[d] = pnorm(class_mins[d+1],mu,sigma) - so_far;
      so_far = so_far+result[d];
    }
  }
  d = last_class;
  if (plus_group){
    result[d] = 1-so_far;
  } else {
    if (class_mins[d+1] > mu+5*sigma){
      result[d] = 1-so_far;
    } else {
        result[d] = pnorm(class_mins[d+1],mu,sigma) - so_far;
    }
  }
  result
 }


get_ALK = function(mu,sigma,age_bins,len_bins) {


  ni = length(mu)
  nj = length(len_bins);
  pdf = matrix(0,nrow=ni,ncol=nj,dimnames=list(rownames=age_bins,colnames=len_bins));
  for(i in 1:ni) 
  {
    for(j in 1:nj) 
    {
      if (j<nj) xs=0.5*(len_bins[j+1]-len_bins[j]);  
      z1=((len_bins[j]-xs)-mu[i])/sigma[i];
      z2=((len_bins[j]+xs)-mu[i])/sigma[i];
      pdf[i,j] = pnorm(z2)- pnorm(z1);
    }
    pdf[i,] =pdf[i,]/sum(pdf[i,]);
  }
  pdf
}


get_LAK = function(natage,ALK) {
	
	LAK = t(ALK)
	for (i in 1:nrow(ALK))
		LAK[,i] = natage[i] * ALK[i,]
	
    for (i in 1:nrow(LAK))
	   LAK[i,] =LAK[i,]/sum(LAK[i,]);
	LAK   
}




get_Numbers_at_Length = function(natage,ALK) {
	natlen = vector('numeric')
	for (j in 1:ncol(ALK))
		natlen[j] = sum(natage*ALK[,j]);
		
    natlen
}

get_Numbers_at_Age = function(natlength,LAK) {
	natage = vector('numeric')
	for (j in 1:ncol(LAK))
		natage[j] = sum(natlength*LAK[,j]);
    natage
}

