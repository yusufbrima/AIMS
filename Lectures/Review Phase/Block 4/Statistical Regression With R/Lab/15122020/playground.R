data_mortality =  read.csv("data_mortality.csv",header=T)

# (a) Calculate death rates on the log scale, logRate, and append it to the dataset.
data_mortality$logDeath <- log(data_mortality$Deaths/data_mortality$Exposure)


#b Compare death rates of males and females aged 50 using graphic. Comments

male_deaths =  data_mortality[data_mortality$Gender == "M" & data_mortality$Age == 50,]

female_deaths =  data_mortality[data_mortality$Gender == "F" & data_mortality$Age == 50,]

# par(mfrow=c(1,2))
plot(female_deaths$Year,female_deaths$logDeath,xlab="Calender Year",
     main = "Male aged 50 log death rates",ylab ="Log Death Rate",
     ylim=c(min(male_deaths$logDeath,female_deaths$logDeath),max(male_deaths$logDeath,female_deaths$logDeath) ))
points(female_deaths$Year,female_deaths$logDeath,col="brown",pch=2)

plot(female_deaths$Year,female_deaths$logDeath,xlab="Calender Year",
     main = "Male aged 50 log death rates",ylab ="Log Death Rate",
     ylim=c(min(male_deaths$logDeath,female_deaths$logDeath),max(male_deaths$logDeath,female_deaths$logDeath) ))
points(male_deaths$Year,male_deaths$logDeath,col="red",pch=3)




#b Compare death rates of males and females aged 50 using graphic. Comments

index_rows_F1986 <- c(1:nrow((data_mortality)))[data_mortality$Gender == "F" & data_mortality$Year == "1986"]
y_female_1986  <-  data_mortality$logDeath[index_rows_F1986]
x_female_1986 <- data_mortality$Age[index_rows_F1986]
 
index_rows_F2000 <- c(1:nrow((data_mortality)))[data_mortality$Gender == "F" & data_mortality$Year == "2000"]
y_female_2000  <-  data_mortality$logDeath[index_rows_F2000]
x_female_2000 <- data_mortality$Age[index_rows_F2000]


index_rows_M2000 <- c(1:nrow((data_mortality)))[data_mortality$Gender == "M" & data_mortality$Year == "2000"]
y_male_2000  <-  data_mortality$logDeath[index_rows_M2000]
x_male_2000 <- data_mortality$Age[index_rows_M2000]

plot(y_female_1986~x_female_1986,ylim=c(min(y_female_1986,y_male_1986),max(y_female_1986,y_male_1986)),
     main="Exploratory Data Analysis",xlab="Age",ylab="Log Death Rate")

points(y_female_2000~x_female_2000,col="brown",pch=4)

points(y_male_1986~x_male_1986,col="red",pch=8)

points(y_male_2000~x_male_2000,col="green",pch=3)

legend(20, -5.5, legend=c("Female 1986", "Female 2000","Male 1986","Male 2000"),col=c("black","red", "blue"),
       lty=1:4, cex=0.8)

# Building the GLM

model1 <-  glm(cbind(Deaths,Exposure - Deaths) ~ Age + Year, data = data_mortality, family=binomial)
2000
summary(model1)


# Build a GLM to explain mortality rate in terms of Age,
# Calendar year, and Gender, assuming binomial distribution
# about death counts. Interpret the coefficients of your model.

model2 = glm(cbind(Deaths,Exposure - Deaths) ~ Age + Year + Gender, data = data_mortality, family=binomial)
summary(model2) 


# Compare the models obtained in d) and e).
dif_dev  <- deviance(model1) - deviance(model2)

pchisq(dif_dev,1,lower.tail = F) # Gender contributes to model performance

# 
# Compare death rates of males and females at all ages and all
# calendar years using a 3D graphic. The R function plot3D()
# might be useful. Comments


install.packages("rgl")
library(rgl)

plot3d(x =  data_mortality$Age[data_mortality$Gender == "F"], 
       y = data_mortality$Year[data_mortality$Gender == "F"],
       z = data_mortality$logDeath[data_mortality$Gender == "F"],
       xlab="Age",ylab= "Year",zlab = "Log Death Rate", col="red")


# Creating color keys for males and females

data_mortality$col_key <-  "pink"

data_mortality$col_key[data_mortality$Gender == "M"] <- "black"

plot3d(x =  data_mortality$Age, 
       y = data_mortality$Year,
       z = data_mortality$logDeath,
       xlab="Age",ylab= "Year",zlab = "Log Death Rate", col=data_mortality$col_key)

