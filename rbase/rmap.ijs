NB. utilities for working with R structures

DELIM=: '$'

STRTYP=. 2 65536 131072
istble=. ((2: = {:) *. 2: = #)@$
isstr=. ([: *./ STRTYP e.~ [: 3!:0@> ])
iskeys=. (isstr *. 1: = L.)@:({."1)

NB. ismap v Is a noun a valid map?
ismap=: (iskeys *. istble) f.

NB. isattr v Is a key an attribute?
isattr=: '`' = [: {. &> {."1^:ismap

NB.*rgetmap v [monad] Returns keys for R tree structure
NB. eg: KEYS=: rgetmap MAPRTREE
NB. returns only top level keys of the tree

NB.*rgetmap v [dyad] Returns value from R tree structure
NB. form: key getmapr treestruct
NB. key is: string consisting of variable names and
NB.         attribute names delimited by DELIM.
NB.         Attribute names are signified by a
NB.        leading backtick (`)
NB. eg: VALUE=: 'qr$qr$`dimnames' getmapr MAPRTREE
rgetmap=: 3 : 0
  getmap y
  :
  for_i. parsekey boxopen x do.
    y=. i getmap y
  end.
)

NB.parsekey v Parses string of key name for getmapr
NB. returns list of boxed literals describing key
NB.  eg:  parsekey 'terms$`terms.labels'
parsekey=: [: <;._1 DELIM&,@:>

NB. for use as verbs
getAttr=: I.@:isattr { rgetmap
getVars=: I.@:-.@:isattr { rgetmap

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

NB.*rgetmapx v Keys of all leaves in R tree structure
NB. KEYS=: rgetmapx MAP
rgetmapx=: 3 : 0
  r=. ''
  if. ismap y do.
    for_i. rgetmap y do.
      r=. r, i [`( (, DELIM&,)&.> )@.(*@#@]) rgetmapx i rgetmap y
    end. end.
)

NB.*rmap v Converts R tree format to map format.
NB. rmap=: ([ ,. (rgetmap&.> <))~ rgetmapx
NB.! removes '`'s that are part of a name
rmap=: (([: -.&'`'&.> [) ,. (rgetmap&.> <))~ rgetmapx

Rgetmap_z_=: rgetmap_rbase_
Rgetattr_z_=: getAttr_rbase_
Rgetvars_z_=: getVars_rbase_
Rmap_z_=: rmap_rbase_
