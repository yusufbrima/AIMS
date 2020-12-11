library(corrplot)
data =  read.csv("../09122020/data_medical_charges.csv",header = T)
data$region = factor(x = data$region,levels =(unique(data$region)), )

model1 = lm(charges ~ age + bmi+ sex,data =  data)

summary(model1)


model2 = lm(charges ~ age + bmi+ sex + region,data =  data)

summary(model2)



model3 = lm(charges ~ age + bmi+ sex + region,data =  data)

summary(model3)


