NB. postbuild
NB.
NB. copy to ~addons

require 'files'

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

f 'rserve.ijs'
f 'rdsock.ijs'
f 'test_rserve.ijs'