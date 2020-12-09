library(corrplot)
data =  read.csv("data_medical_charges.csv",header = T)


y =  data$charges

age =  data$age 

bmi =  data$bmi

children =  data$children


n <-  length(y)

p <- rep(1,times=n)



X =  matrix(c(p,age,bmi,children),ncol=4)


beta =  solve(t(X)%*% X) %*%t(X)%*%y

x1 = c(1,1,1,2)

x2 = c(1,3,1,2)

y_hat_1 = t(beta)%*%x1

y_hat_2 = t(beta)%*%x2



y_hat = X%*%beta

sigma_hat_squared =  sum((y - y_hat)^2)/(n - dim(X)[2])

cov_matrix =  sigma_hat_squared*solve(t(X)%*%X)
cov_matrix


model1 =  lm(y ~ age + bmi + children, data =  data)


