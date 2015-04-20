NB. testjm

f=: 3 : 0
smoutput '   ', y
smoutput A=: Rgetexp y
smoutput ''
smoutput B=: Rget y
)

Rcmd 'x <- seq(1,20,0.5)'
Rcmd 'w<- 1 + x/2'
Rcmd 'y<- x + w*rnorm(x)'
Rcmd 'dum <- data.frame(x,y,w)'
f 'dum'
Rcmd 'rm(x,y,w)'
Rcmd 'fm = lm(y ~ x, data=dum)'
f 'summary (fm)'
f 'fm'
f 'attributes(fm)'
