NB. build

prepend=. 0 : 0
3 : 0''
if. IFJ6 do.
  script_z_ '~system/main/dll.ijs'
  script_z_ '~system/main/socket.ijs'
else.
  require 'socket'
end.
''
()
)

dat=. (('()';')') stringreplace prepend), readsource_jp_ '~R/rserve'
dat fwrite jpath '~R/rdsock.ijs'

f=. 3 : 0
fm=. jpath '~R/',y
to=. jpath '~addons/stats/r/',y
to fcopynew fm
)

empty f 'rserve.ijs'
empty f 'rdsock.ijs'
empty f 'test_rserve.ijs'
