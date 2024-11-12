# ODE models of gene expression
library(reshape2)
library(deSolve)
library(ggplot2)
library(plotly)
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

p <- ggplot(out.m, aes(time, value, color = variable)) + geom_point()
interactive_plot <- ggplotly(p)
interactive_plot
