NB. build

writesource_jp_ '~R/rbase';'~R/rbase.ijs'

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

empty f 'rbase.ijs'
empty f 'test_rbase.ijs'
