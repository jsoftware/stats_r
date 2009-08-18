NB. Utilities for working with R map structures

DELIM=: '$'
ATTRIB=: '`'

STRTYP=. 2 65536 131072
istble=. ((2: = {:) *. 2: = #)@$
isstr=. (STRTYP e.~3!:0&>) *./@, 2>#@$&>
iskeys=. (isstr *. 1: = L.)@:({."1)

NB.*ismap v Is y an R map structure
NB. eg: BOOL=: ismap MAPR
ismap=: (iskeys *. istble) f.

NB.parsekey v Parses string of key name for getmap
NB. returns list of boxed literals describing key
NB.  eg:  parsekey 'terms$`terms.labels'
parsekey=: [: <;._1 DELIM&,@:>

NB.*ndxmap v Indices in MAPR of all keys with leading keys matching x
NB. eg: 'key' ndxmap MAPR
ndxmap=: 4 : 0
  lookup=. parsekey x
  keys=. lookup&((#@[ <. #@]) {. parsekey@])&.> getmap y
  I. keys e.&> <,:lookup
)

NB.*getmap v [monad] Returns keys for R map structure
NB. eg: KEYS=: getmap MAPR

NB.*getmap v [dyad] Returns value(s) from R map structure
NB. result: value(s) of key(s) matching x if exact match
NB.       map of trailing keys and values if x matches leading keys
NB. form: key getmap mapstruct
NB. key is: string of key names delimited by DELIM.
NB.       attribute names are designated by leading ATTRIB
NB. eg: VALUE=: 'qr$qr$`dimnames' getmap MAPR
getmap=: 3 : 0
  {."1 y
  :
  try.
    tmp=. x (ndxmap { ]) y
    if. *./ x&(>@[ =&# ]) &> {."1 tmp do.
      >,/{:"1 tmp
    else.
      keys=. DELIM&joinstring@((#parsekey x) }. parsekey@])&.> getmap tmp
      keys,.{:"1 tmp
    end.
  catch. empty'' end.
)

NB. isattr v Is a key an attribute?
isattr=: ATTRIB = [: {. &> getmap^:ismap_jmap_

NB.*getattr v Filters y for attributes
NB. eg: getattr getmap MAPR
NB. eg: getattr 'model' getmap MAPR
getattr=: #~ isattr

NB.*getnames v Filters y for names
NB. eg: getnames getmap MAPR
NB. eg: getnames 'model' getmap MAPR
getnames=: #~ -.@isattr

NB.top a Returns unique top level labels from R map structure
NB. eg getnames_rbase top_rbase_ iris
top=: 1 : '([: ~. DELIM_rbase_&taketo&.>@u)@(getmap_rbase_^:ismap_rbase_) y'
