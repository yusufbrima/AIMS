setwd("/home/gladys/AIMS_19_20/Review Phase/Block 3/R.Mthds Clmt.Sci By Babatunde/PCA")
DD=read.csv('TurkanaCC.csv')
View(DD)
## Checking missing values in the dataset
which(is.na(DD))

#Plotting the original variables and scores
library(reshape2)
datanew=DD[,-c(1)]
dds = scale(datanew)
head(dds)
#sco = scores[,1]
y= c(DD$Years)
ful = cbind(y,dds)
head(y)
df1 <- data.frame(dds, y)
head(df1)
df2 <- melt(df1, id.vars='y')
#df3 = cbind(sco,df2)
head(df2)

library(ggplot2)
pp1 = ggplot() + geom_bar(data=df2,aes(x=y, y=value, fill=variable),stat='identity', position='dodge')+
 geom_line(data = pca2, aes(x=pca2[,1], y=pca2[,2]), color="black")+
  geom_point(data = pca2, aes(x=pca2[,1], y=pca2[,2]))+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
xlab("Years") + ylab("PC1 (58%)")+theme(legend.position="none")

pp2  = ggplot() + geom_bar(data=df2,aes(x=y, y=value, fill=variable),stat='identity', position='dodge')+
  geom_line(data = pca2, aes(x=pca2[,1], y=pca2[,3]), color="black")+
  geom_point(data = pca2, aes(x=pca2[,1], y=pca2[,3]))+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
  xlab("Years") + ylab("PC2 (22%)")+guides(fill=guide_legend(title="Variables"))

pp3 = ggplot() + geom_bar(data=df2,aes(x=y, y=value, fill=variable),stat='identity', position='dodge')+
  geom_line(data = pca2, aes(x=pca2[,1], y=pca2[,4]), color="black")+
  geom_point(data = pca2, aes(x=pca2[,1], y=pca2[,4]))+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
  xlab("Years") + ylab("PC3 (12%)")+theme(legend.position="none")



grid.arrange(pp1, pp2, pp3, nrow=3)



#calculating the PCA
library(ggplot2)
library(factoextra)

pca = prcomp(datanew,center = T,scale. = T,retx = T) 
biplot(pca)




res.pca = prcomp(datanew,center = T,scale. = T,retx = T) 
var <- get_pca_var(res.pca)
var$coord
View(var$coord)

xx = write.csv(var$coord, file="PCcomponents.csv",)
xx1 = write.table(var$coord, file="PCcomponents22.csv",)

fact = unclass(pca)$rotation  # Converting class to matrix

xx = write.csv(fact, file="factors.csv",)

ss = summary(res.pca)$importance
ss1 = write.csv(ss, file="Summary.csv",)

library(psych)
fit <-principal (fact, nfactors=7, rotate="varimax")
print(fit$loadings, cutoff=0.1)

varr = varimax(fact)

plot(pca)   #Selecting the most important factors
plot(pca, type="l") #same as sceeplot    #plot of variance of each PCA.
#It will be useful to decide how many principal components should be retained.
#pcr = varimax(pca$rotation)
##identification of the scores
scores <- pca$x
scores
# identification of the loadings
loadings=pca$rotation
loadings


# Plotting scores

pca2 = data.frame(cbind(DD$Years, scores[,1:3]))

plot(pca2[,1],pca2[,2], xlab = "years", type = "l" )
#plot(pc$scores[,1],pca$scores[,2])

library(ggplot2)
library(scales)
par(mfrow=c(2,2))
require(gridExtra)
p1 = ggplot(pca2, aes(x=pca2[,1], y=pca2[,2], color=pca2[,1])) +
 # geom_bar(data=df2, aes(x=y, y=value, fill=variable))+
  geom_line( color="red")+
  geom_point(color="red")+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
  xlab("Years") + ylab("PC1")

p2 = ggplot(pca2, aes(x=pca2[,1], y=pca2[,3])) +
  # geom_bar( aes(x=pca2[,1], y=pca2[,2], fill=pca2[,2]), stat="identity")+
  geom_line( color="blue")+
  geom_point(color="blue")+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
  xlab("Years") + ylab("PC2")

p3 = ggplot(pca2, aes(x=pca2[,1], y=pca2[,4])) +
  # geom_bar( aes(x=pca2[,1], y=pca2[,2], fill=pca2[,2]), stat="identity")+
  geom_line()+
  geom_point()+
  theme(axis.text.x = element_text(size = 10, angle = 90),
        axis.text.y = element_text(size = 10))+
  scale_x_continuous(limits = c(1960,2010), breaks=seq(1960,2010,1))+
  xlab("Years") + ylab("PC3")
grid.arrange(p1, p2, p3, nrow=3)







# Using princomp to calculate PCA
pc=princomp(datanew, cor = TRUE, scores = TRUE ) 

summary(pc)
attributes(pc)

biplot(pc, scores=0)
plot(pc)



#library(psych)
library(psych)
fit <-principal (pc, nfactors=3, rotate="none",  )
print(fit$loadings,cutoff = 0.3)


pc$loadings
scors = pc$scores
#rownames(scors)=DD$Years
pc2 = data.frame(cbind(DD$Years, scors[,1:3]))



plot(pc2[,1],pc2[,2], xlab = "years", type = "l" )
#plot(pc$scores[,1],pc$scores[,2])


ggplot(pc2, aes(x=pc2[,1], y=pc2[,2], color=pc2[,1])) + geom_line()+geom_point()+ xlab("Years") + ylab("PC1")





#plotting the scree plot
screeplot(pca,type = "l",lwd=2,main = "Scree plot") ##COMMENT THIS PLOT

# Matching the STATISTICA output 

mm=array(NA,c(9,9))

for (i in 1:9){
  mm[,i]=pca$rotation[,i]*pca$sdev[i]
}
rownames(mm)=names(datanew)
colnames(mm)=colnames(pca$rotation)

#Explained variance

ev=round(pca$sdev^2/sum(pca$sdev^2)*100,2)
print(ev)



