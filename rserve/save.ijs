NB. save

require 'files'

f=: 3 : 0
'fm to'=. y
fm=. jpath '~R/',fm,'.ijs'
to=. jpath '~Addons/stats/r/',to,'.ijs'
to fcopynew fm
)

f 'dcmd/rdcmd';'rdcmd'
f 'dcom/rdcom';'rdcom'
f 'rbase/rbase';'rbase'
f 'rserve/rserve';'rserve'
f 'rserve/test_rserve';'test_rserve'