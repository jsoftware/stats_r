
cocurrent 'base'
coreset ''
sdcleanup_jsocket_''
dbstops''
dbg 1

AA=: Rget 'lm(Infant.Mortality ~ Catholic,data=swiss)'
smoutput AA #~ (<'effects') = 7 {.each {."1 AA

NB. f=: 3 : 0
NB. smoutput '   ', y
NB. smoutput A=: Rgetexp y
NB. smoutput ''
NB. smoutput B=: Rget y
NB. )
NB.
NB. Rcmd 'x=factor(c("one","two","three","four"))'
NB. f 'x'
NB.
NB. f 'c(1,Inf,-Inf,NaN,NA)' NB. R NA is converted to J NAN (__)
NB.
NB. Rcmd 'x=1.23+1:8' NB. cmd = evaluate only
NB. Rcmd 'dim(x)=c(2,4)'
NB. f 'x'         NB. f = evaluate and return.
NB.
NB. Rcmd 'x = c("a","b","c","d","e","f","g","h")'
NB. Rcmd 'dim(x) = c(2,4)'
NB. f 'x'          NB. note boxed result
NB.
NB. Rcmd 'x = c("abc","b","c","d","e","fore","g","h")'
NB. Rcmd 'dim(x) = c(2,4)'
NB. f 'x'          NB. note boxed result
NB.
NB. f 'c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)'
NB.
NB. Rcmd 'foo <- function(x,y) {x + 2 * y}'
NB. f 'typeof(foo)'
NB. f 'foo(5,3)'
NB. f 'foo'
NB.
NB. 'abc' Rset 'qwerty'
NB. f 'abc'
NB. 'abc' Rset i.2 3
NB. f 'abc'
NB.
NB. 'x' Rset 12 18 24 30 36 42 48
NB. 'y' Rset 5.27 5.68 6.25 7.21 8.02 8.71 8.42
NB. Rcmd 'lxy=lsfit(x,y)'
NB. f 'lxy$coefficients'
NB. f 'lxy$residuals'
NB. f 'lxy'
NB.
NB. Rcmd 'data(OrchardSprays)'
NB. Rgetexp 'OrchardSprays'
NB. f 'OrchardSprays'
NB.
NB. Rclose''
