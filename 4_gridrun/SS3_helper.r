


get.mpd.lik <- function (lik) {

	#LLH = m$likelihoods_used[c('TOTAL','Survey','Length_comp', 'Tag_comp', 'Tag_negbin','Recruitment','Parm_priors','Parm_devs','Catch','Parm_softbounds'),'values']
	#names(LLH) = c('TOTAL','Survey','Length_comp', 'Tag_comp', 'Tag_negbin','Recruitment','Parm_priors','Parm_devs','Catch','Parm_softbounds')
	lik = setNames(lik$Value,rownames(lik))
	return (lik)
			
} 



get.mpd.quantities <- function (der,current_year) {

            #LLH = m$likelihoods_used['TOTAL','values']
			
            SSB0 <- as.numeric(subset(der, der$Label == "SSB_Virgin")$Value)
            SSBTGT <- as.numeric(subset(der, der$Label == "SSB_Btgt")$Value)
            SSBMSY <- as.numeric(subset(der, der$Label == "SSB_MSY")$Value)
            SSBY <- mean(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$Value))
            SSBYoSSB0 <- SSBY/SSB0
			      SSBYoSSBTGT <- SSBY/SSBTGT
            SSBYoSSBMSY <- SSBY/SSBMSY
  	        FTGT <- as.numeric(der[substring(der$Label, 1, 9) == "annF_Btgt", ]$Value) * length(current_year)	
			      FMSY <- as.numeric(der[substring(der$Label, 1, 8) == "annF_MSY", ]$Value) * length(current_year)
			      FYoFMSY<- mean(as.numeric(der[match(paste0("F_",current_year),der$Label),]$Value)) 
            FYoFTGT <-FYoFMSY * FMSY/ FTGT		
            FY <- FYoFMSY * FMSY 			
            CTGT <- as.numeric(subset(der, der$Label == "Dead_Catch_Btgt")$Value) * length(current_year)
            CMSY <- as.numeric(subset(der, der$Label == "Dead_Catch_MSY")$Value) * length(current_year)
			
			result = c(SSB0,SSBTGT,SSBMSY,SSBY,SSBYoSSB0,SSBYoSSBTGT,SSBYoSSBMSY,FTGT, FMSY, FY, FYoFTGT,FYoFMSY, CTGT,CMSY)
			names(result) = c('SSB0','SSBTGT','SSBMSY','SSBY','SSBYoSSB0','SSBYoSSBTGT','SSBYoSSBMSY','FTGT','FMSY','FY','FYoFTGT','FYoFMSY','CTGT','CMSY')
			return (result)
			
} 

get.mpd.kobe <- function (der,current_year) {

            #LLH = m$likelihoods_used['TOTAL','values']
			result = matrix(0,nrow=14,ncol=4)

			Label = "SSB0"
            Value <- as.numeric(subset(der, der$Label == 'SSB_Virgin')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'SSB_Virgin')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[1,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))

			Label = "SSBTGT"
            Value <- as.numeric(subset(der,der$Label == 'SSB_Btgt')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'SSB_Btgt')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[2,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))

			Label = "SSBMSY"
            Value <- as.numeric(subset(der,der$Label == 'SSB_MSY')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'SSB_MSY')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[3,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))
	
			Label = "SSBY"
            Value <-  mean(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$Value))
			#StdDev <-  sqrt(sum(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$StdDev)^2))/length(current_year)
			StdDev <-  mean(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$StdDev))
			all <- rnorm(500,Value,StdDev)
			result[4,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))

			Label = "SSBYoSSB0"
            Value <-  mean(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$Value))/
							as.numeric(subset(der, der$Label == "SSB_Virgin")$Value)
			result[5,] =c(Value,NA,NA, NA)

			Label = "SSBYoSSBTGT"
            Value <-  mean(as.numeric(der[match(paste0("SSB_",current_year),der$Label),]$Value))/
							as.numeric(subset(der, der$Label == "SSB_Btgt")$Value)
			result[6,] = c(Value,NA,NA, NA)	
			
			Label = "SSBYoSSBMSY"			
            Value <-  mean(as.numeric(der[match(paste0("Bratio_",current_year),der$Label),]$Value))
			StdDev <-  mean(as.numeric(der[match(paste0("Bratio_",current_year),der$Label),]$StdDev))
			all <- rnorm(500,Value,StdDev)
			result[7,] = c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))

			
			Label = "FTGT"
            Value <- as.numeric(subset(der, der$Label == 'annF_Btgt')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'annF_Btgt')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[8,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90)) * length(current_year)
				
			Label = "FMSY"
            Value <- as.numeric(subset(der, der$Label == 'annF_MSY')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'annF_MSY')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[9,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90)) * length(current_year)

			Label = "FY"
            Value <-  mean(as.numeric(der[match(paste0("F_",current_year),der$Label),]$Value)) * as.numeric(subset(der, der$Label == 'annF_MSY')$Value)
			result[10,] =c(Value,NA,NA, NA)	

			Label = "FYoFTGT"
            Value <-  mean(as.numeric(der[match(paste0("F_",current_year),der$Label),]$Value)) * as.numeric(subset(der, der$Label == 'annF_MSY')$Value) / as.numeric(subset(der, der$Label == 'annF_Btgt')$Value) 
			result[11,] = c(Value,NA,NA, NA)	 
	 
			Label = "FYoFMSY"
            Value <-  mean(as.numeric(der[match(paste0("F_",current_year),der$Label),]$Value))
			StdDev <- mean(as.numeric(der[match(paste0("F_",current_year),der$Label),]$StdDev))
			all <- rnorm(500,Value,StdDev)
			result[12,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))
	
	
			Label = "CTGT"
            Value <- as.numeric(subset(der, der$Label == 'Dead_Catch_Btgt')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'Dead_Catch_Btgt')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[13,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))  * length(current_year)

			Label = "CMSY"
            Value <- as.numeric(subset(der, der$Label == 'Dead_Catch_MSY')$Value)
			StdDev <- as.numeric(subset(der, der$Label == 'Dead_Catch_MSY')$StdDev)
			all <- rnorm(500,Value,StdDev)
			result[14,] =c(Value,StdDev,quantile(all,0.10), quantile(all,0.90))  * length(current_year)

	
			rownames(result) = c('SSB0','SSBTGT','SSBMSY','SSBY','SSBYoSSB0','SSBYoSSBTGT','SSBYoSSBMSY','FTGT','FMSY','FY','FYoFTGT','FYoFMSY','CTGT','CMSY')
			colnames(result) =c('Value','StdDev','Lower','Upper')
			result
			
} 



get.mpd.kobe.MVN=function(der,CoVar,current_year,n=500) {
	require(mvtnorm)

	B_B = der[match(paste0("Bratio_",current_year),der$Label),c('Value','StdDev')]
	F_F = der[match(paste0("F_",current_year),der$Label),c('Value','StdDev')]
    EX <-  B_B$Value
    EY <-  F_F$Value
	U = log(EX)
	V = log(EY)
	
	logVarB = B_B$StdDev^2/ B_B$Value^2
	logVarF=  F_F$StdDev^2/ F_F$Value^2
	
	corr = c()
	CovXY = c()
	covUV =c()
	for (k in 1:length(current_year)) {
		corr = c(corr,CoVar[CoVar$label.i %in% paste0("Bratio_",current_year[k]) & CoVar$label.j %in%  paste0( "F_",current_year[k]),]$corr)
		CovXY= c(CovXY,corr[k] *sqrt(logVarB[k]*logVarF[k]))
		covUV = c(covUV,log(1+ CovXY[k])/(EX[k]*EY[k]))
		
	}
	COVM =  matrix(c(mean(logVarB),mean(covUV),mean(covUV),mean(logVarF)) ,ncol=2)
	med = c(mean(EX),mean(EY))
	MVNP =  exp(rmvnorm(n ,mean = log(med) ,sigma =  COVM,method="svd" ) )
	
}




