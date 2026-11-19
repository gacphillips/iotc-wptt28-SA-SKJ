### Output LF data to SS3 - 2026 filter

## Remove fish larger than 120 cm, considering the maximum size for a skipjack is thought to be 110 cm.

ModelFisheries =c('PL','PSLS','PSFS','GL',"LI","LL","Other")

Data <- read_csv(make.filename(file = "IOTC-2026-WPTT28-DATA06-SKJ-1982-2025-WIDE-FORMAT.csv",path=paste0(PATH_DATA, "LF/")))
Data <- Data %>% 
  dplyr::rename(Fleet = FLEET_CODE,Year=YEAR,MonthStart=MONTH_START,MonthEnd =MONTH_END,Grid =FISHING_GROUND_CODE, Gear = GEAR_CODE,Species =SPECIES_CODE,SchoolType=SCHOOL_TYPE_CODE, MeasureType =MEASURE_TYPE_CODE,	FirstClassLow =FIRST_CLASS_LOW,	SizeInterval =SIZE_INTERVAL,TnoFish =NO_FISH,TkgFish = KG_FISH)


dHelper <- read_excel(make.filename(file = "helper.xlsx",path=paste0(PATH_DATA,"CE/")),sheet = "LF") 
dHelper = dHelper %>% 
  dplyr::mutate(Fishery=replace(Fishery, Fishery=='BB', 'PL')) %>% 
  dplyr::mutate(Fishery=replace(Fishery, Fishery=='Gillnet', 'GL')) %>% 
  dplyr::mutate(Fishery=replace(Fishery, Fishery=='Line', 'LI')) %>% 
  dplyr::mutate(Fishery=replace(Fishery, Fishery=='Longline', 'LL')) %>% 	
  dplyr::mutate(Fishery=replace(Fishery, Fishery=='OTHER', 'Other')) %>% 	
  dplyr::mutate(Fishery=replace(Fishery, Gear %in% c('TROL','TROLM','TROLN'), 'Other')) %>% 		
  dplyr::select(Fleet,Gear,SchoolType,Fishery)


Data = Data %>% 
  dplyr::left_join(dHelper,by=c("Gear"="Gear","Fleet"="Fleet","SchoolType"="SchoolType")) %>% 
  dplyr::mutate(LatCell = 0, LongCell = 0) %>%
  mutate_cond(substring(Grid,1,1) == "5",LatCell=1,LongCell=1) %>%
  mutate_cond(substring(Grid,1,1) == "6",LatCell=5,LongCell=5) %>%
  mutate_cond(substring(Grid,1,1) == "1",LatCell=5,LongCell=10) %>%
  mutate_cond(substring(Grid,1,1) == "2",LatCell=10,LongCell=20) %>%
  mutate_cond(substring(Grid,1,1) == "3",LatCell=10,LongCell=10) %>%
  mutate_cond(substring(Grid,1,1) == "4",LatCell=20,LongCell=20) %>%
  dplyr::filter(!(LatCell == 0 & LongCell == 0)) %>%
  dplyr::mutate(quadrant = as.numeric(substring(Grid,2,2)), Lat=999,Long=999)  %>%
  mutate_cond(quadrant ==1,Lat= as.numeric(substring(Grid,3,4)) + LatCell/2, Long = as.numeric(substring(Grid,5,7)) + LongCell/2) %>%
  mutate_cond(quadrant ==2,Lat= -as.numeric(substring(Grid,3,4)) - LatCell/2, Long = as.numeric(substring(Grid,5,7)) + LongCell/2) %>%
  dplyr::mutate(FisheryCode=Fishery,ModelFishery = factor(Fishery,levels= ModelFisheries), ModelFleet = as.numeric(ModelFishery),Country=trim(Fleet),Grid=as.character(Grid),Month=MonthStart,Quarter = floor((MonthStart-1)/3) + 1,AssessmentArea = 1, ModelArea =1,AssessmentAreaName=1,ModelAreaName=1) %>%				
  dplyr::select(Year,Quarter,Month,Grid,,Lat,Long,AssessmentArea,ModelArea,FisheryCode,ModelFishery,ModelFleet,Country,Gear,SchoolType,FirstClassLow,SizeInterval,C001:C150)

C_labels = c(Paste("C00",1:9),Paste("C0",10:99), Paste("C",100:150))
data = Data %>% 
  dplyr::group_by(Year,Quarter,Month,Grid,,Lat,Long,AssessmentArea,ModelArea,FisheryCode,ModelFishery,ModelFleet,Country,Gear,SchoolType,FirstClassLow,SizeInterval) %>% 
  dplyr::summarise_at(C_labels,list(Sum)) %>%
  as.data.frame() 

data = data %>%	
  dplyr::mutate(sno=rowSums(dplyr::select(data,C001:C150))) %>%
  dplyr::mutate(C089=rowSums(select(data,C089:C150))) %>%		
  dplyr::select(Year,Quarter,Month,Grid,,Lat,Long,AssessmentArea,ModelArea,FisheryCode,ModelFishery,ModelFleet,Country,Gear,SchoolType,FirstClassLow,SizeInterval,sno,C001:C089) %>% 
  tidyr::gather(length,total,C001:C089) %>%
  dplyr::mutate(length = FirstClassLow+(as.numeric(substr(length,2,4))-1)*SizeInterval) %>% 
  dplyr::mutate(length=ifelse(length<100,Paste("L0",length),Paste("L",length))) %>% 
  tidyr::spread(length,total,fill=0)


wtf <- data %>% filter(is.na(ModelFleet))

