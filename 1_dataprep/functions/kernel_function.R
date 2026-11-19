#Norbert Billet - IRD
#occurences_file_path <- "/home/norbert/Boulot/iMarine/WPS/Occurences/NOAA_simple.csv"

kernelDensityContour <- function(dataset, x_column_name="longitude", y_column_name="latitude", minX=0,maxX=10,minY=0,maxY=10,n=100,targeted_percents=c(25, 50, 75, 80, 90, 95, 98, 99))
{
  if(missing(dataset))
  {
    stop("The dataset is missing, stupid ass")
  } 
  
  #load requested libraries
  if(! require(MASS) | ! require(sp))
  {
    stop("Missing library")
  }
  
  #read th csv input file
  csvDf <- dataset
  
  #test for the x column
  if(is.na(match(x_column_name, names(csvDf))))
  {
    stop(paste("Cannot find the x column:", x_column_name))
  }
  
  #test for the y column
  if(is.na(match(y_column_name, names(csvDf))))
  {
    stop(paste("Cannot find the y column:", y_column_name))
  }
  
  #keep only usefull columns
  occurencesDf <- data.frame(x=csvDf[, x_column_name], y=csvDf[, y_column_name])
  rm(csvDf)
  
  #compute bandwith as mean of normal reference distribution bandwith for x and y
  bandwidth <- (bandwidth.nrd(occurencesDf$x) + bandwidth.nrd(occurencesDf$y)) / 2
  
  #grid limits for density estimation
  minX <- max(floor(min(occurencesDf$x) - bandwidth), minX)
  maxX <- min(ceiling(max(occurencesDf$x) + bandwidth), maxX)
  minY <- max(floor(min(occurencesDf$y) - bandwidth), minY)
  maxY <- min(ceiling(max(occurencesDf$y) + bandwidth), maxY)
  rangeX <- maxX - minX
  rangeY <- maxY - minY
  
  #two-dimensional kernel density estimation
  kernelDensity <- kde2d(x=occurencesDf$x, y=occurencesDf$y, h=bandwidth,n=n,lims=c(minX,maxX,minY,maxY))
  
  #sum of estimated density
  kernelDensity.total <- sum(kernelDensity$z)
  
  #compute all distincts levels of density
  densityLevels <- as.vector(kernelDensity$z)
  densityLevels <- unique(sort(densityLevels[densityLevels > 0]))
  
  #order targeted percents
  targeted_percents <- sort(targeted_percents[targeted_percents > 0 & targeted_percents < 100], decreasing=TRUE)
  
  #browse the sorted density levels to look for match with targeted percents
  targetedDensityLevels <- vector()
  adjustedTargetedPercents <- vector()
  i <- 1
  currentTargetedPercent <- 1
  while(i <= length(densityLevels) && currentTargetedPercent <= length(targeted_percents))
  {
    #compute the percentage of estimated density greater than the current density level
    currentDensityPercent <- 100*sum(kernelDensity$z[kernelDensity$z > densityLevels[i]]) / kernelDensity.total
    #if lower than the current targeted percentage then we found a requested levels
    if(currentDensityPercent < targeted_percents[currentTargetedPercent])
    {
      adjustedTargetedPercents[currentTargetedPercent] <- currentDensityPercent
      targetedDensityLevels[currentTargetedPercent] <- densityLevels[i]
      currentTargetedPercent <- currentTargetedPercent + 1
    }
    i <- i + 1
  }
  
  #extract contour lines for each targeted density level
  densityContourLines <- contourLines(kernelDensity, levels=targetedDensityLevels)

  return(list(kernelDensity=kernelDensity,densityContourLines=densityContourLines))
}
