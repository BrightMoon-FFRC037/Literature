#  R tutorial - http://kingaa.github.io/R_Tutorial/

# Part I: Interactive calculations
2+2

a <- 2+2

a

# Data class
class(a)

# Use semicolon to separate commonds on a single line 
a <- 2+2; a

# A less-preferred way to assign values to variables
a = 2+2

# About varialbe names:
# You can break up long names with a period, as in long.variable.number.3, an underscore (very_very_long_variable_name), or by using camel case (quiteLongVariableName)
# Note that c, q, t, C, D, F, I, and T, are built-in R functions. 

# Calculations:
x <- 5
y <- 2
z1 <- x*y
z2 <- x/y
z3 <- x^y
z1; z2; z3

A <- 3
C <- (A+2*sqrt(A))/(A+5*sqrt(A)); C


# Part II: Help system
?foo   
# foo is a place holder variable commonly used in programming

help(foo)

?sin

??sin

# clear variables
rm(list = ls())

# send CTRL+L to the console
cat("\014")  


# Part III: Data processing

#Below are some data on the maximum growth rate rmax of laboratory populations of 
# the green alga Chlorella vulgaris as a function of light intensity (μE m−2 s−1). These experiments were run during the system-design phase of the study reported by Fussman et al. (Fussman et al. 2000).
# Note:  c() combines the individual numbers into a vector
Light <- c(20,20,20,20,21,24,44,60,90,94,101)
rmax <- c(1.73,1.65,2.02,1.89,2.61,1.36,2.37,2.08,2.69,2.32,3.67)

# Simple descriptive statistics
mean(Light); sd(Light); var(Light); quantile(Light,0.5)

plot(rmax~Light)

plot(Light, rmax)

# We create a linear model using the lm() function
# rmax is the response variable and Light is the predictor.
fit <- lm(rmax~Light)

summary(fit) # rmax=1.58+0.0136×Light.

abline(fit)


# Data structures in R
# vectors
x <- c(1,3,5,7,9,11)
y <- c(6.5,4.3,9.1,-8.5,0,3.6)
z <- c("dog","cat","dormouse","chinchilla")
w <- c(a=4,b=5.5,c=8.8)

class(w)

names(w)

x <- x+1
xx <- sqrt(x)
x; xx

x+y

# Compute the modulo (%%) or use integer division (%/%).
y%%x
y%/%x

x <- seq(1,10,2)
x

x <- rep(3,5)
rep(1:3,3)
rep(1:3,each=3)

# vector indexing
z <- c(1,3,5,7,9,11)
z[3]
v <- z[c(2,3,4,5)]

lowLight <- Light[Light<50]
lowLightrmax <- rmax[Light<50]

Light[Light<50 | rmax <= 2.0]
rmax[Light<50 | rmax <= 2.0]


# Matrices and arrays
# A matrix is a two-dimensional array of items
X <- matrix(c(1,2,3,4,5,6),nrow=2,ncol=3); X

matrix(1,nrow=10,ncol=10)

matrix(rnorm(35,mean=1,sd=2),nrow=5,ncol=7)

C <- cbind(1:3,4:6,5:7); C
D <- rbind(1:3,4:6); D

# matrix indexing
A <- matrix(0,3,4)
first.row <- A[1,]; first.row


# Arrays:
# The generalization of the matrix to more (or less) than 2 dimensions is the array. 
X <- array(1:24,dim=c(3,4,2)); X

# rbg image stored as a 3-dimensional array
install.packages("countcolors")
library(countcolors)
flowers <- jpeg::readJPEG(system.file("extdata", "flowers.jpg", package = "countcolors"))
plotArrayAsImage(flowers, main = "flowers!")
dim(flowers)


# Factors
# A factor is a variable that can take one of a finite number of distinct levels. 
# To construct a factor, we can apply the factor function to a vector of any class:
x <- rep(c(1,2),each=3); factor(x)

trochee <- c("jetpack","ferret","pizza","lawyer")
trochee <- factor(trochee); trochee

elements <- read.csv(file.path("/mnt/e/SynologyDrive/Teaching", "example.csv"),stringsAsFactors=TRUE)

