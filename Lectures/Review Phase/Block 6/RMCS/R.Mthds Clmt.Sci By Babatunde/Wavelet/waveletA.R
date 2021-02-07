# This script calculates the wavelet coherence 
# for detrended and non detrended data
#install.packages("devtools")
#devtools::install_github("tgouhier/biwavelet")
# Removing  all variables
#install.packages("zoo")
#install.packages("biwavelet")
rm(list=ls())# remove all the objects in 'R' working terminal

# importing the libraries
 library(biwavelet)
 library(zoo)

# opening the file with data
#data = read.table(file.choose(),header = T)
data <-read.csv("Goma2.csv")

#View(data)
str(data)
###non-detrended data
x=data$PRED 
y=data$TMPD # Replace with "MEI"    "NINO34" "QBO"    "SOI"    "AO"  "ONI"    "WP"
#x[x==-999]=NA
#x[is.na(x)]=mean(x,na.rm=T)
#y[is.na(y)]=mean(y,na.rm=T) 
timelong=seq(1960, 2011-1/12, 1/12)  # indexing

waveletP=wt(cbind(timelong,x),dj=0.1,mother="morlet",max.scale=9) #wavelet
waveletT=wt(cbind(timelong,y),dj=0.1,mother="morlet",max.scale=9) #wavelet
wcoh=wtc(cbind(timelong,x),cbind(timelong,y),dj=0.1,mother="morlet",max.scale=9) # wavelet coherence calculation

png('wavelet_coherence.png')# Saving the graph
par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1) #To allow for colour bar to be included
plot(wcoh,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",
     lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=T,ylab="Period(Year)", xlab = "Time(Year)") #plotting
dev.off()
png('waveletP.png')
par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1)
plot(waveletP,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",
     lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=F,ylab="Period(Year)", xlab = "Time(Year)"  )
dev.off()
png('waveletT.png')
par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1)
plot(waveletT,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",
     lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=F,ylab="Period(Year)", xlab = "Time(Year)")
dev.off()

### Detrended data
#mx=lm(coredata(x)~index(x),na.action=na.omit)         ### Linear regression
#x.detrended=zoo(resid(mx),index(x)) # detrending

my=lm(coredata(y)~index(y),na.action=na.omit)  ### Linear regression
y.detrended=zoo(resid(my),index(y)) # detrending

timelong=seq(1960, 2011-1/12, 1/12)  # indexing
wcoh.detrended=wtc(cbind(timelong,as.data.frame(x)),cbind(timelong,as.data.frame(y.detrended)),dj=0.1,mother="morlet",max.scale=9)# wavelet coherence calculation
wavelet.detrended=wt(cbind(timelong,as.data.frame(y.detrended)),dj=0.1,mother="morlet",max.scale=9)
png('wavelet_coherenceD.png')		# Saving the graph
par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1) #To allow for colour bar to be included
plot(wcoh.detrended,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=T,ylab="Period(Year)", xlab = "Time(Year)") #plotting
dev.off()
#png('waveletDP.png')
#par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1)
#plot(wavelet.detrended,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=T,ylab="Period(Year)", xlab = "Time(Year)")
#dev.off()

png('waveletDT.png')
par(oma=c(0, 0, 0, 1), mar=c(5, 4, 4, 5) + 0.1)
plot(wavelet.detrended,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",
     lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=F,ylab="Period(Year)", xlab = "Time(Year)")
#plot(wavelet.detrended,  plot.cb = TRUE,lwd.coi = 1,col.coi="white",alpha.coi=0.5,col.sig="black",lwd.sig = 2, ncol = 768, tol = 0.95, plot.phase=T,ylab="Period(Year)", xlab = "Time(Year)")
dev.off()

# Arrows pointing to the right mean that x and y are in phase.

#Arrows pointing to the left mean that x and y are in anti-phase.

#Arrows pointing up mean that y leads x by π/2.

#Arrows pointing down mean that x leads y by π/2. 






