library(corrplot)
library(graphics)
library(psych)
library("ggplot2")


#Question 2

prostate <- read.csv('datasets/prostate-cancer-1.csv')  # DNA MicroArray Gene Expression

head(prostate)



# 2.2

barplot(table(prostate$Y),
        main="Distribution of response Y",col=c("blue","brown"),names=c("0","1"),ylab="Frequency")

# 2.3
dim(prostate)


# 2.4
boxplot(prostate$X206212_at,prostate$X207075_at,prostate$X215872_at,
                 prostate$X201876_at,prostate$X211935_at,prostate$X206788_s_at,
                prostate$X216441_at,prostate$X209290_s_at,
                prostate$X219877_at,prostate$X220675_s_at,col =c("brown"), names=c("x1","x2","x3","x4","x5","x6"
                                                                                  ,"x7","x8","x9","x10"),main="Selected predictor variables")


# 
# pairs(data.frame(prostate$Y,prostate$X206212_at,prostate$X207075_at,prostate$X215872_at,
#                  prostate$X201876_at,prostate$X211935_at,prostate$X206788_s_at,
#                 prostate$X216441_at,prostate$X209290_s_at,
#                 prostate$X219877_at),col="brown",lower.panel=NULL)

pairs.panels(data.frame(prostate$Y,prostate$X206212_at,prostate$X207075_at,prostate$X215872_at,
                 prostate$X201876_at,prostate$X211935_at,prostate$X206788_s_at,
                prostate$X216441_at,prostate$X209290_s_at,
                prostate$X219877_at), 
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = FALSE # show correlation ellipses
             )

# Question 4
gifted <- read.csv('datasets/gifted.csv') 

#4.1

pairs(gifted,col="brown",lower.panel=NULL)

#4.2
round(cor(gifted),2)
corrplot(cor(gifted))

#4.3
hist(gifted$score, col=c("brown"), xlab ="Scores" , main = "Histogram of Scores")


m<-mean(gifted$score)
std<-sqrt(var(gifted$score))
hist(gifted$score, density=20, breaks=10, prob=TRUE, 
     xlab="Scores", ylim=c(0, 0.15), 
     main="Guassian Curve over histogram of Scores",col="brown")
curve(dnorm(x, mean=m, sd=std), 
      col="darkblue", lwd=2, add=TRUE, yaxt="n")

shapiro.test(gifted$score)
# 4.4 
#We are building a Simple Linear Regression Model
model1 <-  lm(score ~ motheriq, data =  gifted)

par(mfrow = c(2, 2))

plot(model1,col="blue")



new.motheriq <- data.frame(
  motheriq = gifted$motheriq
)



# 4.7 
#Prediction interval
p.interval <- predict(model1, newdata = new.motheriq,  interval = "prediction")

dataset <- cbind(gifted, p.interval)


p <- ggplot(dataset, aes(motheriq, score)) +
  geom_point() +
  stat_smooth(method = lm)
# 3. Add prediction intervals
p + geom_line(aes(y = lwr), color = "red", linetype = "dashed")+
    geom_line(aes(y = upr), color = "red", linetype = "dashed")


#For the confidence interval

c.interval <- predict(model1, newdata = new.motheriq,  interval = "confidence")
dataset_updated <- cbind(gifted, c.interval)


p <- ggplot(dataset_updated, aes(motheriq, score)) +
  geom_point() +
  stat_smooth(method = lm)
# 3. Add prediction intervals
p + geom_line(aes(y = lwr), color = "red", linetype = "dashed")+
    geom_line(aes(y = upr), color = "red", linetype = "dashed")

#4.8 
#We are building a Multiple Linear Regression Model
model2 <-  lm(score ~ motheriq + fatheriq + speak + count + read + edutv +  cartoons, data =  gifted)

summary(model2)

par(mfrow = c(2, 2))

plot(model2,col="blue")

#Prediction interval
pred_data <- data.frame(
  motheriq = gifted$motheriq, 
  fatheriq = gifted$fatheriq,
  speak = gifted$speak,
  count = gifted$count,
  read = gifted$read,
  edutv = gifted$edutv,
  cartoons = gifted$cartoons
)


p.interval <- predict(model2, newdata = pred_data,  interval = "prediction")

dataset <- cbind(gifted, p.interval)


p <- ggplot(dataset, aes(motheriq, score)) +
  geom_point() +
  stat_smooth(method = lm)
# 3. Add prediction intervals
p + geom_line(aes(y = lwr), color = "red", linetype = "dashed")+
    geom_line(aes(y = upr), color = "red", linetype = "dashed")


#For the confidence interval

c.interval <- predict(model1, newdata = pred_data,  interval = "confidence")
dataset_updated <- cbind(gifted, c.interval)


p <- ggplot(dataset_updated, aes(motheriq, score)) +
  geom_point() +
  stat_smooth(method = lm)
# 3. Add prediction intervals
p + geom_line(aes(y = lwr), color = "red", linetype = "dashed")+
    geom_line(aes(y = upr), color = "red", linetype = "dashed")


