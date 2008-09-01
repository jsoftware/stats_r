NB. utilities for working with R tree structure

DELIM=: '$'
ATTRIB=: '`'

NB. isattr v Is a key an attribute?
isattr=: ATTRIB = [: {. &> {."1^:ismap_jmap_

NB.*rgetmap v [monad] Returns keys for R tree structure
NB. eg: KEYS=: rgetmap MAPRTREE
NB. returns only top level keys of the tree

NB.*rget v [dyad] Returns value from R tree structure
NB. form: key getmapr treestruct
NB. key is: string consisting of variable names and
NB.         key names delimited by DELIM.
NB.         attribute names are designated by leading ATTRIB
NB. eg: VALUE=: 'qr$qr$`dimnames' getmapr MAPRTREE
rgetmap=: 3 : 0
  getmap_jmap_ y
  :
  for_i. parsekey boxopen x do.
    y=. i getmap_jmap_ y
  end.
)

NB.*rgetmapx v Keys of all leaves in R tree structure
NB. KEYS=: rgetmapx MAP
rgetmapx=: 3 : 0
  r=. ''
  if. ismap_jmap_ y do.
    for_i. rgetmap y do.
      r=. r, i [`( (, DELIM&,)&.> )@.(*@#@]) rgetmapx i rgetmap y
    end. end.
)

NB.*rsetmapx a [dyad] add/change value for key in tree
NB. MAPX=: VALUE 'k1$`k2$k3' rsetmapx MAPX

NB.*rsetmapx a [monad] remove an entry from tree
NB. MAPX=: 'k1$`k2$k3' rsetmapx MAPX
rsetmapx=: 1 : 0
  (empty'') u rsetmapx_rbase_ y
  :
  archive=. DELIM_jmap_
  DELIM_jmap_=: DELIM_rbase_
  r=. x u setmapx_jmap_ y
  DELIM_jmap_=: archive
  r
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
