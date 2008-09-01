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
