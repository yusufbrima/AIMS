library(factoextra)
library(graphics)
library(ggbiplot) #package to plot principal components
library(psych)
library(plotly)

cities_dataset = read.csv("./Dataset/clean_dataset.csv",header = T)
cities <-  cities_dataset[,2:11]
head(cities_dataset)


boxplot(cities,col=1:10,main="Boxplot of PET",ylab="PET in mm")

####### performing the clustering############
cities.august.scaled.clus=hclust(dist(t(scale(cities))),method='ward.D2')

#####plotting the tree#################
#plot(cities.august.scaled.clus,hang=-6,col="blue")

#cutree(cities.august.scaled.clus,k=4)


plot(cities.august.scaled.clus,hang=-6, main = 'Ward.D2 Algorithm',xlab =" ", sub ="")
rect.hclust(cities.august.scaled.clus, k =4, border = 'red') ## selecting three clusters


####### performing the clustering############
cities.august.scaled.clus=hclust(dist(t(scale(cities))),method='average')

#####plotting the tree#################
#plot(cities.august.scaled.clus,hang=-6,col="brown")

#cutree(cities.august.scaled.clus,k=4)
plot(cities.august.scaled.clus,hang=-6, main = 'Average linkage',xlab =" ", sub ="")
rect.hclust(cities.august.scaled.clus, k =4, border = 'red') ## selecting three clusters

####### performing the clustering############
cities.august.scaled.clus=hclust(dist(t(scale(cities))),method='single')

#####plotting the tree#################
#plot(cities.august.scaled.clus,hang=-6,col="red")

#cutree(yy.clus,k=4)

plot(cities.august.scaled.clus, main = 'Single linkage',xlab =" ", hang=-6,sub ="")
rect.hclust(cities.august.scaled.clus, k =4, border = 'red') ## selecting three clusters

## Unrotated PCA
pc1 <- principal(scale(cities), nfactors = 10, rotate = "none")


#par(mfrow = c(1,2))
pve <- 100* pc1$values/sum(pc1$values) 
plot(pc1$values, type ="o" , ylab ="Eigenvalues " , xlab ="Principal Component" ,
     col ="blue", main = 'screeplot')
plot (cumsum(pve) , type ="o" , ylab ="Cumulative PVE " , xlab ="Principal Component " , col ="brown3 ",
      main = 'Percentage Variance Explained (PVE) plot')


pc2 <- principal(scale(cities), nfactors = 10, rotate = "varimax") 

scores<- as.data.frame(pc2$scores)  #scores after rotation

#plotting some of the scores
#plot(as.Date(cities_dataset$Date, '%m/%d/%Y'),scores$RC1,type ="o", xlab = 'year', ylab='RC1', main='Rotated Component 1')

#par(mfrow = c(3,2))
#Time Series of PCA RC1
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
plot(as.Date(cities_dataset$Date[1:120],"%d/%m/%Y"),scores$RC1[1:120],type="o",col=4,
xlab="Year", ylab="RC1 & RC2",
main="",pch="*")
lines(as.Date(cities_dataset$Date[1:120],"%d/%m/%Y"),scores$RC2[1:120],col="red",type="o",pch="+")
#legend("topright", inset=c(-0.8,0), legend=c("A","B"), pch=c(1,3), title="Group")
legend( x= "bottomleft", y=0.72, 
        legend=c("RC1","RC2"), 
        col=c("blue", "red"),   
        pch=c("+","*"),inset=c(1.02,0.6))

plot(as.Date(cities_dataset$Date[120:240],"%d/%m/%Y"),scores$RC1[120:240],type="o",col=4,
xlab="Year", ylab="RC1 & RC2",
main="",pch="*")
lines(as.Date(cities_dataset$Date[120:240],"%d/%m/%Y"),scores$RC2[120:240],col="red",type="o",pch="+")
legend( x= "bottomleft", y=0.72, 
        legend=c("RC1","RC2"), 
        col=c("blue", "red"),   
        pch=c("+","*"),inset=c(1.02,0.6))



plot(as.Date(cities_dataset$Date[240:360],"%d/%m/%Y"),scores$RC1[240:360],type="o",col=4,
     xlab="Year", ylab="RC1 & RC2",
     main="",pch="*")
lines(as.Date(cities_dataset$Date[240:360],"%d/%m/%Y"),scores$RC2[240:360],col="red",type="o",pch="+")
legend( x= "bottomleft", y=0.72, 
        legend=c("RC1","RC2"), 
        col=c("blue", "red"),   
        pch=c("+","*"),inset=c(1.02,0.6))

plot(as.Date(cities_dataset$Date[360:480],"%d/%m/%Y"),scores$RC1[360:480],type="o",col=4,
     xlab="Year", ylab="RC1 & RC2",
     main="",pch="*")
lines(as.Date(cities_dataset$Date[360:480],"%d/%m/%Y"),scores$RC2[360:480],col="red",type="o",pch="+")
legend( x= "bottomleft", y=0.72, 
        legend=c("RC1","RC2"), 
        col=c("blue", "red"),   
        pch=c("+","*"),inset=c(1.02,0.6))


plot(as.Date(cities_dataset$Date[480:600],"%d/%m/%Y"),scores$RC1[480:600],type="o",col=4,
     xlab="Year", ylab="RC1 & RC2",
     main="",pch="*")
lines(as.Date(cities_dataset$Date[480:600],"%d/%m/%Y"),scores$RC2[480:600],col="red",type="o",pch="+")
legend( x= "bottomleft", y=0.72, 
        legend=c("RC1","RC2"), 
        col=c("blue", "red"),   
        pch=c("+","*"),inset=c(1.02,0.6))
pc2$loadings


biplot(pc2, scale = 0)

pc2$loadings

