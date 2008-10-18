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

NB.*rpath v Valid R path from jpath
NB. (R requires '\\' on windows but '/' works on all platforms)
rpath=: '\/' charsub jpath

NB. Utilities for converting to/from map & str formats
NB. from/to R tree structure

DELIM=: '$'
ATTRIB=: '`'

NB.delimit v Delimits list of boxed strings y with x
delimit=: ' '&$: : (4 : '(;@(#^:_1!.(<x))~  1 0$~0 >. _1 2 p.#) y')

NB.parsekey v Parses string of key name for getmapr
NB. returns list of boxed literals describing key
NB.  eg:  parsekey 'terms$`terms.labels'
parsekey=: [: <;._1 DELIM&,@:>

NB.*ndxmap v Indices in MAP of all keys with leading keys matching x
NB. eg: 'key' rndxmap MAP
ndxmap=: 4 : 0
  lookup=. parsekey x
  NB. keys=. ((#lookup) {. parsekey@])&.> getmap y
  keys=. lookup&((#@[ <. #@]) {. parsekey@])&.> rgetmap y
  I. keys e.&> <,:lookup
)

NB.*rgetmap v [monad] Returns keys for R map structure
NB. eg: KEYS=: rgetmap MAPR

NB.*rgetmap v [dyad] Returns value(s) from R map structure
NB. result: value(s) of key(s) matching x if exact match
NB.       map of trailing keys and values if x matches leading keys
NB. form: key rgetmap mapstruct
NB. key is: string of key names delimited by DELIM.
NB.       attribute names are designated by leading ATTRIB
NB. eg: VALUE=: 'qr$qr$`dimnames' rgetmap MAPR
rgetmap=: 3 : 0
  {."1 y
  :
  try.
    tmp=. x (ndxmap { ]) y
    if. *./ x&(>@[ =&# ]) &> {."1 tmp do.
      >,/{:"1 tmp
    else.
      keys=. DELIM&delimit@((#parsekey x) }. parsekey@])&.> rgetmap tmp
      keys,.{:"1 tmp
    end.
  catch. empty'' end.
)

NB. isattr v Is a key an attribute?
isattr=: ATTRIB = [: {. &> rgetmap^:ismap_jmap_

NB. for use with adverbs attr & vars
getattr=: I.@:isattr { ]
getvars=: I.@:-.@:isattr { ]

NB.*attr a Filters results of getmapr to only attributes
NB. eg: KEYS=: getmapr attr MAPRTREE
NB. eg: VALUE=: 'model' getmapr attr MAPRTREE
attr=: 1 : 'getattr_rbase_@:u'

NB.*vars a Filters results of getmapr to non-attributes
NB. eg: KEYS=: getmapr vars MAPRTREE
NB. eg: VALUE=: 'model' getmapr vars MAPRTREE
vars=: 1 : 'getvars_rbase_@:u'

NB. Exported to the z locale

Rmap_z_=: rgetmap_rbase_
Rattr_z_=: rgetmap_rbase_ attr_rbase_
Rvars_z_=: rgetmap_rbase_ vars_rbase_


