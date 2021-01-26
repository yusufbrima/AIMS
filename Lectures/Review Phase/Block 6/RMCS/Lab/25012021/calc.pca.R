rm(list=ls())

#opening the file
egs=read.table('Droughts.txt',skip=22,header=T)


# Removing Year and Month
xx=egs[,3:18]

# Replacing the missing values (-999) with -2.33

xx[xx==-999]=-2.33

# calculating the PCA

pp=prcomp(xx,center=T,scale=T)


#Scree plot

 screeplot(pp,type='l',lwd=3,main='Scree Plot')

#loadings

# Matching the STATISTICA ouput 

mm=array(NA,c(16,16))

for (i in 1:16){
mm[,i]=pp$rotation[,i]*pp$sdev[i]
}

rownames(mm)=names(xx)
colnames(mm)=colnames(pp$rotation)


print('#######################################')
print('##  FIRTS FIVE  LOADINGS              #')
print('#######################################')

print(mm[,1:5])


# Explained variance

ev=round(pp$sdev^2/sum(pp$sdev^2)*100,2)



print('#########################################')
print('##  EXPLAINED VARIANCE (IN %)           #')
print('#########################################')

print(ev)





