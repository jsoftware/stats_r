NB. demo
NB.
NB. This script demos the J/Rserve connection.
NB.
NB. Ensure that Rserve is already started and
NB. rserve.ijs is loaded

cocurrent 'base'

Rget 'pi'
Rget '1:4'
Rget 'matrix(1:6,2,3)'
$ Rget 'array(1:6,c(2,3,4,5))' NB. note preserves R shape order

Rcmd 'x=factor(c("one","two","three","four"))'
Rget 'x'

Rget 'c(1,Inf,-Inf,NaN,NA)' NB. R NA is converted to J NAN (__)

Rcmd 'x=1.23+1:8' NB. cmd = evaluate only
Rcmd 'dim(x)=c(2,4)'
Rget 'x'         NB. Rget = evaluate and return.

Rcmd 'x = c("a","b","c","d","e","f","g","h")'
Rcmd 'dim(x) = c(2,4)'
Rget 'x'          NB. note boxed result

Rcmd 'x = c("abc","b","c","d","e","fore","g","h")'
Rcmd 'dim(x) = c(2,4)'
Rget 'x'          NB. note boxed result

Rget 'c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)'

Rcmd 'foo <- function(x,y) {x + 2 * y}'
Rget 'typeof(foo)'
Rget 'foo(5,3)'
Rget 'foo'

'abc' Rset 'qwerty'
Rget 'abc'
'abc' Rset i.2 3
Rget 'abc'

'x' Rset 12 18 24 30 36 42 48
'y' Rset 5.27 5.68 6.25 7.21 8.02 8.71 8.42
Rcmd 'lxy=lsfit(x,y)'
Rget 'lxy$coefficients'
Rget 'lxy$residuals'
Rget 'lxy'
Rgettree 'lxy$coefficients'
Rgettree 'lxy$residuals'
Rgettree 'lxy'

Rcmd 'data(OrchardSprays)'
Rgetexp 'OrchardSprays'
Rget 'OrchardSprays'
Rgettree 'OrchardSprays'

Rclose''
