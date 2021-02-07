library(kohonen)

#loading the data 

data =  read.csv(file.choose(),header = T)
View(data)
cities <- data[,2:11]

X <-  scale(cities)

#SOM
set.seed(13111990)

#We are specifying the grid

g <- somgrid(xdim = 4,ydim = 4, topo = "rectangular")

map = som(X,  grid= g, alpha = c(0.05, 0.01), radius = 1)

plot(map,type = "changes")

plot(map,type = "codes", palette.name = rainbow,main = "4 x 4 SOM" )


plot(map,type = "mapping")



plot(map,type = "dist.neighbours")
