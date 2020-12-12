# Linear Programming in R

library(lpSolve)

# solve <- function(obj,constr,constr_dir,rhs){
#   
#   prod.sol =  lp(direction = "max",objective.in = obj.fun,const.mat = constr,const.dir = constr_dir,const.rhs = rhs,
#                  compute.sens = TRUE)
# }

obj.fun <- c(170,160,175,180,195)
constr <-  matrix(c(1,0,0,0,0, 1,1,0,0,0, 1,1,1,0,0, 0,1,1,0,0, 0,0,1,1,0, 0,0,1,1,0,  0,0,0,1,0, 0,0,0,1,1, 0,0,0,0,1),ncol = 5,byrow = TRUE)

constr_dir <- c(">=",">=",">=",">=",">=",">=",">=",">=",">=")

rhs <-  c(48,79,87,64,73,82,43,52,15)

# solving model

prod.sol =  lp(direction = "min",objective.in = obj.fun,const.mat = constr,const.dir = constr_dir,const.rhs = rhs,
               compute.sens = TRUE)


# Accessing R output

prod.sol$objval #objective function value

prod.sol$solution #decision variables values

prod.sol$duals #Includes dual of constraints cost variables 