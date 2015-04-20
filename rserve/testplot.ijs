NB. test plot to pdf

cocurrent 'base'
coreset ''
sdcleanup_jsocket_''

NB. a=: '' conew 'rserve'
NB. Rcmd 'pdf(file="e:/t1.pdf")'
Rcmd 'pdf(file="',(rpath '~temp/'),'t1.pdf")'
Rcmd 'plot(c(2,3,5,7,11))'
Rcmd 'dev.off()'
