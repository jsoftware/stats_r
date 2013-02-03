NB. save

prepend=. 0 : 0
3 : 0''
require 'task'
''
()
)

dat=. (('()';')') stringreplace prepend), readsource_jp_ '~R/dcmd'
dat fwrite jpath '~R/rdcmd.ijs'

to=. jpath '~addons/stats/r/rdcmd.ijs'
fm=. jpath '~R/rdcmd.ijs'
empty to fcopynew fm