get.grid.quantities = function(modList,current_year) 
{

	# factorList <- array(NA, dim = c(length(modList), length(unlist(strsplit(modList[1], split = "_")))))
	# for (mi in 1:length(modList)) {
		# factors <- strsplit(modList[mi], split = "_")
		# factorList[mi, ] <- unlist(factors)
	# }
    # print(factorList)
    numMod <- length(modList)

    fList <- NULL
    # for (i in 1:ncol(factorList)) {
        # if (length(unique(factorList[, i])) > 1) 
            # fList <- cbind(fList, factorList[, i])
    # }


	SSB0all <- NULL
	SSBTGTall <- NULL
    SSBMSYall <- NULL
	SSBYall <- NULL	
	SSBYoSSB0all <- NULL
	SSBYoSSBTGTall <- NULL
    SSBYoSSBMSYall <- NULL	
	FTGTall <- NULL
	FMSYall <- NULL
	FYoFTGTall <- NULL
    FYoFMSYall <- NULL
	FYall <- NULL		
    CTGTall <- NULL
    CMSYall <- NULL
	

    for (i in 1:length(modList)) {
        print(names(modList)[i])
        m <- modList[[i]]
		SSB0 <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value)
        SSBMSY <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)
		SSBTGT <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Btgt")$Value)
        SSBY <- mean(as.numeric(m$derived_quants[match(paste0("SSB_",current_year),m$derived_quants$Label),]$Value))
        SSBYoSSB0 <- SSBY/SSB0
		SSBYoSSBTGT <- SSBY/SSBTGT
		SSBYoSSBMSY <- SSBY/SSBMSY	

        FMSY <- as.numeric(m$derived_quants[substring(m$derived_quants$Label, 1, 8) == "annF_MSY", ]$Value) * length(current_year)
		FTGT <- as.numeric(m$derived_quants[substring(m$derived_quants$Label, 1, 9) == "annF_Btgt", ]$Value) * length(current_year)
        FYoFTGT <-  mean(as.numeric(m$derived_quants[match(paste0("F_",current_year),m$derived_quants$Label),]$Value)) * FMSY / FTGT
 		FYoFMSY <-  mean(as.numeric(m$derived_quants[match(paste0("F_",current_year),m$derived_quants$Label),]$Value))  
		FY <- FYoFMSY * FMSY 	
        CTGT <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "Dead_Catch_Btgt")$Value) * length(current_year)    
		CMSY <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "Dead_Catch_MSY")$Value) * length(current_year)
		
		SSB0all <- c(SSB0all,SSB0)
		SSBTGTall <- c(SSBTGTall,SSBTGT)		
		SSBMSYall <- c(SSBMSYall,SSBMSY)
		SSBYall <- c(SSBYall, SSBY)	
		SSBYoSSB0all <- c(SSBYoSSB0all, SSBYoSSB0)
		SSBYoSSBTGTall <- c(SSBYoSSBTGTall, SSBYoSSBTGT)		
        SSBYoSSBMSYall <- c(SSBYoSSBMSYall, SSBYoSSBMSY)
		FTGTall <- c(FTGTall,FTGT)		
		FMSYall <- c(FMSYall,FMSY)
        FYoFMSYall <- c(FYoFMSYall, FYoFMSY)
		FYoFTGTall <- c(FYoFTGTall, FYoFTGT)
		FYall <- c(FYall,FY)
        CTGTall <- c(CTGTall, CTGT)		
        CMSYall <- c(CMSYall, CMSY)
	}
		
	return(data.frame(models = names(modList),SSB0all=SSB0all,SSBTGTall=SSBTGTall,SSBMSYall=SSBMSYall, SSBYall=SSBYall,SSBYoSSB0all=SSBYoSSB0all,SSBYoSSBTGTall=SSBYoSSBTGTall,SSBYoSSBMSYall=SSBYoSSBMSYall,
					FTGTall=FTGTall,FMSYall=FMSYall,FYall=FYall,FYoFTGTall=FYoFTGTall,FYoFMSYall=FYoFMSYall,CTGTall=CTGTall,CMSYall=CMSYall))
}

get.grid.kobe <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL, 
	opt = c("skj","h70","h80",'h90','Gest','Gfix','fixed','lorenzen','CPUEbase','CPUEpsls','CPUEmdv'), 
	optWt = c(1,1,1,1,1,1,1,1,1,1,1))

