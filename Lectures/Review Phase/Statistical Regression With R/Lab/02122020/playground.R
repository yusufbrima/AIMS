data =  read.table("data_simulated.csv",sep=",",header = T)

attach(data) 

x_bar =  sum(x)/length(x)
y1_bar = sum(y1)/length(y1)

var_x =  (sum((x - x_bar)^2) )/(length(x) -1 )

var_y1 =  (sum((y1 - y1_bar)^2) )/(length(y1) -1 )


covar_x_y = ( sum((x -  x_bar) * (y1 -  y_bar)))/(length(x) -1 )


corr = covar_x_y/(var_x * var_y1) * 0.5


mycor <- function(a,b){
  a_bar =  sum(a)/length(a)
  b_bar = sum(b)/length(b)
  return(a)
}
