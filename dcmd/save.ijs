NB. save

prepend=. 0 : 0
3 : 0''
if. IFJ6 do.
  script_z_ '~system/main/files.ijs'
  script_z_ '~system/main/strings.ijs'
  script_z_ '~system/packages/misc/task.ijs'
else.
  require 'task'
end.
''
()
)

dat=. (('()';')') stringreplace prepend), readsource_jp_ '~R/dcmd'
dat fwrite jpath '~R/rdcmd.ijs'

to=. jpath '~addons/stats/r/rdcmd.ijs'
fm=. jpath '~R/rdcmd.ijs'
empty to fcopynew fm
