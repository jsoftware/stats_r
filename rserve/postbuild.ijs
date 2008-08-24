NB. postbuild
NB.
NB. copy to main addon directory and to ~addons

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~.R',y
to fcopynew fm
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

f 'rdsock.ijs'
f 'rserve.ijs'
f 'test_rserve.ijs'