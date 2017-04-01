#FCT Data Daily:Packages Required: XLConnect & dplyr

library("XLConnect")#load XLConnect
library("dplyr")#loas dplyr

#maters(Inhouse, regions, genre, agency & agency group) & total data preloaded in directory is required
latestweek<-loadWorkbook("latestweek.xlsx")#load data
latestweek<-readWorksheet(latestweek,sheet=1,startRow=7,drop=c(7,9))#readfile
latestweek<-latestweek[!(latestweek$Product.Group=="Promo Tag"),]#delete promotag
latestweek$Main<-paste(latestweek$Advertiser,latestweek$Channel,sep="")#add temporary column for inhouse
inhouse<-loadWorkbook("inhouse.xlsx")#load inhouse master
inhouse<-readWorksheet(inhouse,sheet=1,startRow=1,startCol=3)#read inhouse
latestweek<-left_join(latestweek,inhouse,by="Main")#vlookup for inhouse by Main
latestweek<-latestweek[is.na(latestweek$Value),]#remove inhouse(Main=1)
latestweek<-select(latestweek,-(Main:Value))#
latestweek<-mutate(latestweek,AdvertiserNew=gsub(" ","",Advertiser))#create temp advertiser column to remove space
region<-loadWorkbook("regionmaster.xlsx")#loadworkbook
region<-readWorksheet(region,sheet=1)#read region
latestweek<-left_join(latestweek,region)#vlookup region
agency<-loadWorkbook("agencymaster.xlsx")#load Agency
agency<-readWorksheet(agency,sheet="Reworked Agency",startRow=2)#readAgency
latestweek<-left_join(latestweek,agency)#vlookup for agency & agency group
genre<-loadWorkbook("genre.xlsx")#loadgenre
genre<-readWorksheet(genre,sheet=1)#readgenre
latestweek<-left_join(latestweek,genre)#vlookup for genre
latestweek<-mutate(latestweek,Advertiser=gsub("Reliance Industries","Reliance Industries Ltd",gsub("Reliance Retail Ltd","Reliance Industries Ltd",Advertiser)))#combine advertisers
Regionsrequired<-filter(latestweek,is.na(Region))#unmapped regions
unique(Regionsrequired$Advertiser)#unique umapped advertiser

