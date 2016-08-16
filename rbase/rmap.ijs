NB. =========================================================
NB. Utilities for working with R map structures

DELIM=: '$'
ATTRIB=: '`'

STRTYP=. 2 65536 131072 262144
istble=. ((2: = {:) *. 2: = #)@$
isstr=. (STRTYP e.~3!:0&>) *./@, 2>#@$&>
iskeys=. (isstr *. 1: = L.)@:({."1)

NB.*ismap v Is y an R map structure
NB. eg: BOOL=: ismap MAPR
ismap=: (iskeys *. istble) f.

NB. parsekey v Parses string of key name for Rmap
NB. returns list of boxed literals describing key
NB.  eg:  parsekey 'terms$`terms.labels'
parsekey=: [: <;._1 DELIM&,@:>

NB.*ndxmap v Indices in MAPR of all keys with leading keys matching x
NB. eg: 'key' ndxmap MAPR
ndxmap=: 4 : 0
  lookup=. parsekey x
  keys=. lookup&((#@[ <. #@]) {. parsekey@])&.> Rmap y
  I. keys e.&> <,:lookup
)

NB.*Rmap v [monad] Returns keys from R map structure
NB. eg: KEYS=: Rmap MAPR
NB. Rmap v [dyad] Returns value(s) from R map structure
NB. result: value(s) of key(s) matching x if exact match,
NB.       or map of trailing keys and values if x matches leading keys
NB. form: key(s) Rmap mapstruct
NB. key is: string of key name delimited by DELIM.
NB.       attribute names are designated by leading ATTRIB
NB. eg: VALUE=: 'qr$qr$`dimnames' Rmap MAPR
NB. eg: VALUE=: 'qr$qr$`dimnames' Rmap MAPR
Rmap=: 3 : 0
  {."1^:ismap y
  :
  try.
    x=. boxopen x
    tmp=. x (ndxmap { ]) y
    if. *./ x&(>@[ =&# ]) &> {."1 tmp do.
      >,/{:"1 tmp
    else.
      keys=. DELIM&joinstring@((#parsekey x) }. parsekey@])&.> Rmap tmp
      keys,.{:"1 tmp
    end.
  catch. empty'' end.
)

NB. isattr v Is a key an attribute?
isattr=: ATTRIB = [: {. &> Rkeys^:ismap

NB.*getattrkeys v Filters y for attributes
NB. eg: getattrkeys Rmap MAPR
NB. eg: getattrkeys 'model' Rmap MAPR
getattrkeys=: #~ isattr

NB.*getnamekeys v Filters y for names
NB. eg: getnamekeys Rmap MAPR
NB. eg: getnamekeys 'model' Rmap MAPR
getnamekeys=: #~ -.@isattr

NB.*getnamekeys v Filters y for top level keys
gettoplevel=: [: ~. DELIM&taketo&.>

NB.*byname a Filter result of u by R name
byname=: 1 : 'getnamekeys_rbase_@:u'

NB.*byattr a Filter result of u by R attribute
byattr=: 1 : 'getattrkeys_rbase_@:u'

NB.*bytoplevel a Filter result of u by top-level keys
bytoplevel=: 1 : 'gettoplevel_rbase_@:u'

NB.*Rkeys v [monad] retrieves R keys from map structure y
NB.  same as monadic Rmap
Rkeys=: 3 : 'Rmap y'

NB.*Rnamekeys v [monad] retrieves R name keys from map structure y
Rnamekeys=: 3 : 'Rmap byname y'

NB.*Rattrkeys v [monad] retrieves R attribute keys from map structure y
Rattrkeys=: 3 : 'Rmap byattr y'

NB.*Rnames v [monad] retrieves top-level R name keys from map structure y
Rnames=: 3 : 'Rnamekeys bytoplevel y'

NB.*Rattr v [monad] retrieves top-level R attribute keys from map structure y
Rattr=:  3 : 'Rattrkeys bytoplevel y'