elements <- read.csv(file.path("/mnt/e/SynologyDrive/Teaching", "example.csv"), stringsAsFactors=FALSE)

class(elements)

# Data frames
data.url <- "http://kingaa.github.io/R_Tutorial/ChlorellaGrowth.csv"
dat <- read.csv(data.url,comment.char='#')
dat


# Apply family of functions
# list apply: lapply, sapply, mapply
x <- list("teenage","mutant","ninja","turtle",
          "hamster","plumber","pickle","baby")
lapply(x,nchar)
sapply(x,nchar)

x <- c("pizza","monster","jigsaw","puddle")
y <- c("cowboy","barbie","slumber","party")

mapply(paste,x,y,sep="/") #If the function had more than one required input, we would use mapply()

# array apply
  # apply() is actually a lot like sapply(): it can take in a data frame (or matrix) and output a vector
A <- array(data=seq_len(15),dim=c(3,5)); A
apply(A,1,sum) 
apply(A,2,sum)
apply(A,1, function(x) sum(x>10))
apply(A,1, function(x) sum(x[x>10]))


## Part IV: ODE models 
#install.packages("deSolve")
library(deSolve)
library(ggplot2)

# Exponential growth:
exp_growth <- function(t, x, parmeters) {
  dx <- p[1]*x[1]
  return(list(dx))
}
p <- 0.5;  t <- seq(from=0, to=20, by = 0.01)
x0 <- c(x = 2) # a named vector

out <- ode(y=x0, times = t, func = exp_growth, parms = p)

ggplot(data = as.data.frame(out), aes(time, x)) + geom_point()


# Logistic growth
# parameters: a named vector
parameters <- c(r = 1.5, K = 10)

# initial conditions: also a named vector
state <- c(x = 0.1)

## time sequence
time <- seq(from=0, to=10, by = 0.01)

logistic <- function(t, state, parameters){
  with(as.list(c(state, parameters)),{
    # rate of change
    dx <- r*x*(1-x/K)
    
    # return the rate of change
    return(list(dx))
  })  # end with(as.list ...
}

out <- ode(y = state, times = time, func = logistic, parms = parameters)

ggplot(data = as.data.frame(out), aes(time, x)) + geom_point()


# Predator-prey equations

# time sequence 
time <- seq(0, 50, by = 0.01)

# parameters: a named vector
parameters <- c(r = 2, k = 0.5, e = 0.1, d = 1)

# initial condition: a named vector
state <- c(V = 1, P = 3)

lotkaVolterra <- function(t, state, parameters){
  with(as.list(c(state, parameters)), {
    dV = r * V - k * V * P
    dP = e * k * V * P - d * P
    return(list(c(dV, dP)))
  })
}
# Integration with 'ode'
out <- ode(y = state, times = time, func = lotkaVolterra, parms = parameters)

# Ploting
out.df = as.data.frame(out) # required by ggplot: data object must be a data frame
library(reshape2)
out.m = melt(out.df, id.vars='time') # this makes plotting easier by puting all variables in a single column

ggplot(out.m, aes(time, value, color = variable)) + geom_point()

ggplot(data = out.df[1:567,], aes(x = P, V, color = time)) + geom_point()


# ODE models of gene expression
library(reshape2)
library(deSolve)
library(ggplot2)
time <- seq(from=1, to=3600, by=10)

parameters <- c(k1=0.1, d1=0.05, k2=0.1, d2=0.0025) 

state <- c(m=0, p=0)

geneExpression <- function(t, state, parameters){
  with(as.list(c(state, parameters)), {
    dm = k1 - d1 * m
    dp = k2 * m - d2 * p
    return(list(c(dm, dp)))
  })
}

out <- ode(y = state, times = time, func = geneExpression, parms = parameters)

# Ploting
out.df = as.data.frame(out) # required by ggplot: data object must be a data frame
out.m = melt(out.df, id.vars='time') # this makes plotting easier by putting all variables in a single column

ggplot(out.m, aes(time, value, color = variable)) + geom_point()
