NB. test0

dbg 1
dbstops''

wdpclose 'jdcom'
coreset''
'' conew 'prdcom'

Rcmdr 'rnorm(1)'

Rcmd 'x <- c(1,2,3,4)'
Rcmd 'y <- c(2,3,5,7)'
Rcmd 'z <- lm(y~x)'

Rcmdx 'z'

NB. using sink to get value
'' fwrite 'c:/r.txt'
Rcmd 'sink(file="c:/r.txt",append=TRUE,type="output")'
Rcmd 'print(z)'
Rcmd 'sink(file=NULL)'
fread 'c:/r.txt'

Rcmdr 'getwd()'
Rcmd 'setwd ("c:/program files/r/r-2.3.1")'
Rcmdr 'getwd()'

Rcmd 'g <- function(x,y) {x + 2 * y}'
Rcmdr 'typeof(g)'
Rcmdr 'g(5,3)'

NB. box command to avoid cut on LF:
Rcmd <'g <- function(x,y) {',LF,'a <- x',LF,'a + 2 * y}'
Rcmdr 'g(10,20)'
