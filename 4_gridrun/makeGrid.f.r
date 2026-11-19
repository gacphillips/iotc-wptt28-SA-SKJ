makeGrid.SKJ = function (path = paste0(PATH_GRID), makeGrid = F,
                        m.val =c("skj"), 
                        h.val = c("h70","h80",'h90'), 
                        G.val = c("Linf70", "LinfestLL2"),
                        M.val = c("fixed","lorenzen"), #,
                        q.val = c("q0","q1"),
                        C.val = c("CPUEmdv", "CPUEpsls"))#,"TW")) #"CPUEbase",
{
  '%&%' <- function(x, y) paste0(x,y)
  gridList <- NULL
  for (m in m.val) {
    for (h in h.val) {
      for (G in G.val) {
        for (M in M.val) {
          for (q in q.val) {	
            for (C in C.val){
              gridList <- c(gridList, paste(m,h,G,M,q,C,
                                            sep="_" ))
            }}}}} }
  
  
  
  batRunFName <- "gridRun" %&% ".bat"
  batProjFName <- "gridProj" %&% ".bat"	
  if (makeGrid) {
    bRf <- file(path %&% "/" %&% batRunFName, open = "w")
    bPf <- file(path %&% "/" %&% batProjFName, open = "w")
  }	
  counter = 0;
  for (m in m.val) {
    for (h in h.val) {
      for (G in G.val) {
        for (M in M.val) {
          for (q in q.val) {	
            for (C in C.val) {
              #if (G=="GDortel" & M=="Mlow") next
              gridName <- paste(m, h,G,M,q,C, 
                                sep="_" )
              if (makeGrid) {
                dir.create(c(path %&% "//" %&% gridName))			
                file.copy(from = path %&% "/gridTemplate/run.bat ", to = path %&% "/" %&% gridName)
                file.copy(from = path %&% "/gridTemplate/Starter.SSest ", to = path %&% "/" %&% gridName)
                file.copy(from = path %&% "/gridTemplate/Starter.SSnoest ", to = path %&% "/" %&% gridName)
                
                dir.create(c(path %&% "/" %&% gridName  %&% "/projection"))			
                file.copy(from = path %&% "/gridTemplate/proj.bat ", to = path %&% "/" %&% gridName  %&% "/projection")
                file.copy(from = path %&% "/gridTemplate/Starter.SSest ", to = path %&% "/" %&% gridName %&% "/projection")
                file.copy(from = path %&% "/gridTemplate/Starter.SSnoest ", to = path %&% "/" %&% gridName %&% "/projection")
                
                
                template <- scan(path %&% "/gridTemplate" %&% "/TemplateCONTROL.SS", what = "", sep = "\n")
                write("# " %&% gridName, file = path %&% "/" %&% gridName %&% "/control.ss", append = F)
                for (i in 1:length(template)) {
                  str <- template[i]
                  str <- sub("# xxx " %&% m, "", str)
                  str <- sub("# xxx " %&% h, "", str)
                  str <- sub("# xxx " %&% G, "", str)	
                  str <- sub("# xxx " %&% M, "", str)	
                  str <- sub("# xxx " %&% q, "", str)
                  str <- sub("# xxx " %&% C, "", str)
                  write(str, file = path %&% "/" %&% gridName %&% "/control.ss", append = T)
                  write(str, file = path %&% "/" %&% gridName %&% "/projection/control.ss", append = T)
                  
                }
                template <- scan(path %&% "/gridTemplate" %&% "/TemplateDATA.SS", what = "", sep = "\n")
                write("# " %&% gridName, file = path %&% "/" %&% gridName %&% "/data.ss", append = F)
                for (i in 1:length(template)) {
                  str <- template[i]
                  str <- sub("# xxx " %&% m, "", str)
                  str <- sub("# xxx " %&% h, "", str)
                  str <- sub("# xxx " %&% G, "", str)	
                  str <- sub("# xxx " %&% M, "", str)		
                  str <- sub("# xxx " %&% q, "", str)	
                  str <- sub("# xxx " %&% C, "", str)
                  write(str, file = path %&% "/" %&% gridName %&% "/data.ss", append = T)
                  write(str, file = path %&% "/" %&% gridName %&% "/projection/data.ss", append = T)			
                }
                
                
                for (pf in c("Forecast.SS")) {
                  template <- scan(path %&% "/gridTemplate" %&% "/Template" %&% pf, what = "", sep = "\n")
                  mainF <- path %&% "/" %&% gridName %&% "/Template" %&% pf   # -> TemplateForecast.SS, what run.bat copies
                  projF <- path %&% "/" %&% gridName %&% "/projection/" %&% pf
                  
                  write("# " %&% gridName, file = mainF, append = F)
                  write("# " %&% gridName, file = projF, append = F)
                  for (i in 1:length(template)) {
                    str <- template[i]
                    str <- sub("# xxx " %&% m, "", str)
                    str <- sub("# xxx " %&% h, "", str)
                    str <- sub("# xxx " %&% G, "", str)
                    str <- sub("# xxx " %&% M, "", str)
                    str <- sub("# xxx " %&% q, "", str)
                    str <- sub("# xxx " %&% C, "", str)
                    write(str, file = mainF, append = T)
                    write(str, file = projF, append = T)
                  }
                }
                counter = counter + 1			
                cat("\ncd " %&% gridName, file = bRf, sep = "\n")			
                cat("call run", file = bRf, sep = "\n")
                cat("cd ..", file = bRf, sep = "\n")
                cat("echo ",counter, file = bRf)
                cat("\n", file = bRf)
                
                cat("\ncd " %&% gridName %&% "/projection", file = bPf, sep = "\n")
                cat("call proj", file = bPf, sep = "\n")
                cat("cd ../..", file = bPf, sep = "\n")
                cat("echo ",counter, file = bPf)
                cat("\n", file = bPf)
                
                
              }
            }}}}
   }}
  if (makeGrid)  {
    close(bRf)
    close(bPf)
    
  }
  return(gridList)
}