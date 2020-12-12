#Install package to plot correlation matrix
#install.packages("corrplot")


#function to compute coefficient of linear correlation between two independent random variables
corr_arr <- function(a,b){
  
  corr = 0
  a_bar <-  sum(a)/length(a)
  
  b_bar <- sum(b)/length(b)
  
  var_a  =  sum((a - a_bar)^2)/(length(a) - 1)
  
  var_b  =  sum((b - b_bar)^2)/(length(b) - 1)
  
  covar_a_b =  sum((a -  a_bar) * (b -  b_bar))/ (length(b) - 1)
  
  corr = covar_a_b/sqrt(var_a * var_b)
  return(corr)
}


#function to compute and build the correlation matrix between the variables under our observation
display_correlation  <-  function(data){
  #we are encoding the sex feature (F,M) -> (1,2)
  data$City_Category = as.numeric(factor(data$City_Category,levels = c(unique(data$City_Category)),labels = c(1, 2,3)))
  data$Gender = as.numeric(factor(data$Gender,levels = c("F","M"),labels = c(1, 2)))
  result <- matrix(, nrow = ncol(data), ncol =ncol(data))
  for (i in  1:ncol(data)){
    for (j in 1:ncol(data)){
      result[i,j] <- corr_arr(data[,i],data[,j])
    }
  }
  colnames(result) <- colnames(data)
  rownames(result) <- colnames(data)
  return(result)
}


##We load the data 
data <-  read.csv("data_purchase_behaviour.csv",header = T)
data$X <- NULL
#We attach the data to give the column names global scope
attach(data)


#We are observing the correlation between the variables in the dataset
res <-  display_correlation(data)


#basic visualizations 


options(repr.plot.width=12, repr.plot.height=6)
par(mfrow=c(2,2))
# make labels and margins smaller
par(cex=0.4,mai=c(0.2,0.3,0.4,0.2))
corrplot::corrplot(res,method="color",title="Correlation matrix")

##We are visualizing marital status
ms =  table(data$Marital_Status)
barplot(ms,main = "A plot of marital status with respect to total purchases",
        ylab = "Frequency",xlab ="Marital status",col=c("black","brown"),names=c("Otherwise","Married"))

##We are inspecting gender categories as per total purchases
gen =  table(data$Gender)
barplot(gen,main = "A plot of gender status with respect to total purchases",
        ylab = "Frequency",xlab ="Gender",col=c("black","brown"),names=c("Female","Male"))


cc =  table(data$City_Category)
barplot(cc,main = "A plot of City categories status with respect to total purchases",
        ylab = "Frequency",xlab ="City Categories",col=c("black","brown","blue"),names=c("A","B","C"))

#boxplot(Age_num,Purchase,col="brown")



print(res)

summary(data,digits=4)

##Model selection phase 
model1 =  lm(Purchase~Gender+City_Category+Stay_In_Current_City_Years+Marital_Status+Age_num,data=data)


summary(model1)

model2 =  lm(Purchase~Gender+City_Category++Age_num,data=data)

summary(model2)

options(repr.plot.width=14, repr.plot.height=8)
par(mfrow=c(2,2))
# make labels and margins smaller
par(cex=0.4,mai=c(0.2,0.3,0.4,0.2))
##Test of assumptions
plot(model2,which=1) #Linearity Assumption


plot(model2,which=2) #Normality Assumption

plot(model2,which=3) #Scale-Location (homoscedasticity)

plot(model2,which=4) #Cook's distance



model3 =  lm(Purchase~Gender + Age_num,data=data)
summary(model3)

## Comparison of the two models

anova(model2,model3)