wtf2 <- wtf %>%
  select(Year, Country, Gear, SchoolType, sno) %>%
  group_by(Year, Country, Gear, SchoolType) %>%
  summarise(tno = sum(sno))
#
#
wtf3 <- wtf2 %>%
  select(Country, Gear, SchoolType, tno) %>%
  group_by(Country, Gear, SchoolType) %>%
  summarise(ttno = sum(tno))

print(wtf3)

# work1 <- data %>% filter(Country == "LKA", Year == 2012)

# data <- data %>% filter(!is.na(ModelFleet))


### Do the filtering and plots 2026

L_labels  = c(Paste("L0",seq(10,98,by=1)))

work = data %>% 
  dplyr::filter(!(Country == 'LKA' &  Gear == 'BB' & SchoolType == "UNCL" & (Year %in% c(2016))))  %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'FLL' & SchoolType == "UNCL" & (Year %in% c(2016:2020))))  %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'GILL' & SchoolType == "UNCL" & (Year %in% c(2016,2017,2019,2020,2021,2022))))  %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'GIOF' & SchoolType == "UNCL" & (Year %in% c(2016,2017,2019,2020)))) %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'HAND' & SchoolType == "UNCL" & (Year %in% c(2016,2017,2020)))) %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'LLCO' & SchoolType == "UNCL" & (Year %in% c(2016,2017,2019,2020)))) %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'RIN'  & SchoolType == "UNCL" & (Year %in% c(2016,2017,2019,2020,2022)))) %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'RNOF' & SchoolType == "UNCL" & (Year %in% c(2016,2017,2018,2019,2020,2022)))) %>%
  dplyr::filter(!(Country == 'LKA' &  Gear == 'TROL' & SchoolType == "UNCL" )) %>%
  dplyr::filter(!(Country == 'MDV' &  Gear == 'BB' & SchoolType == "FS" & (Year %in% c(2019)))) %>%
  dplyr::filter(!(Country == 'MDV' &  Gear == 'BB' & SchoolType == "UNCL" & (Year %in% c(2016,2018,2019,2020)))) %>%	
  dplyr::filter(!(Country == 'MDV' &  Gear == 'BBOF' & SchoolType == "UNCL"& (Year %in% c(2018,2019)))) %>%	
  dplyr::filter(!(Country == 'MUS' &  Gear == 'PS'  & SchoolType == "UNCL" & (Year %in% c(1988:2000,2014))))  %>%
  dplyr::filter(!(Country == 'MUS' &  Gear == 'PSOB' & SchoolType == "LS" & (Year %in% c(2021))))  %>%
  dplyr::filter(!(Country == 'MUS' &  Gear == 'PSOB' & SchoolType == "UNCL" & (Year %in% c(2022)))) %>%
  dplyr::filter(!(Country == 'THA' &  Gear == 'PSS' & SchoolType== "UNCL" & (Year %in% c(2005:2009,2011:2015,2020:2022)))) %>%
  dplyr::filter(!(Country == 'SYC' &  Gear == 'PS' & SchoolType == "UNCL" & (Year %in% c(2021))))  %>%
  dplyr::filter(!(ModelFishery == 'PL' & (Year < 2000 | Year %in% 2015:2016))) %>%
  dplyr::filter(!(ModelFishery %in% c('GL','Other') & Year  %in% c(2007:2010,2021))) %>%
  dplyr::filter(!(ModelFishery %in% c('LI') & Year  < 2018)) %>%
  dplyr::filter(!(ModelFishery %in% c('LL') & Year  < 2011)) %>%
  dplyr::group_by(ModelFishery,ModelFleet,Year,Quarter) %>% 
  dplyr::summarise_at(L_labels,list(Sum)) %>%
  as.data.frame() %>%
  tidyr::gather(length,total,L010:L098) %>%
  dplyr::mutate(length=as.numeric(substr(length,2,4))) %>%
  mutate(length = ifelse(length < 20, 20, length)) %>% 
  mutate(length = ifelse(length > 96, 96, length)) %>%
  filter(length < 121) %>%
  mutate(length = 20+((length-20) %/% 4) * 4) %>%
  mutate(length = ifelse(length<100,Paste("L0",length),Paste("L",length))) %>%
  dplyr::group_by(ModelFishery,ModelFleet,Year,Quarter,length) %>% 
  dplyr::summarise_at("total",list(Sum)) %>% 
  tidyr::spread(length,total,fill=0) %>% 
  as.data.frame()



L_labels  = c(Paste("L0",seq(20,96,by=4)))
work = work %>%
  mutate(sno=rowSums(select(work,L020:L096))) %>%	
  mutate(Nsamp = ifelse(ModelFishery == 'Other',pmin(sno/10,100), pmin(sno/10,1000))) %>%
  mutate(Quarter = Quarter*3-0.5,Gender = 0,Part = 0) %>%
  dplyr::select(Year,Quarter,ModelFleet,Gender,Part,Nsamp,all_of(L_labels)) %>%
  dplyr::arrange(ModelFleet,Year,Quarter)		

work[,L_labels][work[,L_labels]==0] = 1e-10
write.table(work,'temp.dat',row.names=F,sep='\t')


LF_1_INPUT_OBJECT[["data"]] = data


max(data$Year)
max(work$Year)


save(file="LF_1_INPUT.object",list=c("LF_1_INPUT_OBJECT"))
### Save SS3 LF input


save(file=paste0(PATH_SS3_INPUT,"LF_1_INPUT.object"),list=c("LF_1_INPUT_OBJECT")) 
write.csv(work, file =paste0(PATH_SS3_INPUT,"SS3LFinput_2026.csv")) # in data.ss file


