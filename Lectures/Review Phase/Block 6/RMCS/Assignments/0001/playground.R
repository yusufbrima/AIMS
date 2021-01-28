library(raster)
library(ncdf4)
#nc.pre <- read.table("/Users/yusuf/Downloads/AIMSData2021/Kamembe.dat")

#data =  read.table("/Users/yusuf/Downloads/AIMSData2021/Kamembe.dat",sep="",skip=0)
# files = list.files("./Dataset",pattern = ".dat",full.names = TRUE)
# 
# cities = c("Kamembe","Kayonza","Kigali","Koulikoro","Lagos","Lome","Maseno","Maseno","Mombasa","Musanze","Nairobi")
# 
# 

  

# data =  read.table(files[1],sep="",skip=0)
# 
# df = NULL
# df$Kamembe <- data$PETD
# 
# for (i in 1:length(files)){
#    data =  read.table(files[i],sep="",skip=0)
#    write.csv(data, paste("./Dataset/Extracted/",cities[i],".csv",sep=""), col.names = T)
# }


df = read.csv("./Dataset/clean_dataset.csv",header = T)


