# Linear Programming in R

library(lpSolve)

solve <- function(obj,constr,constr_dir,rhs){
  
  prod.sol =  lp(direction = "max",objective.in = obj.fun,const.mat = constr,const.dir = constr_dir,const.rhs = rhs,
                 compute.sens = TRUE)
}

obj.fun <- c(20,60)
constr <-  matrix(c(30,20,5,10,1,1),ncol = 2,byrow = TRUE)

constr_dir <- c("<=","<=",">=")

rhs <-  c(2700,850,95)

# solving model

prod.sol =  lp(direction = "max",objective.in = obj.fun,const.mat = constr,const.dir = constr_dir,const.rhs = rhs,
               compute.sens = TRUE)


# Accessing R output

prod.sol$objval #objective function value

prod.sol$solution #decision variables values

prod.sol$duals #Includes dual of constraints cost variables 