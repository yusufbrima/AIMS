
library(lpSolve)

solve <- function(obj,constr,constr_dir,rhs,meth){

  prod.sol =  lp(direction = meth,objective.in = obj.fun,const.mat = constr,const.dir = constr_dir,const.rhs = rhs,
                 compute.sens = TRUE)
  return(prod.sol)
}
# 
# obj.fun <- c(120,190,180)
# 
# constr <-  matrix(c(0.30,0.30,0.30,0.25,0.50,0.45,0.30,0,0,0,0.60,0.50),ncol = 3,byrow = TRUE)
# 
# constr_dir <- c("<=","<=","<=","<=")
# 
# rhs <-  c(800,800,570,840)
# 
# # solving model
# 
# prod.sol = solve(obj,constr,constr_dir,rhs)
# 
# # Accessing R output
# 
# prod.sol$objval #objective function value



# 
# obj.fun <- c(1,-3,2)
# 
# constr <-  matrix(c(3,-1,2,-4,3,8,-1,2,0),ncol = 3,byrow = TRUE)
# 
# constr_dir <- c("<=","<=","<=")
# 
# rhs <-  c(7,10,6)
# 
# # solving model
# meth = "min"
# prod.sol = solve(obj,constr,constr_dir,rhs,meth)
# 
# # Accessing R output
# 
# prod.sol$objval #objective function value





obj.fun <- c(30,20)

constr <-  matrix(c(2,1,1,1,1,0),ncol = 2,byrow = TRUE)

constr_dir <- c("<=","<=","<=")

rhs <-  c(100,80,40)

# solving model
meth = "max"
prod.sol = solve(obj,constr,constr_dir,rhs,meth)

# Accessing R output

prod.sol$objval #objective function value