{
    factorList <- array(NA, dim = c(length(mList), length(unlist(strsplit(names(mList)[1], split = "_")))))
    modWtList <- c(1:length(mList)) * 0
    for (mi in 1:length(mList)) {
        factors <- strsplit(names(mList)[mi], split = "_")
        factorList[mi, ] <- unlist(factors)
        modWt <- 1
        for (o in 1:length(opt)) {
            if (opt[o] %in% factorList[mi, ]) 
                modWt <- modWt * optWt[o]
        }
        modWtList[mi] <- modWt
    }
    print(cbind(names(mList), modWtList))
    m <- mList[[1]]
	if(!is.null(initial_qtr)) 
		BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
	else
		BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]

	if (average == TRUE) {
		BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
		BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),mean)
		colnames(BSeries)[1] = 'Label'
	}
	
	current = NULL
	if (is.null(initial_qtr)) {  # year-season model
		current = current_year
	} else {					 # quarterly model
		if (average) {
			if (!is.null(current_year)) {
				current = current_year
			} else {
				current = floor((current_qtr-initial_qtr)/4+initial_year+1/8)
			}
		} else {
			current = current_qtr	
		}
	}
	if(is.null(current)) {
		stop('current = NULL')
	}
    numTime <- nrow(BSeries)
    BMat <- array(NA, dim = c(length(mList), numTime))
    BMatSeries <- array(NA, dim = c(numTime, 6))
    
    FMat <- array(NA, dim = c(length(mList), numTime))
    FMatSeries <- array(NA, dim = c(numTime, 6))

	BoBMSYSeries <- BSeries
    BoBMSYMat <- array(NA, dim = c(length(mList), numTime))
    BoBMSYMatSeries <- array(NA, dim = c(numTime, 6))
    
 	BoBTGTSeries <- BSeries 
    BoBTGTMat <- array(NA, dim = c(length(mList), numTime))
    BoBTGTMatSeries <- array(NA, dim = c(numTime, 6))	

	BoB0Series <- BSeries
    BoB0Mat <- array(NA, dim = c(length(mList), numTime))
    BoB0MatSeries <- array(NA, dim = c(numTime, 6))
    
	FoFMSYSeries <- BSeries
    FoFMSYMat <- BMat
    FoFMSYMatSeries <- BMatSeries

	FoFTGTSeries <- BSeries
    FoFTGTMat <- BMat
    FoFTGTMatSeries <- BMatSeries	

	B0Mat <- array(NA, dim = c(length(mList)))	
	BMSYMat <- array(NA, dim = c(length(mList)))
	BTGTMat <- array(NA, dim = c(length(mList)))	
	FMSYMat <- array(NA, dim = c(length(mList)))
	FTGTMat <- array(NA, dim = c(length(mList)))
    CMSYMat <- array(NA, dim = c(length(mList)))
    CTGTMat <- array(NA, dim = c(length(mList)))
	
    for (mi in 1:length(mList)) {
        print(names(mList)[mi])
        m <- mList[[mi]]
		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}		
		if(!is.null(initial_qtr)) 
			FSeries <- m$derived_quants[match(paste("F_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			FSeries <- m$derived_quants[match(paste("F_",initial_year:current_year,sep=""),m$derived_quants$Label),]

		if (average == TRUE) {
			FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
			FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
			colnames(FSeries)[1] = 'Label'
		}
		
        yearLab <- as.numeric(substring(BSeries$Label, 5))
 
 		BMat[mi, ] <- BSeries[, 2]
	    BoB0Series[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value)      
		BoBTGTSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Btgt")$Value) 		
        BoBMSYSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)
        BoB0Mat[mi, ] <- BoB0Series[, 2]
		BoBTGTMat[mi, ] <- BoBTGTSeries[, 2]
 		BoBMSYMat[mi, ] <- BoBMSYSeries[, 2]
		
		FoFTGTSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_MSY")$Value)/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_Btgt")$Value) 
        FoFMSYSeries[, 2] <- FSeries[, 2]		
        FSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_MSY")$Value)      
        FoFTGTMat[mi, ] <- FoFTGTSeries[, 2]
		FoFMSYMat[mi, ] <- FoFMSYSeries[, 2]		
 		FMat[mi, ] <- FSeries[, 2]

		B0Mat[mi] <- m$derived_quants[m$derived_quants$Label == "SSB_Virgin", ]$Value 
		BTGTMat[mi] <- m$derived_quants[m$derived_quants$Label == "SSB_Btgt", ]$Value 
		BMSYMat[mi] <- m$derived_quants[m$derived_quants$Label == "SSB_MSY", ]$Value 
		FTGTMat[mi] <- m$derived_quants[m$derived_quants$Label == "annF_Btgt", ]$Value     
		FMSYMat[mi] <- m$derived_quants[m$derived_quants$Label == "annF_MSY", ]$Value         	
		CMSYMat[mi] <- m$derived_quants[m$derived_quants$Label == "Dead_Catch_MSY", ]$Value 
		CTGTMat[mi] <- m$derived_quants[m$derived_quants$Label == "Dead_Catch_Btgt", ]$Value 
    }
   mat = matrix(0,nrow=14,ncol=6)
   
   for (t in 1:numTime) {
		BMatSeries[t, 1] <- weighted.mean(BMat[, t], w = modWtList)
        BMatSeries[t, 2] <- min(BMat[, t])
        BMatSeries[t, 3] <- max(BMat[, t])
        tmpSort <- sort(BMat[, t])
        modWtSort <- modWtList[order(BMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        BoB0MatSeries[t, 1] <- weighted.mean(BoB0Mat[, t], w = modWtList)
        BoB0MatSeries[t, 2] <- min(BoB0Mat[, t])
        BoB0MatSeries[t, 3] <- max(BoB0Mat[, t])
        tmpSort <- sort(BoB0Mat[, t])
        modWtSort <- modWtList[order(BoB0Mat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoB0MatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoB0MatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoB0MatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        BoBTGTMatSeries[t, 1] <- weighted.mean(BoBTGTMat[, t], w = modWtList)
        BoBTGTMatSeries[t, 2] <- min(BoBTGTMat[, t])
        BoBTGTMatSeries[t, 3] <- max(BoBTGTMat[, t])
        tmpSort <- sort(BoBTGTMat[, t])
        modWtSort <- modWtList[order(BoBTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
   
        BoBMSYMatSeries[t, 1] <- weighted.mean(BoBMSYMat[, t], w = modWtList)
        BoBMSYMatSeries[t, 2] <- min(BoBMSYMat[, t])
        BoBMSYMatSeries[t, 3] <- max(BoBMSYMat[, t])
        tmpSort <- sort(BoBMSYMat[, t])
        modWtSort <- modWtList[order(BoBMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
				 
        FoFTGTMatSeries[t, 1] <- weighted.mean(FoFTGTMat[, t], w = modWtList)
        FoFTGTMatSeries[t, 2] <- min(FoFTGTMat[, t])
        FoFTGTMatSeries[t, 3] <- max(FoFTGTMat[, t])
        tmpSort <- sort(FoFTGTMat[, t])
        modWtSort <- modWtList[order(FoFTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
 
        FoFMSYMatSeries[t, 1] <- weighted.mean(FoFMSYMat[, t], w = modWtList)
        FoFMSYMatSeries[t, 2] <- min(FoFMSYMat[, t])
        FoFMSYMatSeries[t, 3] <- max(FoFMSYMat[, t])
        tmpSort <- sort(FoFMSYMat[, t])
        modWtSort <- modWtList[order(FoFMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

		FMatSeries[t, 1] <- weighted.mean(FMat[, t], w = modWtList)
        FMatSeries[t, 2] <- min(FMat[, t])
        FMatSeries[t, 3] <- max(FMat[, t])
        tmpSort <- sort(FMat[, t])
        modWtSort <- modWtList[order(FMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
	

        if (yearLab[t] == current) {
		
			mat[4,]= BMatSeries[t, ]	
			mat[5,]= BoB0MatSeries[t, ]	
			mat[6,]= BoBTGTMatSeries[t, ]
			mat[7,]= BoBMSYMatSeries[t, ]

			mat[10,]= FMatSeries[t, ]
			mat[11,]= FoFTGTMatSeries[t, ]			
			mat[12,]= FoFMSYMatSeries[t, ]
			
        }
    }
    cat("B0 ")
    cat(c(weighted.mean(B0Mat, w = modWtList), range(B0Mat)))
	cat(" ")
    B0Sort <- sort(B0Mat)
    modWtSort <- modWtList[order(B0Mat)]
    B0cum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(B0Sort[B0cum > 0.05][1], B0Sort[B0cum > 0.5][1],  B0Sort[B0cum > 0.95][1]))
	mat[1,]= c(weighted.mean(B0Mat, w = modWtList), range(B0Mat),B0Sort[B0cum > 0.05][1], B0Sort[B0cum > 0.5][1],  B0Sort[B0cum > 0.95][1])
	cat('\n')

    cat("BTGT ")
    cat(c(weighted.mean(BTGTMat, w = modWtList), range(BTGTMat)))
	cat(" ")
    BTGTSort <- sort(BTGTMat)
    modWtSort <- modWtList[order(BTGTMat)]
    BTGTcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(BTGTSort[BTGTcum > 0.05][1], BTGTSort[BTGTcum > 0.5][1],  BTGTSort[BTGTcum > 0.95][1]))
	mat[2,]= c(weighted.mean(BTGTMat, w = modWtList), range(BTGTMat),BTGTSort[BTGTcum > 0.05][1], BTGTSort[BTGTcum > 0.5][1],  BTGTSort[BTGTcum > 0.95][1])
	cat('\n')
	
    cat("BMSY ")
    cat(c(weighted.mean(BMSYMat, w = modWtList), range(BMSYMat)))
	cat(" ")
    BMSYSort <- sort(BMSYMat)
    modWtSort <- modWtList[order(BMSYMat)]
    BMSYcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(BMSYSort[BMSYcum > 0.05][1], BMSYSort[BMSYcum > 0.5][1],  BMSYSort[BMSYcum > 0.95][1]))
	mat[3,]= c(weighted.mean(BMSYMat, w = modWtList), range(BMSYMat),BMSYSort[BMSYcum > 0.05][1], BMSYSort[BMSYcum > 0.5][1],  BMSYSort[BMSYcum > 0.95][1])
	cat('\n')

	
    cat("FTGT ")
    cat(c(weighted.mean(FTGTMat, w = modWtList), range(FTGTMat)))
	cat(" ")
    FTGTSort <- sort(FTGTMat)
    modWtSort <- modWtList[order(FTGTMat)]
    FTGTcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(FTGTSort[FTGTcum > 0.05][1], FTGTSort[FTGTcum > 0.5][1],  FTGTSort[FTGTcum > 0.95][1]))
	mat[8,]= c(weighted.mean(FTGTMat, w = modWtList), range(FTGTMat),FTGTSort[FTGTcum > 0.05][1], FTGTSort[FTGTcum > 0.5][1],  FTGTSort[FTGTcum > 0.95][1])
	cat('\n')
	
    cat("FMSY ")
    cat(c(weighted.mean(FMSYMat, w = modWtList), range(FMSYMat)))
	cat(" ")
    FMSYSort <- sort(FMSYMat)
    modWtSort <- modWtList[order(FMSYMat)]
    FMSYcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(FMSYSort[FMSYcum > 0.05][1], FMSYSort[FMSYcum > 0.5][1],  FMSYSort[FMSYcum > 0.95][1]))
	mat[9,]= c(weighted.mean(FMSYMat, w = modWtList), range(FMSYMat),FMSYSort[FMSYcum > 0.05][1], FMSYSort[FMSYcum > 0.5][1],  FMSYSort[FMSYcum > 0.95][1])
	cat('\n')

    cat("CTGT ")
    cat(c(weighted.mean(CTGTMat, w = modWtList), range(CTGTMat)))
	cat(" ")
    CTGTSort <- sort(CTGTMat)
    modWtSort <- modWtList[order(CTGTMat)]
    CTGTcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(CTGTSort[CTGTcum > 0.05][1], CTGTSort[CTGTcum > 0.5][1],  CTGTSort[CTGTcum > 0.95][1]))
	mat[13,]= c(weighted.mean(CTGTMat, w = modWtList), range(CTGTMat),CTGTSort[CTGTcum > 0.05][1], CTGTSort[CTGTcum > 0.5][1],  CTGTSort[CTGTcum > 0.95][1])
 
    cat("CMSY ")
    cat(c(weighted.mean(CMSYMat, w = modWtList), range(CMSYMat)))
	cat(" ")
    CMSYSort <- sort(CMSYMat)
    modWtSort <- modWtList[order(CMSYMat)]
    CMSYcum <- cumsum(modWtSort)/sum(modWtSort)
    cat(c(CMSYSort[CMSYcum > 0.05][1], CMSYSort[CMSYcum > 0.5][1],  CMSYSort[CMSYcum > 0.95][1]))
	mat[14,]= c(weighted.mean(CMSYMat, w = modWtList), range(CMSYMat),CMSYSort[CMSYcum > 0.05][1], CMSYSort[CMSYcum > 0.5][1],  CMSYSort[CMSYcum > 0.95][1])
	
		
	cat('\n')       
	rownames(mat) =  c('SSB0','SSBTGT','SSBMSY','SSBY','SSBYoSSB0','SSBYoSSBTGT','SSBYoSSBMSY','FTGT','FMSY','FY','FYoFTGT','FYoFMSY','CTGT','CMSY') 
	colnames(mat) = c('mean','min','max','lower','median','upper')
    return(mat)
}


 get.grid.k2sm <- function (mList = gridList, proj = c(2016:2025), average=F,initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,BLIM =0.5, FLIM=1.0,  
                            opt = c("skj","h70","h80",'h90','Gest','Gfix','fixed','lorenzen','CPUEbase','CPUEpsls','CPUEmdv'), 
                            optWt = c(1,1,1,1,1,1,1,1,1,1,1))

{
    factorList <- array(NA, dim = c(length(mList), length(unlist(strsplit(names(mList)[1], split = "_")))))
    modWtList <- c(1:length(mList)) * 0
    for (mi in 1:length(mList)) {
        factors <- strsplit(names(mList)[mi], split = "_")
        factorList[mi, ] <- unlist(factors)
        modWt <- 1
        for (o in 1:length(opt)) {
            if (opt[o] %in% factorList[mi, ]) 
                modWt <- modWt * optWt[o]
        }
        modWtList[mi] <- modWt
    }
    print(cbind(names(mList), modWtList))
    m <- mList[[1]]
    numProj <- 7

	K2SMB <- array(0, dim = c(numProj,length(proj)))
	K2SMF <- array(0, dim = c(numProj,length(proj)))	
	K2SMB2 <- array(0, dim = c(numProj,length(proj)))
	K2SMF2 <- array(0, dim = c(numProj,length(proj)))	
	K2SMgreen <- array(0, dim = c(numProj,length(proj)))
	
	for (pi in 1:numProj) {
		k2smMatB <- array(0, dim = c(length(mList), length(proj)))
		k2smMatF <- array(0, dim = c(length(mList), length(proj)))	
		k2smMatB2 <- array(0, dim = c(length(mList), length(proj)))
		k2smMatF2 <- array(0, dim = c(length(mList), length(proj)))		
		k2smMatgreen <- array(0, dim = c(length(mList), length(proj)))		
        for (yi in 1:length(proj)) {
			for (mi in 1:length(mList)) {	
                p <- mList[[mi]]$project		
				if(!is.null(initial_qtr)) {
					BSeries <- p[[pi]][match(paste("SSB_",initial_qtr:current_qtr,sep=""),p[[pi]]$Label),]
					FSeries <- p[[pi]][match(paste("F_",initial_qtr:current_qtr,sep=""),p[[pi]]$Label),]
				} else {
					BSeries <- p[[pi]][match(paste("SSB_",initial_year:current_year,sep=""),p[[pi]]$Label),]
					FSeries <- p[[pi]][match(paste("F_",initial_year:current_year,sep=""),p[[pi]]$Label),]
				}
				if (average == TRUE) {
					BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
					BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
					colnames(BSeries)[1] = 'Label'
					FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
					FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
					colnames(FSeries)[1] = 'Label'	
				}			
                BIndex <- subset(BSeries, BSeries$Label == "SSB_" %&% proj[yi])$Value/subset(p[[pi]], p[[pi]]$Label == "SSB_BMSY")$Value
                FIndex <- subset(FSeries, FSeries$Label == "F_" %&% proj[yi])$Value
				
                if (BIndex < 1 | is.na(BIndex)) 
                  k2smMatB[mi, yi] <- modWtList[mi]
                if (FIndex > 1 | is.na(FIndex)) 
                  k2smMatF[mi, yi] <- modWtList[mi]
				if (BIndex <BLIM  | is.na(BIndex)) 
                  k2smMatB2[mi, yi] <- modWtList[mi]
				if (FIndex > FLIM | is.na(FIndex)) 
                  k2smMatF2[mi, yi] <- modWtList[mi]	
				if(BIndex >= 1 & FIndex <=1 & !is.na(BIndex) & !is.na(FIndex))
					k2smMatgreen[mi, yi] <- modWtList[mi]	
            }
        }
        k2smB <- colSums(k2smMatB)/sum(modWtList)
        k2smF <- colSums(k2smMatF)/sum(modWtList)
        k2smB2 <- colSums(k2smMatB2)/sum(modWtList)
        k2smF2 <- colSums(k2smMatF2)/sum(modWtList)
        k2smgreen <- colSums(k2smMatgreen)/sum(modWtList)
			
		K2SMB[pi,]  = k2smB
		K2SMF[pi,]  = k2smF	
		K2SMB2[pi,]  = k2smB2
		K2SMF2[pi,]  = k2smF2	
		K2SMgreen[pi,]  = k2smgreen	
			
    }	
	return(list(K2SMB=K2SMB,K2SMF=K2SMF,K2SMB2=K2SMB2,K2SMF2=K2SMF2,K2SMgreen=K2SMgreen))
}


plot.grid.timeseries <- function (mList = gridList,CSeries,average=F,initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,  
                                  opt = c("skj","h70","h80",'h90','Gest','Gfix','fixed','lorenzen','CPUEbase','CPUEpsls','CPUEmdv'), 
                                  optWt = c(1,1,1,1,1,1,1,1,1,1,1))

{
    factorList <- array(NA, dim = c(length(mList), length(unlist(strsplit(names(mList)[1], split = "_")))))
    modWtList <- c(1:length(mList)) * 0
    for (mi in 1:length(mList)) {
        factors <- strsplit(names(mList)[mi], split = "_")
        factorList[mi, ] <- unlist(factors)
        modWt <- 1
        for (o in 1:length(opt)) {
            if (opt[o] %in% factorList[mi, ]) 
                modWt <- modWt * optWt[o]
        }
        modWtList[mi] <- modWt
    }
    print(cbind(names(mList), modWtList))
    m <- mList[[1]]
	if(!is.null(initial_qtr)) 
		BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
	else
		BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
	if (average == TRUE) {
		BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
		CSeries=tapply(CSeries,BSeries$Label,mean)
		BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
		colnames(BSeries)[1] = 'Label'
	}

    numTime <- nrow(BSeries)
    BMat <- array(NA, dim = c(length(mList), numTime))
    BMatSeries <- array(NA, dim = c(numTime, 6))
    
	BoBMSYSeries <- BSeries
    BoBMSYMat <- array(NA, dim = c(length(mList), numTime))
    BoBMSYMatSeries <- array(NA, dim = c(numTime, 6))
    
 	BoBTGTSeries <- BSeries 
    BoBTGTMat <- array(NA, dim = c(length(mList), numTime))
    BoBTGTMatSeries <- array(NA, dim = c(numTime, 6))	

	BoB0Series <- BSeries
    BoB0Mat <- array(NA, dim = c(length(mList), numTime))
    BoB0MatSeries <- array(NA, dim = c(numTime, 6))

    FMat <- array(NA, dim = c(length(mList), numTime))
    FMatSeries <- array(NA, dim = c(numTime, 6))
    
	FoFMSYSeries <- BSeries
    FoFMSYMat <- BMat
    FoFMSYMatSeries <- BMatSeries

	FoFTGTSeries <- BSeries
    FoFTGTMat <- BMat
    FoFTGTMatSeries <- BMatSeries	

	CTGTMat <- array(NA, dim = c(length(mList)))
    CMSYMat <- array(NA, dim = c(length(mList)))
	
	
    for (mi in 1:length(mList)) {
        print(names(mList)[mi])
        m <- mList[[mi]]
		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}	
		if(!is.null(initial_qtr)) 
			FSeries <- m$derived_quants[match(paste("F_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			FSeries <- m$derived_quants[match(paste("F_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
			FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
			colnames(FSeries)[1] = 'Label'
		}		
        yearLab <- as.numeric(substring(BSeries$Label, 5))
		
        BoB0Series[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value)
        BoBMSYSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)
        BoBTGTSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Btgt")$Value)
        BMat[mi, ] <- BSeries[, 2]
		BoB0Mat[mi, ] <- BoB0Series[, 2]		
        BoBMSYMat[mi, ] <- BoBMSYSeries[, 2]
        BoBTGTMat[mi, ] <- BoBTGTSeries[, 2]
		
        FoFMSYSeries[, 2] <- FSeries[, 2] 
		FoFTGTSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_MSY")$Value)/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_Btgt")$Value)
        FSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_BMSY")$Value)      
		FoFMSYMat[mi, ] <- FoFMSYSeries[, 2]
        FoFTGTMat[mi, ] <- FoFTGTSeries[, 2]
 		FMat[mi, ] <- FSeries[, 2]
		CTGTMat[mi] <- m$derived_quants[m$derived_quants$Label == "Dead_Catch_Btgt", ]$Value
		CMSYMat[mi] <- m$derived_quants[m$derived_quants$Label == "Dead_Catch_MSY", ]$Value
     }
	  
    for (t in 1:numTime) {
		BMatSeries[t, 1] <- weighted.mean(BMat[, t], w = modWtList)
        BMatSeries[t, 2] <- min(BMat[, t])
        BMatSeries[t, 3] <- max(BMat[, t])
        tmpSort <- sort(BMat[, t])
        modWtSort <- modWtList[order(BMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        BoB0MatSeries[t, 1] <- weighted.mean(BoB0Mat[, t], w = modWtList)
        BoB0MatSeries[t, 2] <- min(BoB0Mat[, t])
        BoB0MatSeries[t, 3] <- max(BoB0Mat[, t])
        tmpSort <- sort(BoB0Mat[, t])
        modWtSort <- modWtList[order(BoB0Mat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoB0MatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoB0MatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoB0MatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
   
        BoBMSYMatSeries[t, 1] <- weighted.mean(BoBMSYMat[, t], w = modWtList)
        BoBMSYMatSeries[t, 2] <- min(BoBMSYMat[, t])
        BoBMSYMatSeries[t, 3] <- max(BoBMSYMat[, t])
        tmpSort <- sort(BoBMSYMat[, t])
        modWtSort <- modWtList[order(BoBMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
				
        BoBTGTMatSeries[t, 1] <- weighted.mean(BoBTGTMat[, t], w = modWtList)
        BoBTGTMatSeries[t, 2] <- min(BoBTGTMat[, t])
        BoBTGTMatSeries[t, 3] <- max(BoBTGTMat[, t])
        tmpSort <- sort(BoBTGTMat[, t])
        modWtSort <- modWtList[order(BoBTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

		FMatSeries[t, 1] <- weighted.mean(FMat[, t], w = modWtList)
        FMatSeries[t, 2] <- min(FMat[, t])
        FMatSeries[t, 3] <- max(FMat[, t])
        tmpSort <- sort(FMat[, t])
        modWtSort <- modWtList[order(FMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
   		
        FoFMSYMatSeries[t, 1] <- weighted.mean(FoFMSYMat[, t], w = modWtList)
        FoFMSYMatSeries[t, 2] <- min(FoFMSYMat[, t])
        FoFMSYMatSeries[t, 3] <- max(FoFMSYMat[, t])
        tmpSort <- sort(FoFMSYMat[, t])
        modWtSort <- modWtList[order(FoFMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

	
        FoFTGTMatSeries[t, 1] <- weighted.mean(FoFTGTMat[, t], w = modWtList)
        FoFTGTMatSeries[t, 2] <- min(FoFTGTMat[, t])
        FoFTGTMatSeries[t, 3] <- max(FoFTGTMat[, t])
        tmpSort <- sort(FoFTGTMat[, t])
        modWtSort <- modWtList[order(FoFTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]
		

    }
    CTGTSort <- sort(CTGTMat)
    modWtSort <- modWtList[order(CTGTMat)]
    CTGTcum <- cumsum(modWtSort)/sum(modWtSort)
    max.y = max(c(1.1*max(CSeries),CTGTSort[CTGTcum > 0.95][1]),na.rm=T)

    CMSYSort <- sort(CMSYMat)
    modWtSort <- modWtList[order(CMSYMat)]
    CMSYcum <- cumsum(modWtSort)/sum(modWtSort)
    max.y = max(c(1.1*max(CSeries),CMSYSort[CMSYcum > 0.95][1]),na.rm=T)

		
	if(is.null(initial_qtr)) {
		yearLab = yearLab
		current = current_year	
	} else {
		if (average) {
			yearLab = yearLab
			if (!is.null(current_qtr)) {
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			} else {
				current = current_year
			}
		} else {
			yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
			current = (current_qtr - initial_qtr)/4+initial_year+1/8
		}
	}
	
	if (is.null(current)) {
		stop ('current = null')
	}
		
    plot(x=yearLab,rep(0,numTime),type="n",ylim=c(0,max.y), bty="l", main=paste("Catch"), ylab="Catch in t")
    rect(yearLab[1],CMSYSort[CMSYcum > 0.05][1],yearLab[numTime], CMSYSort[CMSYcum > 0.95][1],col="lightgray", border=NA)
    #lines(x=c(yearLab[1],yearLab[numTime]),y=c(MSYSort[MSYcum > 0.50][1],MSYSort[MSYcum > 0.50][1]),lty="dashed", col="black", lwd=1.5)
    lines(x=yearLab, y=CSeries, lwd=2)
    text("MSY",x=yearLab[numTime]-10.5, y=c(CMSYSort[CMSYcum > 0.50][1]+CMSYSort[CMSYcum > 0.50][1]*0.1))
    #lines(c(current, current), c(-1, max.y), col = 2, lty = 1)

    #plot(yearLab, BMatSeries[, 5]/1000, ylim=c(0, max(BMatSeries))/1000,main = "SSB", ylab = "SSB", xlab = "", type = "l", col = 1, lwd = 2)
    #lines(yearLab, BMatSeries[, 4]/1000, col = 1, lty = 1, lwd = 1)
    #lines(yearLab, BMatSeries[, 6]/1000, col = 1, lty = 1, lwd = 1)
    #abline(h = c(0.2,0.4,1),col = 2, lty = 2)
    #lines(c(current, current), c(-1, max(BMatSeries)), col = 2, lty = 1)
	
	
    plot(yearLab, BoB0MatSeries[, 5], ylim = c(0, 1.2), main = "SB/SB0", ylab = "SB/SB0", xlab = "", type = "l", col = 1, lwd = 2)
    lines(yearLab, BoB0MatSeries[, 4], col = 1, lty = 1, lwd = 1)
    lines(yearLab, BoB0MatSeries[, 6], col = 1, lty = 1, lwd = 1)
	abline(h = c(0.4),col = 2, lty = 2)
    #lines(c(current, current), c(-1, 10), col = 2, lty = 1)
	
    plot(yearLab, BoBMSYMatSeries[, 5], ylim = c(0, 6), main = "SB/SBMSY", ylab = "SB/SBMSY", xlab = "", type = "l", col = 1, lwd = 2)
    lines(yearLab, BoBMSYMatSeries[, 4], col = 1, lty = 1, lwd = 1)
    lines(yearLab, BoBMSYMatSeries[, 6], col = 1, lty = 1, lwd = 1)
    #lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
	abline(h = 1,col = 2, lty = 2)
    #lines(c(current, current), c(-1, 10), col = 2, lty = 1)
   
 
    plot(yearLab, FoFMSYMatSeries[, 5], ylim = c(0, 2), main = "F/FMSY", ylab = "F/FMSY", xlab = "", type = "l", col = 1, lwd = 2)
    lines(yearLab, FoFMSYMatSeries[, 4], col = 1, lty = 1, lwd = 1)
    lines(yearLab, FoFMSYMatSeries[, 6], col = 1, lty = 1, lwd = 1)
    #lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
	abline(h = 1,col = 2, lty = 3)
    #lines(c(current, current), c(-1, 10), col = 2, lty = 1)
  
    #plot(yearLab, BoBTGTMatSeries[, 5], ylim = c(0, 4), main = "SSB/SSBtgt", ylab = "SSB/SSBtgt", xlab = "", type = "l", col = 1, lwd = 2)
    #lines(yearLab, BoBTGTMatSeries[, 4], col = 1, lty = 1, lwd = 1)
    #lines(yearLab, BoBTGTMatSeries[, 6], col = 1, lty = 1, lwd = 1)
    #lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
	#abline(h = 1,col = 2, lty = 1)
    #lines(c(current, current), c(-1, 10), col = 2, lty = 1)
   
 
    #plot(yearLab, FoFTGTMatSeries[, 5], ylim = c(0, 2), main = "F/Ftgt", ylab = "F/Ftgt", xlab = "", type = "l", col = 1, lwd = 2)
    #lines(yearLab, FoFTGTMatSeries[, 4], col = 1, lty = 1, lwd = 1)
    #lines(yearLab, FoFTGTMatSeries[, 6], col = 1, lty = 1, lwd = 1)
    #lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
	#abline(h = 1,col = 2, lty = 1)
    #lines(c(current, current), c(-1, 10), col = 2, lty = 1)
  
}

plot.grid.kobe <- function (mList = gridList,average=F,initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,
                            opt = c("skj","h70","h80",'h90','Gest','Gfix','fixed','lorenzen','CPUEbase','CPUEpsls','CPUEmdv'), 
                            optWt = c(1,1,1,1,1,1,1,1,1,1,1),
	nbins = c(20,20), binRange = c(-1,5),xlim=c(0,6),ylim=c(0,2))
{
    factorList <- array(NA, dim = c(length(mList), length(unlist(strsplit(names(mList)[1], split = "_")))))
    modWtList <- c(1:length(mList)) * 0
    for (mi in 1:length(mList)) {
        factors <- strsplit(names(mList)[mi], split = "_")
        factorList[mi, ] <- unlist(factors)
        modWt <- 1
        for (o in 1:length(opt)) {
            if (opt[o] %in% factorList[mi, ]) 
                modWt <- modWt * optWt[o]
        }
        modWtList[mi] <- modWt
    }
    print(cbind(names(mList), modWtList))
    m <- mList[[1]]
	if(!is.null(initial_qtr)) 
		BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
	else
		BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
	if (average == TRUE) {
		BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
		BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
		colnames(BSeries)[1] = 'Label'
	}
 	
    numTime <- nrow(BSeries)
    BMat <- array(NA, dim = c(length(mList), numTime))
    BMatSeries <- array(NA, dim = c(numTime, 6))
    BoBMSYSeries <- BSeries
    BoBMSYMat <- array(NA, dim = c(length(mList), numTime))
    BoBMSYMatSeries <- array(NA, dim = c(numTime, 6))
    BoBTGTSeries <- BSeries
    BoBTGTMat <- array(NA, dim = c(length(mList), numTime))
    BoBTGTMatSeries <- array(NA, dim = c(numTime, 6))
	
    FMat <- BMat
    FMatSeries <- BMatSeries
    FoFMSYSeries <- BSeries
    FoFMSYMat <- array(NA, dim = c(length(mList), numTime))
    FoFMSYMatSeries <- array(NA, dim = c(numTime, 6))
    FoFTGTSeries <- BSeries
    FoFTGTMat <- array(NA, dim = c(length(mList), numTime))
    FoFTGTMatSeries <- array(NA, dim = c(numTime, 6))

 
    for (mi in 1:length(mList)) {
        print(names(mList)[mi])
        m <- mList[[mi]]
		if(!is.null(initial_qtr)) {
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
			FSeries <- m$derived_quants[match(paste("F_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		} else {
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
			FSeries <- m$derived_quants[match(paste("F_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		}	
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
			FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
			FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
			colnames(FSeries)[1] = 'Label'			
		}			
		yearLab <- as.numeric(substring(BSeries$Label, 5))
        BoBMSYSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)
        BoBTGTSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Btgt")$Value)
        BoBMSYMat[mi, ] <- BoBMSYSeries[, 2]
        BoBTGTMat[mi, ] <- BoBTGTSeries[, 2]
		
        FoFMSYSeries[, 2] <- FSeries[, 2] 
		FoFTGTSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_MSY")$Value)/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_Btgt")$Value)
		FoFMSYMat[mi, ] <- FoFMSYSeries[, 2]
        FoFTGTMat[mi, ] <- FoFTGTSeries[, 2]
		
    }
	
	
	current = NULL
	if (is.null(initial_qtr)) {  # year-season model
		current = current_year
	} else {					 # quarterly model
		if (average) {
			if (!is.null(current_year)) {
				current = current_year
			} else {
				current = floor((current_qtr-initial_qtr)/4+initial_year+1/8)
			}
		} else {
			current = current_qtr	
		}
	}
	if(is.null(current)) {
		stop('current = NULL')
	}	
	
    for (t in 1:numTime) {
        BoBMSYMatSeries[t, 1] <- weighted.mean(BoBMSYMat[, t], w = modWtList)
        BoBMSYMatSeries[t, 2] <- min(BoBMSYMat[, t])
        BoBMSYMatSeries[t, 3] <- max(BoBMSYMat[, t])
        tmpSort <- sort(BoBMSYMat[, t])
        modWtSort <- modWtList[order(BoBMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        BoBTGTMatSeries[t, 1] <- weighted.mean(BoBTGTMat[, t], w = modWtList)
        BoBTGTMatSeries[t, 2] <- min(BoBTGTMat[, t])
        BoBTGTMatSeries[t, 3] <- max(BoBTGTMat[, t])
        tmpSort <- sort(BoBTGTMat[, t])
        modWtSort <- modWtList[order(BoBTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        BoBTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        BoBTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        BoBTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        FoFMSYMatSeries[t, 1] <- weighted.mean(FoFMSYMat[, t], w = modWtList)
        FoFMSYMatSeries[t, 2] <- min(FoFMSYMat[, t])
        FoFMSYMatSeries[t, 3] <- max(FoFMSYMat[, t])
        tmpSort <- sort(FoFMSYMat[, t])
        modWtSort <- modWtList[order(FoFMSYMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFMSYMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFMSYMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFMSYMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]

        FoFTGTMatSeries[t, 1] <- weighted.mean(FoFTGTMat[, t], w = modWtList)
        FoFTGTMatSeries[t, 2] <- min(FoFTGTMat[, t])
        FoFTGTMatSeries[t, 3] <- max(FoFTGTMat[, t])
        tmpSort <- sort(FoFTGTMat[, t])
        modWtSort <- modWtList[order(FoFTGTMat[, t])]
        tmpcum <- cumsum(modWtSort)/sum(modWtSort)
        FoFTGTMatSeries[t, 4] <- tmpSort[tmpcum > 0.05][1]
        FoFTGTMatSeries[t, 5] <- tmpSort[tmpcum > 0.5][1]
        FoFTGTMatSeries[t, 6] <- tmpSort[tmpcum > 0.95][1]


    }


	BoBMat = BoBTGTMat
	BoBMatSeries = BoBMSYMatSeries
	FoFMat = FoFTGTMat
	FoFMatSeries = FoFMSYMatSeries
	xlab = "SB/SBmsy"
	ylab = "F/Fmsy"
	
	#plot(BoBMSYMatSeries[, 5], FoFMSYMatSeries[, 5], xlim = xlim, ylim = ylim, type = "n", xlab = "SSB/SSBMSY", ylab = "F/FMSY", xaxs = "i", yaxs = "i",cex.lab=1.4)
	 plot(BoBMatSeries[, 5], FoFMatSeries[, 5], xlim = xlim, ylim = ylim, type = "n", xlab = xlab, ylab = ylab, xaxs = "i", yaxs = "i",cex.lab=1.4)
     polygon(x = c(0, 1, 1, 0, 0), y = c(0, 0, 1, 1, 0), col = "yellow")
     polygon(x = c(0, 1, 1, 0, 0), y = c(1, 1, 11, 11, 1), col = "red")
     polygon(x = c(1, 11, 11, 1, 1), y = c(1, 1, 11, 11, 1), col = "orange")
     polygon(x = c(1, 11, 11, 1, 1), y = c(0, 0, 1, 1, 0), col = "green")
     points(BoBMat[, yearLab == current], FoFMat[, yearLab == current],  pch = 16, cex = 2.5, col = 'slate grey')
     points(BoBMatSeries[nrow(BoBMatSeries), 5], FoFMatSeries[nrow(FoFMatSeries), 5], type = "o", lwd = 1, pch = 19, cex = 2.5, col = "white")
     lines(c(1, 1), c(0, 100))
     lines(c(0, 100), c(1, 1))
 
	x <- BoBMat[, yearLab == (current)]
    y <- FoFMat[, yearLab == current]
    wt <- modWtList/sum(modWtList)
	
    hist2dWt.f <- function(x, y, wt = 1, nbins = c(100, 100), binRange = c(0, 3), same.scale = TRUE, show = TRUE, col = grey(c(1000:1)/1000), ...) {
        x.cuts <- seq(from = binRange[1], to = binRange[2], length = nbins[1] + 1)
        y.cuts <- seq(from = binRange[1], to = binRange[2], length = nbins[2] + 1)
        index.x <- cut(x, x.cuts, include.lowest = TRUE)
        index.y <- cut(y, y.cuts, include.lowest = TRUE)
        m <- matrix(0, nrow = nbins[1], ncol = nbins[2], dimnames = list(levels(index.x), levels(index.y)))
        for (i in 1:length(index.x)) m[index.x[i], index.y[i]] <- m[index.x[i], index.y[i]] + wt[i]
        xBinWidth <- (binRange[2] - binRange[1])/nbins[1]
        xvals <- x.cuts[1:nbins[1]] + 0.5 * xBinWidth
        yvals <- y.cuts[1:nbins[2]] + 0.5 * xBinWidth
        if (show) {
            image(xvals, yvals, m, col = col, ...)
        }
        invisible(list(counts = m, x = xvals, y = yvals))
    }
	
   # h2d <- hist2dWt.f(x, y, wt = wt, nbins = nbins, binRange = binRange, show = F)
   # z<- as.vector(h2d$counts)
   # z <- predictSurface(Tps(as.matrix(expand.grid(x=h2d$x,y=h2d$y)),z ))     
   # z$z <- z$z/Max(z$z)
   # print(summary(z))
   # contour(z, levels=c(0.5,0.6,0.7,0.8,0.9), add=T, col=' blue', drawlabels=T, lwd=1 )

   #median
   if (is.null(initial_qtr)) {
		lines (BoBMatSeries[1:which(yearLab==(current)),5], FoFMatSeries[1:which(yearLab==current),5], type='o', lwd=2, pch=19, cex=3)
		x <- BoBMatSeries[1:which(yearLab==(current)),5]
		y <- FoFMatSeries[1:which(yearLab==current),5]
		lab <- yearLab[1:which(yearLab==current)]
		xyl <- cbind(x,y,lab)
		xyl <- xyl[lab %in% (current-c(0:32)*2),]
		text(xyl[,1], xyl[,2], substr(as.character(xyl[,3]),3,4) , cex=0.7,col='white')
	} else {
		if (average) {
			lines (BoBMatSeries[1:which(yearLab==current),5], FoFMatSeries[1:which(yearLab==current),5], type='o', lwd=2, pch=19, cex=3,col='white')
			x <- BoBMatSeries[1:which(yearLab==current),5]
			y <- FoFMatSeries[1:which(yearLab==current),5]
			lab <- yearLab[1:which(yearLab==current)]
			xyl <- cbind(x,y,lab)
			xyl <- xyl[lab %in% (current-c(0:32)*2),]
			text(xyl[,1], xyl[,2], substr(as.character(xyl[,3]),3,4) , cex=0.9,col='black')
		} else {
			lines (BoBMatSeries[(1:which(yearLab==current)),5][rev(seq(which(yearLab==current),1,by=-4))], FoFMatSeries[(1:which(yearLab==current)),5][rev(seq(which(yearLab==current),1,by=-4))], type='o', lwd=2, pch=19, cex=3,'white')
			x <- BoBMSYMatSeries[(1:which(yearLab==current)),5]
			y <- FoFMatSeries[(1:which(yearLab==current)),5]
			lab <-  yearLab[1:which(yearLab==current)]
			xyl <- cbind(x,y,lab)
			xyl <- xyl[lab %in% (current-c(0:32)*8),]
			text(xyl[,1], xyl[,2], substr(as.character(floor((xyl[,3]-initial_qtr)/4+initial_year+1/8)),3,4) , cex=0.9,col='black')		
		}
	}
	
   #text(BoBMSYMatSeries[1:(nrow(BoBMSYMatSeries)-9),5], FMatSeries[1:(nrow(FMatSeries)-9),5],substr(as.character(yearLab),3,4),cex=0.8,col='white')
   #These surface fitters have arguments to control the smoothness/flatness of the
   #surface. 
	
  # x.b_bmsy = BoBTGTMat[, yearLab == 2015] 
  # y.F_Fmsy = FoFTGTMat[, yearLab == 2015] 
  # ucl.F.Fmsy.last = quantile(y.F_Fmsy,0.95)
  # lcl.F.Fmsy.last = quantile(y.F_Fmsy,0.05)
  # ucl.B.Bmsy.last = quantile(x.b_bmsy,0.95)
  # lcl.B.Bmsy.last = quantile(x.b_bmsy,0.05)
  # B.Bmsy = BoBTGTMatSeries[1:(nrow(BoBTGTMatSeries)-10), 1]
  # F.Fmsy = FoFTGTMatSeries[1:(nrow(FoFTGTMatSeries)-10),1]
  # nyr = numTime - 10
  # kernelF <- ci2d(x.b_bmsy,y.F_Fmsy,nbins=20,factor=2.2,ci.levels=c(0.50,0.80,0.75,0.90,0.95),show="none")
  # c1 <- c(1,1)
  # c2 <- c(-1,100)
  
  # max.y1   <- max(c(2.1, max(kernelF$contours$"0.95"$y,ucl.F.Fmsy.last),na.rm =T))
  # max.y1   <- max(c(2.1,ucl.F.Fmsy.last),na.rm =T)
  # max.y    <- ifelse(max.y1 > 5,min(max(5,F.Fmsy*2),8),max.y1)
  # max.x    <- max(max(2.1,quantile(x.b_bmsy,0.96)))
  
  # plot(1000,1000,type="b", xlim=c(0,max.x), ylim=c(0,max.y),lty=3,xlab="",ylab="", bty="l")
  # mtext("B / Bmsy",side=1, line=2)
  # mtext("F / Fmsy",side=2, line=2) 
  # xx <- c(0,1,1,0); yy <- c(0,0,1,1);  polygon(xx,yy,col="orange")
  # xx <- c(0,1,1,0); yy <- c(1,1,max.y,max.y);  polygon(xx,yy,col="red")
  # xx <- c(1,max.x,max.x,1); yy <- c(0,0,1,1);  polygon(xx,yy,col="green")
  # xx <- c(1,max.x,max.x,1); yy <- c(1,1,max.y,max.y);  polygon(xx,yy,col="orange")
  # polygon(kernelF$contours$"0.95",lty=2,border=NA,col="cornsilk4")
  # polygon(kernelF$contours$"0.8",border=NA,lty=2,col="grey")
  # polygon(kernelF$contours$"0.5",border=NA,lty=2,col="cornsilk2")
  # lines(c1,c2,lty=3,lwd=0.7)
  # lines(c2,c1,lty=3,lwd=0.7)
  # lines(B.Bmsy,F.Fmsy, lty=1,lwd=1.)
  # points(B.Bmsy,F.Fmsy,cex=0.8,pch=4)
  # points(B.Bmsy[1],F.Fmsy[1],col=1,pch=22,bg="white",cex=1.9)
  # points(B.Bmsy[which(yr==int.yr)],F.Fmsy[which(yr==int.yr)],col=1,pch=21,bg="white",cex=1.9)
  # points(B.Bmsy[nyr],F.Fmsy[nyr],col=1,pch=24,bg="white",cex=1.9)
  # segments( lcl.B.Bmsy.last,F.Fmsy[nyr],ucl.B.Bmsy.last,F.Fmsy[nyr])
  # segments( B.Bmsy[nyr],lcl.F.Fmsy.last,B.Bmsy[nyr],ucl.F.Fmsy.last)
	

    return(-999)
}


	
plot.grid.SSB <- function (mList = gridList,average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F,ylim)
{

    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
		if (as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value/1000) > 4000)
			print(names(mList)[mi]);
  		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SPB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}
		yearLab <- as.numeric(substring(BSeries$Label, 5))		
		BSeries[, 2] <- BSeries[, 2]/1000	

		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}		
		
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
            if(!add) {
				plot(yearLab, BSeries[, 2], ylim = ylim, main = "SSB", ylab = "SSB (1000s t)", xlab = "", type = "l", col = col, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=1,col = 2,lty = 1)
				lines(c(current, current), c(-1, ylim[2]), col = 2, lty = 1)	  
			} else 
				lines(yearLab, BSeries[, 2], lwd = 2, col = col)
			#lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
        }
        else {
            lines(yearLab, BSeries[, 2], lwd = 2, col = col)
        }
    }
 
    return(-999)
}
	

plot.grid.SSBoSSB0 <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F)
{

    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
 		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}
		yearLab <- as.numeric(substring(BSeries$Label, 5))		
        BSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value)

		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}		
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
            if(!add) {
				plot(yearLab, BSeries[, 2], ylim = c(0, 2.0), main = "SSB/SSB0", ylab = "SSB/SSB0", xlab = "", type = "l", col = color, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=c(1,0.4,0.1),col = 2,lty = 1)
				lines(c(current, current), c(-1, 10), col = 2, lty = 1)	  			
			} else
				lines(yearLab, BSeries[, 2], lwd = 2, col = col)
			#lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
        }
        else {
            lines(yearLab, BSeries[, 2], lwd = 2, col = col)
        }
     }
 
    return(-999)
}


	
	
plot.grid.SSBoSSBMSY <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F)
{

    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}
		yearLab <- as.numeric(substring(BSeries$Label, 5))
        BSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)

		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
            if(!add) { 
				plot(yearLab, BSeries[, 2], ylim = c(0, 6), main = "SSB/SSBMSY", ylab = "SSB/SSBMSY", xlab = "", type = "l", col = col, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=1,col = 2,lty = 1)
				lines(c(current, current), c(-1, 10), col = 2, lty = 1)	  		
			} else
				lines(yearLab, BSeries[, 2], lwd = 2, col = col)	
        }
        else {
            lines(yearLab, BSeries[, 2], lwd = 2, col = col)
        }
     }

    return(-999)
}

plot.grid.SSBoSSBTGT <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F)
{

    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
		if(!is.null(initial_qtr)) 
			BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
			BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
			colnames(BSeries)[1] = 'Label'
		}
		yearLab <- as.numeric(substring(BSeries$Label, 5))
        BSeries[, 2] <- BSeries[, 2]/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Btgt")$Value)

		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
            if(!add) { 
				plot(yearLab, BSeries[, 2], ylim = c(0, 6), main = "SSB/SSBTGT", ylab = "SSB/SSBTGT", xlab = "", type = "l", col = col, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=1,col = 2,lty = 1)
				lines(c(current, current), c(-1, 10), col = 2, lty = 1)	  		
			} else
				lines(yearLab, BSeries[, 2], lwd = 2, col = col)	
        }
        else {
            lines(yearLab, BSeries[, 2], lwd = 2, col = col)
        }
     }

    return(-999)
}



plot.grid.FoFMSY <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F)
{


    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
  		if(!is.null(initial_qtr)) 
			FSeries <- m$derived_quants[match(paste("F_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			FSeries <- m$derived_quants[match(paste("F_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
			FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
			colnames(FSeries)[1] = 'Label'
		}
        yearLab <- as.numeric(substring(FSeries$Label, 3))
		FSeries[, 2] <- FSeries[, 2]         
		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}		
		
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
           if(!add) {
				plot(yearLab, FSeries[, 2], ylim = c(0, 1.5), main = "F/FMSY", ylab = "F/FMSY", xlab = "", type = "l", col = col, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=1,col = 2,lty = 1)
				lines(c(current, current), c(-1, 10), col = 2, lty = 1)	  
			} else 
				lines(yearLab, FSeries[, 2], lwd = 2, col = col)
			#lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
        }
        else {
            lines(yearLab, FSeries[, 2], lwd = 1, col = col)
        }
    }

    return(-999)
}




plot.grid.FoFTGT <- function (mList = gridList, average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL,color=NA,add=F)
{


    for (mi in 1:length(mList)) {
        m <- mList[[mi]]
  		if(!is.null(initial_qtr)) 
			FSeries <- m$derived_quants[match(paste("F_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
		else
			FSeries <- m$derived_quants[match(paste("F_",initial_year:current_year,sep=""),m$derived_quants$Label),]
		if (average == TRUE) {
			FSeries$Label = paste0("F_",floor((as.numeric(substring(FSeries$Label, 3))-initial_qtr)/4+initial_year+1/8))
			FSeries = aggregate.data.frame(FSeries[,-1],list(FSeries$Label),Mean)
			colnames(FSeries)[1] = 'Label'
		}
        yearLab <- as.numeric(substring(FSeries$Label, 3))
		FSeries[, 2] <- FSeries[, 2] * as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_MSY")$Value)/as.numeric(subset(m$derived_quants, m$derived_quants$Label == "annF_Btgt")$Value)
		if(is.null(initial_qtr)) {
			yearLab = yearLab
			current = current_year	
		} else {
			if (average) {
				yearLab = yearLab
				if (!is.null(current_qtr)) {
					current = (current_qtr - initial_qtr)/4+initial_year+1/8
				} else {
					current = current_year
				}
			} else {
				yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			}
	
		}
		if (is.null(current)) {
			stop ('current = null')
		}		
		
		col = ifelse(is.na(color),mi,color)
        if (mi == 1) {
           if(!add) {
				plot(yearLab, FSeries[, 2], ylim = c(0, 1.5), main = "F/FTGT", ylab = "F/FTGT", xlab = "", type = "l", col = col, lwd = 2, xaxs = "i", yaxs = "i")
				abline(h=1,col = 2,lty = 1)
				lines(c(current, current), c(-1, 10), col = 2, lty = 1)	  
			} else 
				lines(yearLab, FSeries[, 2], lwd = 2, col = col)
			#lines(c(1950, 2030), c(1, 1), col = 2, lty = 1)
        }
        else {
            lines(yearLab, FSeries[, 2], lwd = 1, col = col)
        }
    }

    return(-999)
}



plot.grid.projection <- function (mList = gridList,average=FALSE, initial_year=NULL, current_year=NULL,initial_qtr=NULL, current_qtr = NULL, 
                                  opt = c("skj","h70","h80",'h90','Gest','Gfix','fixed','lorenzen','CPUEbase','CPUEpsls','CPUEmdv'), 
                                  optWt = c(1,1,1,1,1,1,1,1,1,1,1),
	col=c('red','black','gray','blue','orange','green','yellow'),ylim = c(0, 3), xlim=c(1980,2030))

{

    factorList <- array(NA, dim = c(length(mList), length(unlist(strsplit(names(mList)[1], split = "_")))))
    modWtList <- c(1:length(mList)) * 0
    for (mi in 1:length(mList)) {
        factors <- strsplit(names(mList)[mi], split = "_")
        factorList[mi, ] <- unlist(factors)
        modWt <- 1
        for (o in 1:length(opt)) {
            if (opt[o] %in% factorList[mi, ]) 
                modWt <- modWt * optWt[o]
        }
        modWtList[mi] <- modWt
    }
    print(cbind(names(mList), modWtList))
    m <- mList[[1]]$model
	if(!is.null(initial_qtr)) 
		BSeries <- m$derived_quants[match(paste("SSB_",initial_qtr:current_qtr,sep=""),m$derived_quants$Label),]
	else
		BSeries <- m$derived_quants[match(paste("SSB_",initial_year:current_year,sep=""),m$derived_quants$Label),]

	if (average == TRUE) {
		BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
		BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),mean)
		colnames(BSeries)[1] = 'Label'
	}
	
    numTime <- nrow(BSeries)
    numProj = 7
	yearLab <- as.numeric(substring(BSeries$Label, 5))
    BMatSeries <- array(NA, dim = c(numTime, 6))
    BoBMSYSeries <- BSeries
    BoBMSYMat <- array(NA, dim = c(length(mList), numProj,numTime))
    BoBMSYMatSeries <- array(NA, dim = c(numTime, numProj,6))
    BoBTGTSeries <- BSeries
    BoBTGTMat <- array(NA, dim = c(length(mList), numProj,numTime))
    BoBTGTMatSeries <- array(NA, dim = c(numTime, numProj,6))
	

    for (mi in 1:length(mList)) {
        p <- mList[[mi]]$project
		for (pi in 1:numProj) {
			if(!is.null(initial_qtr)) 
				BSeries <- p[[pi]][match(paste("SSB_",initial_qtr:current_qtr,sep=""),p[[pi]]$Label),]
			else
				BSeries <- p[[pi]][match(paste("SSB_",initial_year:current_year,sep=""),p[[pi]]$Label),]
			if (average == TRUE) {
				BSeries$Label = paste0("SSB_",floor((as.numeric(substring(BSeries$Label, 5))-initial_qtr)/4+initial_year+1/8))
				BSeries = aggregate.data.frame(BSeries[,-1],list(BSeries$Label),Mean)
				colnames(BSeries)[1] = 'Label'
			}		
			BoBMSYSeries <- BSeries
			BoBMSYSeries[, 2] <- BSeries[, 2]/as.numeric(subset(p[[pi]], p[[pi]]$Label == "SSB_MSY")$Value)
			BoBMSYMat[mi,pi, ] <- BoBMSYSeries[, 2]

			BoBTGTSeries <- BSeries
			BoBTGTSeries[, 2] <- BSeries[, 2]/as.numeric(subset(p[[pi]], p[[pi]]$Label == "SSB_Btgt")$Value)
			BoBTGTMat[mi,pi, ] <- BoBTGTSeries[, 2]

			
		}
	}

    for (t in 1:numTime) {
		for (pi in 1:numProj) {
			BoBMSYMatSeries[t,pi,1] <- weighted.mean(BoBMSYMat[,pi,t], w = modWtList)
			BoBMSYMatSeries[t,pi,2] <- min(BoBMSYMat[,pi,t])
			BoBMSYMatSeries[t,pi,3] <- max(BoBMSYMat[,pi,t])
			tmpSort <- sort(BoBMSYMat[, pi, t])
			modWtSort <- modWtList[order(BoBMSYMat[, pi, t])]
			tmpcum <- cumsum(modWtSort)/sum(modWtSort)
			BoBMSYMatSeries[t,pi,4] <- tmpSort[tmpcum > 0.05][1]
			BoBMSYMatSeries[t,pi,5] <- tmpSort[tmpcum > 0.5][1]
			BoBMSYMatSeries[t,pi,6] <- tmpSort[tmpcum > 0.95][1]
			
			BoBTGTMatSeries[t,pi,1] <- weighted.mean(BoBTGTMat[,pi,t], w = modWtList)
			BoBTGTMatSeries[t,pi,2] <- min(BoBTGTMat[,pi,t])
			BoBTGTMatSeries[t,pi,3] <- max(BoBTGTMat[,pi,t])
			tmpSort <- sort(BoBTGTMat[, pi, t])
			modWtSort <- modWtList[order(BoBTGTMat[, pi, t])]
			tmpcum <- cumsum(modWtSort)/sum(modWtSort)
			BoBTGTMatSeries[t,pi,4] <- tmpSort[tmpcum > 0.05][1]
			BoBTGTMatSeries[t,pi,5] <- tmpSort[tmpcum > 0.5][1]
			BoBTGTMatSeries[t,pi,6] <- tmpSort[tmpcum > 0.95][1]			
			
		}
	}
	if(is.null(initial_qtr)) {
		yearLab = yearLab
		current = current_year	
	} else {
		if (average) {
			yearLab = yearLab
			if (!is.null(current_qtr)) {
				current = (current_qtr - initial_qtr)/4+initial_year+1/8
			} else {
				current = current_year
			}
		} else {
			yearLab = (yearLab-initial_qtr)/4+initial_year+1/8
			current = (current_qtr - initial_qtr)/4+initial_year+1/8
		}
	
	}
	if (is.null(current)) {
		stop ('current = null')
	}

	BoBMatSeries = BoBTGTMatSeries
	main = "SSB/SSBTGT"
	ylab = "SSB/SSBTGT"
	plot(yearLab, BoBMatSeries[,1,1],ylim = ylim, xlim=xlim ,main = main, ylab = ylab, xlab = "", type = "n", col = 1, lwd = 2)
	rect(2019, -1, 2035, 5,col='grey90')
	for (pi in 1:numProj) {
		lines(yearLab, BoBMatSeries[,pi,1], col = col[pi], lty = 1, lwd = 2)
	}	
	lines(yearLab, BoBMatSeries[,3,1], col = col[3], lty = 1, lwd = 2)
	abline(h=1,col = 1,lty = 2)
	legend('topright',col=rev(col),lwd=2,legend=rev(c('120%','110%','100%','90%','80%','70%','60%')),bty='n',cex=1.0)
    return(-999)
}




grid.boxplox = function (mList = gridList, current_qtr = 2025)

{ 
    modList =names(mList)
	
	factorList <- array(NA, dim = c(length(modList), length(unlist(strsplit(modList[1], split = "_")))))
	for (mi in 1:length(modList)) {
		factors <- strsplit(modList[mi], split = "_")
		factorList[mi, ] <- unlist(factors)
	}

	SSB0all <- NULL
	SSBMSYall <- NULL	
	SSBYall <- NULL
 	SSBYoSSB0all <- NULL
	SSBYoSSBMSYall <- NULL
	FMSYall <- NULL
    FYoFMSYall <- NULL
    MSYall <- NULL
	FYall <- NULL
    for (i in 1:length(modList)) {
        print(modList[i])
        m <- mList[[modList[i]]]
        SSBY <-  mean(as.numeric(m$derived_quants[match(paste0("SSB_",current_qtr),m$derived_quants$Label),]$Value))
        SSBMSY <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_MSY")$Value)
        SSB0 <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "SSB_Virgin")$Value)
        SSB0all <- c(SSB0all,SSB0)
		SSBYoSSBMSYall <- c(SSBYoSSBMSYall, SSBY/SSBMSY)
        SSBYoSSB0all <- c(SSBYoSSB0all, SSBY/SSB0)
		SSBYall <- c(SSBYall, SSBY)				
        FY <-  mean(as.numeric(m$derived_quants[match(paste0("F_",current_qtr),m$derived_quants$Label),]$Value))
        FMSY <- as.numeric(m$derived_quants[substring(m$derived_quants$Label, 1, 8) == "annF_MSY", ]$Value)
        FYoFMSYall <- c(FYoFMSYall, FY)
		FYall <- c(FYall, FY*FMSY)
        MSY <- as.numeric(subset(m$derived_quants, m$derived_quants$Label == "Dead_Catch_MSY")$Value)
        MSYall <- c(MSYall, MSY)
    }

	
    fList <- NULL
    for (i in 1:ncol(factorList)) {
        if (length(unique(factorList[, i])) > 1) 
            fList <- cbind(fList, factorList[, i])
    }

    for (i in 1:ncol(fList)) {
        boxplot(SSB0all/1000 ~ fList[, i], ylab = "SB0 (1000 t)")
    }


    for (i in 1:ncol(fList)) {
        boxplot(SSBYoSSB0all ~ fList[, i], ylab = "SB2025/SB0")
    }

    for (i in 1:ncol(fList)) {
        boxplot(SSBYoSSBMSYall ~ fList[, i], ylab = "SB2025/SBMSY")
        lines(c(0, 10000), c(1, 1), lty = 2, col = 2)
    }
		

    for (i in 1:ncol(fList)) {
        boxplot(FYoFMSYall ~ fList[, i], ylab = "F2025/FMSY")
        lines(c(0, 10000), c(1, 1), lty = 2, col = 2)
    }
	
    for (i in 1:ncol(fList)) {
        boxplot(MSYall/1000 ~ fList[, i], ylab = "MSY (1000 t)")
    }
	
}
