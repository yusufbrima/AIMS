data_mortality =  read.csv("data_mortality.csv",header=T)

# (a) Calculate death rates on the log scale, logRate, and append it to the dataset.
data_mortality$logDeath <- log(data_mortality$Deaths/data_mortality$Exposure)


# Compare death rates of males and females aged 50 using graphic. Comments

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





# Building the GLM

model1 <-  glm(cbind(Deaths,Exposure - Deaths) ~ Age + Year, data = data_mortality, family=binomial)

summary(model1)


# Build a GLM to explain mortality rate in terms of Age,
# Calendar year, and Gender, assuming binomial distribution
# about death counts. Interpret the coefficients of your model.

