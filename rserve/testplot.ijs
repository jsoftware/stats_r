NB. test plot to pdf

cocurrent 'base'
coreset ''
sdcleanup_jsocket_''
dbstops''
dbg 1

a=: '' conew 'rserve'
Rcmd 'pdf(file="e:/t1.pdf")'
Rcmd 'plot(c(2,3,5,7,11))'
Rcmd 'dev.off()'

