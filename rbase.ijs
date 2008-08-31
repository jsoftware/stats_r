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


NB. Utilities for converting to/from map & str formats 
NB. from/to R tree structure

NB. smplnames v removes leading attribute designator from attribute names
NB.! will also remove '`'s that are part of a name!
smplnames=: ([: -.&ATTRIB&.> {."1) ,. {:"1  

NB.*rtomap0 v Converts R tree format to map format
NB. retains attribute designator
rtomap0=: ([ ,. (rgetmap&.> <))~ rgetmapx  NB.

NB.*rtomap v Converts R tree format to map format
NB. rtomap=: ([ ,. (rgetmap&.> <))~ rgetmapx
NB.! removes '`'s that are part of a name too!
rtomap=: smplnames @: rtomap0

NB.*rtotree v convert flat map to nested tree
NB. MAPX=: rtotree MAP
NB. calls flatmapx_jmap_ with rbase defn for DELIM
rtotree=: 3 : 0
  archive=. DELIM_jmap_
  DELIM_jmap_=: DELIM_rbase_
  r=. flatmapx_jmap_ y
  DELIM_jmap_=: archive
  r
)

linear=: 3 : 0
  if. (# *. L.) y do. y=.<y end.
  5!:5<'y'
)

NB. calls box2str_jmap_ with rbase defn for linear
box2str=: 3 : 0
  archive=. linear_jmap_ f.
  linear_jmap_=: linear_rbase_ f.
  r=. box2str_jmap_ y
  linear_jmap_=: archive f.
  r
)

NB.*rtree2str v convert tree to multiline string
NB. STR=: rtree2str MAPX
rtree2str=: box2str @: rtomap0

NB.*rstr2tree v convert multiline string to tree
rstr2tree=: rtotree @: str2box_jmap_


NB. Exported to the z locale

Rmap_z_=: rgetmap_rbase_
Rattr_z_=: getAttr_rbase_
Rvars_z_=: getVars_rbase_
Rtomap_z_=: rtomap_rbase_

