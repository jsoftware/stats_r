NB. save

prepend=. 0 : 0
3 : 0''
''
()
)

dat=. (('()';')') stringreplace prepend), readsource_jp_ '~R/dcom'
dat fwrite jpath '~R/rdcom.ijs'

to=. jpath '~addons/stats/r/rdcom.ijs'
fm=. jpath '~R/dcom/rdcom.ijs'
empty to fcopynew fm
