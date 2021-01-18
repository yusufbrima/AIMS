library(class)
library(ROCR)
library(ggplot2)
library(caret)
library(yardstick)
library(corrplot)
library(xtable)
library(ggfortify)
library(devtools)
set.seed (19671210) 

#### Exercise 3:

### Exercise 3 (1) 1NN 

library(mnist)
mnist <- download_mnist()
n <- nrow(mnist)
p <- ncol(mnist) - 1
pos <- p + 1

 #with(mnist[mnist$Label == "5" | mnist$Label ==  "7"])

dataset = with(mnist, mnist[ (mnist$Label == "1") | (mnist$Label=="7"), ])
eta = 0.85
n = dim(dataset)[1]
ntr =  ceiling(n * eta)
dataset$Label <- droplevels(dataset$Label) #To drop unused Levels

mnist_train <- head(dataset, ntr)
mnist_test <- tail(dataset, n -ntr )

xtrain <- mnist_train[,-pos]
ytrain <- mnist_train[, pos]
xtest <- mnist_test[, -pos]
ytest <- mnist_test[, pos]
nte <- dim(xtest)[1]  

ninepics <- sample(sample(sample(n)))[1:9]
par(mfrow=c(3,3))
for(i in 1:9)
{
show_digit(dataset, ninepics[i])
}

#function to plot accuracy and error metrics
print_metrics <- function(conf.mat,nte){
    # Percentage of correctly classified (accurary)

    pcc <- sum(diag(conf.mat))/nte

    # Test Error
  
    err <- 1-pcc                   # Complement of accurary
    err.te
    return(pcc,err)
}


### 1NN  
k <- 1

                              # True responses in train set
y.tr.hat <- knn(xtrain, xtrain, ytrain, k=k) # Predicted responses in test set

conf.mat.tr <- table(ytrain, y.tr.hat)
conf.mat.tr

                              # True responses in test set
y.te.hat <- knn(xtrain, xtest, ytrain, k=k) # Predicted responses in test set

conf.mat.te <- table(ytest, y.te.hat)
conf.mat.te

#### 7NN
k <- 7

                              # True responses in train set
y.tr.hat <- knn(xtrain, xtrain, ytrain, k=k) # Predicted responses in test set

conf.mat.tr <- table(ytrain, y.tr.hat)
conf.mat.tr

# True responses in test set
y.te.hat <- knn(xtrain, xtest, ytrain, k=k) # Predicted responses in test set
  
conf.mat.te <- table(ytest, y.te.hat)
conf.mat.te

#### 9NN
k <- 9
                              # True responses in train set
y.tr.hat <- knn(xtrain, xtrain, ytrain, k=k) # Predicted responses in test set

conf.mat.tr <- table(ytrain, y.tr.hat)
conf.mat.tr

                              # True responses in test set
y.te.hat <- knn(xtrain, xtest, ytrain, k=k) # Predicted responses in test set
  
conf.mat.te <- table(ytest, y.te.hat)
conf.mat.te



#### Exercise 3 (2) ROC Curves
  
y.roc   <- as.factor(dataset$Label)



y.roc   <- as.factor(dataset$Label)
  
kNN.mod <- y.te.hat <- knn(xtrain, xtest, ytrain, k=1,prob=TRUE) 
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "1", 1-prob, prob) - 1
  
pred.1NN <- prediction(prob, ytest)
perf.1NN <- performance(pred.1NN, measure='tpr', x.measure='fpr')
  
kNN.mod <- class::knn(xtrain, xtest, ytrain, k=7, prob=TRUE)
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "1", 1-prob, prob) - 1
  
pred.7NN <- prediction(prob, ytest)
perf.7NN <- performance(pred.7NN, measure='tpr', x.measure='fpr')
  
kNN.mod <- class::knn(xtrain, xtest, ytrain, k=9, prob=TRUE)
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "1", 1-prob, prob) - 1
  
pred.9NN <- prediction(prob, ytest)
perf.9NN <- performance(pred.9NN, measure='tpr', x.measure='fpr')
  
plot(perf.1NN, col=2, lwd= 2, lty=2, main=paste('Comparative ROC curves in Testing'))
plot(perf.7NN, col=3, lwd= 2, lty=3, add=TRUE)
plot(perf.9NN, col=4, lwd= 2, lty=4, add=TRUE)
abline(a=0,b=1)
legend('bottomright', inset=0.05, c('1NN','7NN', '9NN'),  col=2:4, lty=2:4)

### Exercise 3 (3)
fp = xtest[which(y.te.hat == 1  &   ytest == 7),] 

falsepositivepics <- sample(sample(sample(dim(fp)[1])))[1:6]
par(mfrow=c(2,3))
for(i in 1:6)
{
show_digit(fp, falsepositivepics[i])
}


### Exercise 3 (4)
mnist.pca <- prcomp(xtrain)

autoplot(mnist.pca, data = xtrain)   + theme_minimal()

#pca.plot <- autoplot(mnist.pca, data = xtrain, colour = 'Positive')
#pca.plot



