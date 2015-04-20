NB. wiki
NB.
NB. Generates wiki examples
NB.
NB. Ensure that Rserve is already started and
NB. stats/r/rserve is loaded

cocurrent 'base'

load 'stats/r/rserve'
Rreset''

NB. =========================================================
Rget 'pi'
Rget '1:4'

NB. =========================================================
NB. array shape
Rget 'matrix(1:6,2,3)'
$ Rget 'array(1:6,c(2,3,4,5))' NB. note preserves R shape order
(rflip_rserve_ 1+i.2 3 4) -: Rget 'array(1:24,c(2,3,4))'

NB. =========================================================
NB. attribute lists
Rcmd 'x=factor(c("one","two","three","four"))'
Rget 'x'
Rgetexp 'x'

NB. =========================================================
NB. Booleans
Rget 'c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)'

NB. =========================================================
NB. command results
Rcmd 'x=array(1:8,c(2,4))' NB. cmd = evaluate only
Rget 'x*10' NB. Rget = evaluate and return.

NB. =========================================================
NB. function definition
Rcmd 'foo <- function(x,y) {x + 2 * y}'
Rget 'typeof(foo)'
Rget 'foo(5,3)'
Rget 'foo'

NB. =========================================================
NB. NA value
Rget 'c(1,Inf,-Inf,NaN,NA)' NB. R NA is converted to J NAN (__)

NB. =========================================================
NB. scalars
Rcmd 'x = c("a","b","c","d","e","f","g","h")'
Rcmd 'dim(x) = c(2,4)'
Rget 'x'          NB. note boxed result

Rcmd 'x = c("abc","b","c","d","e","fore","g","h")'
Rcmd 'dim(x) = c(2,4)'
Rget 'x'          NB. note boxed result

NB. =========================================================
NB. Rset
'abc' Rset 'qwerty'
Rget 'abc'
'abc' Rset i.2 3
Rget 'abc'

'x' Rset 12 18 24 30 36 42 48
'y' Rset 5.27 5.68 6.25 7.21 8.02 8.71 8.42
Rcmd 'lxy=lsfit(x,y)'
Rget 'lxy$coefficients'
Rget 'lxy$residuals'
