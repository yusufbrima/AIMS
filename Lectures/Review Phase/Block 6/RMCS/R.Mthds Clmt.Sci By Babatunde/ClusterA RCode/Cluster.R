rm(list=ls())
setwd("/home/gladys/AIMS_19_20/Review Phase/R.Mthds Clmt.Sci By Babatunde/ClusterA RCode")
#opening the file
#egs=read.table('Droughts.txt',skip=22,header=T)
# Removing Year and Month
#xx=egs[,3:18]

# Replacing the missing values (-999) with -2.33

 #xx[xx==-999]=-2.33
# Creating a sequence  of january from all the months
#jan=seq(1,612,12)

# Creating an array to keep all the 51 januaries
# for the 16 variables
#yy=array(NA,c(51,16))
# selecting the month of january 
#for ( i in 1 :16){
#yy[,i]=xx[,i][jan]
#}


## Reading the data

data=my_data <- read.csv("Data.csv")
data
View(data)
# scaling the array
data1=data[,-1]
str(data1)
str(data)
yy.scaled=scale(data1)
colnames(yy.scaled)=names(data1)

####### performing the clustering############
yy.clus=hclust(dist(t(yy.scaled)),method='ward')
yy.clus2=hclust(dist(t(yy.scaled)),method='single')
yy.clus3=hclust(dist(t(yy.scaled)),method='average')

#####plotting the tree#################


plot(yy.clus,hang=-2)
plot(yy.clus2,hang=-2)
plot(yy.clus3,hang=-2)

cutree(yy.clus,k=4)
cutree(yy.clus2,k=4)
cutree(yy.clus3,k=4)



##### Using the transposed data
yy.scaled1=scale(data[,-1])
data2=t(yy.scaled1)

data2= setNames(data.frame(t(yy.scaled1[,-1])), yy.scaled1[,1])
yy.scaled1=scale(data2)
colnames(yy.scaled1)=names(data2)

####### performing the clustering############
yy.clus1=hclust(dist(t(data2)),method='ward.D2')
yy.clus21=hclust(dist(t(data2)),method='single')
yy.clus31=hclust(dist(t(yy.scaled1)),method='average')

#####plotting the tree#################


plot(yy.clus1,hang=-2)
plot(yy.clus21,hang=-2)
plot(yy.clus31,hang=-2)

cutree(yy.clus1,k=4)
cutree(yy.clus21,k=4)
cutree(yy.clus31,k=4)

