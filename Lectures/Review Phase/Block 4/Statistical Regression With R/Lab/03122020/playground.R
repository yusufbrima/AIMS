data_loader <- function(file_path,separator){
  
  data =  read.table(file_path,header = TRUE,sep=separator)
  return(data)
}


salaries =  data_loader("data_salaries.csv",",")

attach(salaries)
plot(salaries$YearsExperience,salaries$Salary,main = "Exploratory analysis",xlab = "Years of experience",
     ylab = "Salary", col="blue"
     )

correlation  <- function(x,y){
  x_bar =   sum(x)/ length(x)
  y_bar =  sum(y)/length(y)
  x_var =  sum((x - x_bar)^2)/(length((x) - 1))
  y_var =  sum((y - y_bar)^2)/(length((y) - 1))
  covar_x_y =  sum((x - x_bar) * (y-y_bar))/ (length((y) - 1))
  
  corr =  covar_x_y/ sqrt(x_var * y_var)
  
  return(corr)
}

corr =  correlation(salaries$YearsExperience,salaries$Salary)

linear_regression <-function(x,y){
  x_bar =   sum(x)/ length(x)
  y_bar =  sum(y)/length(y)
  beta_1 =  sum((x - x_bar) * y)/ sum((x - x_bar)^2)
  
  beta_0 = y_bar -  beta_1 * x_bar
  return(list(beta_0,beta_1))
}

betas =  linear_regression(YearsExperience,Salary)

beta_0 = betas[[1]]

beta_1 = betas[[2]]


regressor <- function(x,beta_0,beta_1){
  return(beta_0 + beta_1 * x)
}

x <- 11
print(regressor(x,beta_0,beta_1))

res =  regressor(YearsExperience,beta_0,beta_1)
# 
# plot(YearsExperience,res)
