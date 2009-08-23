NB. postbuild
NB.
NB. copy to ~addons

require 'files'

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

f 'rbase.ijs'
f 'test_rbase.ijs'
