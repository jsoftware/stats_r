NB. build

writesourcex_jp_ '~R/rserve';'~R/rdsock.ijs'

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

empty f 'rserve.ijs'
empty f 'rdsock.ijs'
empty f 'test_rserve.ijs'
