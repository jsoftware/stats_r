
cocurrent 'base'
coreset ''
sdcleanup_jsocket_''
dbstops''
dbg 1

f=: 3 : 0
smoutput '   ', y
smoutput A=: Rgetexp y
smoutput ''
smoutput B=: Rget y
smoutput ''
smoutput C=: Rgettree y
)

Rcmd 'x=factor(c("one","two","three","four"))'
f 'x'

f 'c(1,Inf,-Inf,NaN,NA)' NB. R NA is converted to J NAN (__)

Rcmd 'x=1.23+1:8' NB. cmd = evaluate only
Rcmd 'dim(x)=c(2,4)'
f 'x'         NB. f = evaluate and return.

Rcmd 'x = c("a","b","c","d","e","f","g","h")'
Rcmd 'dim(x) = c(2,4)'
f 'x'          NB. note boxed result

Rcmd 'x = c("abc","b","c","d","e","fore","g","h")'
Rcmd 'dim(x) = c(2,4)'
f 'x'          NB. note boxed result

f 'c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)'

Rcmd 'foo <- function(x,y) {x + 2 * y}'
f 'typeof(foo)'
f 'foo(5,3)'
f 'foo'

'abc' Rset 'qwerty'
f 'abc'
'abc' Rset i.2 3
f 'abc'

'x' Rset 12 18 24 30 36 42 48
'y' Rset 5.27 5.68 6.25 7.21 8.02 8.71 8.42
Rcmd 'lxy=lsfit(x,y)'
f 'lxy$coefficients'
f 'lxy$residuals'
f 'lxy'
Rgettree 'lxy$coefficients'
Rgettree 'lxy$residuals'
Rgettree 'lxy'

Rcmd 'data(OrchardSprays)'
Rgetexp 'OrchardSprays'
f 'OrchardSprays'
Rgettree 'OrchardSprays'

Rclose''