#### Exercise 4


### For 1NN, 3NN, 5NN and 7NN

prostate <- read.csv('../001/datasets/prostate-cancer-1.csv')

xtrain = prostate[,2:501] ##data matrix for prostate 
ytrain  = prostate[,1] ##class labels for prostate 
n  <- dim(prostate)[1]  ##Number of training sample
p <- dim(prostate)[2] -1 # Dimensionaltiy of the input space

y.roc   <- as.factor(ytrain)

## 1NN
kNN.mod <- y.te.hat <- knn(xtrain, xtrain, ytrain, k=1,prob=TRUE) 
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "0", 1-prob, prob) - 1
  
pred.1NN <- prediction(prob, ytrain)
perf.1NN <- performance(pred.1NN, measure='tpr', x.measure='fpr')

## 3NN
kNN.mod <- class::knn(xtrain, xtrain, ytrain, k=3, prob=TRUE)
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "0", 1-prob, prob) - 1
  
pred.3NN <- prediction(prob, ytrain)
perf.3NN <- performance(pred.3NN, measure='tpr', x.measure='fpr')

## 5NN
kNN.mod <- class::knn(xtrain, xtrain, ytrain, k=5, prob=TRUE)
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "0", 1-prob, prob) - 1
  
pred.5NN <- prediction(prob, ytrain)
perf.5NN <- performance(pred.5NN, measure='tpr', x.measure='fpr')

## 7NN
kNN.mod <- class::knn(xtrain, xtrain, ytrain, k=7, prob=TRUE)
prob    <- attr(kNN.mod, 'prob')
prob    <- 2*ifelse(kNN.mod == "0", 1-prob, prob) - 1
  
pred.7NN <- prediction(prob, ytrain)
perf.7NN <- performance(pred.7NN, measure='tpr', x.measure='fpr')
  
plot(perf.1NN, col=2, lwd= 2, lty=2, main=paste('Comparative ROC curves in Training'))
plot(perf.3NN, col=4, lwd= 2, lty=4, add=TRUE)
plot(perf.5NN, col=5, lwd= 2, lty=4, add=TRUE)
plot(perf.7NN, col=3, lwd= 2, lty=3, add=TRUE)
abline(a=0,b=1)
legend('bottomright', inset=0.05, c('1NN','3NN', '5NN', '7NN'),  col=2:4, lty=2:4)

### 4  (3)  Comment on the ROC

# From the ROC Curve, it is clear that 1NN has the highest model complexity whilst 7NN has the 
# least model complexity. Therefore, according to Ocam's Razor, the model with the least complexity 
# must be preferred.


### 4 (4) Using Stochastic Holdout to train the model
set.seed(19671210)
y =  ytrain
x  =  xtrain

stratified.holdout <- function(y, ptr)
{
  n              <- length(y)
  labels         <- unique(y)       # Obtain classifiers
  id.tr <- id.te <- NULL
  # Loop once for each unique label value
  
  y <- sample(sample(sample(y)))
  
  for(j in 1:length(labels)) 
  {
    sj    <- which(y==labels[j])  # Grab all rows of label type j  
    nj    <- length(sj)           # Count of label j rows to calc proportion below
    
    id.tr <- c(id.tr, (sample(sample(sample(sj))))[1:round(nj*ptr)])
  }                               # Concatenates each label type together 1 by 1
  
  id.te  <- (1:n) [-id.tr]          # Obtain and Shuffle test indices to randomize                                
  
  return(list(idx1=id.tr,idx2=id.te)) 
}  

# 
# Extract the optimal k yielded by cross validation 
#  
  k.opt.cv <- 9 #max(which(cv.error==min(cv.error)))
 
##############################################################
# Using the optimally tuned k let's estimate the test error  #
##############################################################
  
  set.seed (19671210)          # Set seed for random number generation to be reproducible
  
  epsilon <- 1/3               # Proportion of observations in the test set
  nte     <- round(n*epsilon)  # Number of observations in the test set
  ntr     <- n - nte
  pos =  1
  #k.opt.cv <- 28
  
  R <- 100   # Number of replications
  test.err <- numeric(R)
  
  for(r in 1:R)
  {
    # Split the data
    
    hold <- stratified.holdout(as.factor(prostate[,pos]), 1-epsilon) 
    id.tr <- hold$idx1
    id.te <- hold$idx2
    ntr   <- length(id.tr)
    nte   <- length(id.te)
  
    y.te         <- y[id.te]                    # True responses in test set
    y.te.hat     <- knn(x[id.tr,], x[id.te,], y[id.tr], k=k.opt.cv) # Predicted responses in test set
    ind.err.te   <- ifelse(y.te!=y.te.hat,1,0)    # Random variable tracking error. Indicator
    test.err[r]  <- mean(ind.err.te)
  }  
  
  test <- data.frame(test.err)
  colnames(test) <- c('error')
  
  ggplot(test, aes(x='', y=error))+geom_boxplot()+
  labs(x='Method', y=expression(hat(R)[te](kNN)))


