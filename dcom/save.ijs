NB. save

prepend=. 0 : 0
3 : 0''
if. IFJ6 do.
  script_z_ '~system/main/strings.ijs'
end.
''
()
)

dat=. (('()';')') stringreplace prepend), readsource_jp_ '~R/dcom'
dat fwrite jpath '~R/rdcom.ijs'

to=. jpath '~addons/stats/r/rdcom.ijs'
fm=. jpath '~R/dcom/rdcom.ijs'
empty to fcopynew fm
