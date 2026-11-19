library(ggplot2)
library(mapproj)
library(mapdata)
library(maps)
library(myUtilities)
library(readxl)
library(dplyr)
library(dbplyr)
library(tidyr)
library(RColorBrewer)
# library(reshape)

PATH <- [CHANGE TO YOUR BASE PATH FILE]
PATH_DATA = paste(PATH,"data/",sep="")
PATH_DATAPREP = paste(PATH,"1_dataprep/",sep="") ##PATH_R (R)
PATH_MODELRUNS = paste(PATH,"2_modelruns/",sep="") ##PATH_SS3 
PATH_SENSITIVITES = paste(PATH_MODELRUNS, "sensitivities/",sep="") ## run sensitivities
PATH_GRID = paste(PATH, "4_gridrun/",sep="") ## grid
PATH_GRID_PLOT = paste(PATH_GRID, "plots/",sep="")
PATH_DIAGNOSTICS = paste(PATH,"3_diagnostics/",sep="") 
PATH_SS3_INPUT = paste(PATH_DATA, "SS3_input/",sep="") ##PATH_OUTPUT
PATH_DATA_PLOT = paste(PATH_DATA, "plots/",sep="") ##PATH_PLOT
PATH_DIAG_PLOT = paste(PATH_DIAGNOSTICS, "plots/",sep="")
