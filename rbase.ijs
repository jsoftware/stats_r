NB. built from project: ~R/rbase/rbase
NB. init
NB.
NB. rbase project intended for standard R utilities

script_z_ '~system/main/map.ijs'
script_z_ '~system/main/pack.ijs'

coclass 'rbase'


coinsert 'rserve'

NB. util

NB. =========================================================
NB. R range
range=: <./ , >./
