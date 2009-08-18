NB. built from project: ~R/rbase/rbase
NB. init
NB.
NB. rbase project intended for standard R utilities

script_z_ '~system/main/pack.ijs'
script_z_ '~system/main/strings.ijs'

coclass 'rbase'


coinsert 'rserve'

NB. util

NB. =========================================================
NB. R range
range=: <./ , >./

NB.*rpath v Valid R path from jpath
NB. (R requires '\\' on windows but '/' works on all platforms)
rpath=: '\/' charsub jpath


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


NB. =========================================================
NB. Utilities for displaying formated R map structures
NB. and returning data from R map structures based on class of structure

NB.*getclass v Determines class of R map structure y
NB. If class not explicitly given by key, 
NB.   try and determine what it is: matrix, call, list, integer, numeric, ...
getclass=: 3 : 0
 res=. '`class' getmap y
 if. 0 = >./ #&> boxopen res do.
   res=. empty''
   if. ismap y  do. NB. check if map structure
     if. #dat=. '`data' Rmap y do. NB. if `data attribute present
       NB. rank 2 - matrix ('qr$qr' Rmap MAPR)
       NB. > rank 2 - array
       res=. (;:'vector matrix array'){::~ 1 2 i. #$dat
     else.
       if. 1 = L. y do. 
         res=. 'numeric' NB. - numeric ('residuals' Rmap MAPR)
       else.
         res=. 'unknown' NB. 
       end.
     end.
   else.  NB. not a map structure
     if. 0 = L. y do. NB. not boxed
       if. 1 < #$y do. 
         res=. (;:'vector matrix array'){::~ 1 2 i. #$y
       else.
         res=. datatype y
       end.
     else. NB. is boxed
       res=. 'list'
       NB. check if boxed list with `NULL in 2nd one - call
       NB. check if boxed list containing literals - character (Rmap 'residuals' Rmap MAPR)
     end.
   end.
 end.
 res
)

NB.*Rshow v Returns "formatted" representation of R map structure y
NB.  the representation depends on the class of the map structure
NB. eg: a data.frame will show row & column labels
Rshow=: 3 : 0
  class=. getclass y
  select. class 
  case. 'data.frame' do.
    showDataFrame y
  case. 'floating';'integer';'boolean' do.
    y
  case. 'factor' do.
    showFactor y
  case. 'list' do.
    showList y
  case. 'matrix' do.
    showMatrix y
  case. do.
    (class,' class not handled') assert 0
  end.
)

ifa=: <@(>"1)@|:
afi=: |:@:(<"_1@>)

NB.*Rdata v Returns data representation of R map structure y
NB.  the representation depends on the class of the map structure
NB.  result: data[;labels]
Rdata=: 3 : 0
  class=. getclass y
  select. class 
  case. 'data.frame' do.
    dataDataFrame y
  case. 'floating';'integer';'boolean' do.
    y
  case. 'list' do.
    dataList y
  case. 'factor' do.
    dataFactor y
  case. do.
    (class,' class not handled') assert 0
  end.
)

NB.*showDataFrame v Displays representation of R dataframe.
showDataFrame=: 3 : 0
  'Not a data.frame' assert 'data.frame' -: getclass y
  df=. y
  rlabels=. '`row.names' getmap df
  clabels=. getnames top df
  data=. clabels <@Rshow@getmap"0 _ df
  clabels=. (a: #~ 0 < #rlabels), clabels
  clabels ,: (<,.>rlabels) , ,.&.> data
)

showMatrix=: 3 : 0
  'Not a matrix' assert 'matrix' -: getclass y
  mat=. y
  if. 0 < L. mat do.
    mat=. '`data' getmap mat
    if. 0< #labels=. '`dimnames' Rmap y do.
      'rlabels clabels'=. labels
      mat=. (' 'joinstring clabels) , (,.>rlabels) ,. ' ' ,. ": mat
      NB. mat=. (,.>rlabels) ,. ' ' ,. ": mat
    end.
  end.
  mat
)

NB.*dataDataFrame v Displays representation of R dataframe.
dataDataFrame=: 3 : 0
  'Not a data.frame' assert 'data.frame' -: getclass y
  df=. y
  rlabels=. '`row.names' getmap df
  clabels=. getnames top df
  data=. clabels Rdata@getmap"0 _ df
  data;< rlabels;<clabels
)

showFactor=: 3 : 0
  'Not a factor' assert 'factor' -: getclass y
  fac=. y
  >ifa (<:@('`data'&Rmap) { '`levels'&Rmap) fac
)

dataFactor=: 3 : 0
  'Not a factor' assert 'factor' -: getclass y
  fac=. y
  <:@('`data'&Rmap) fac
)

showList=: >^:(1 = L.)


NB. Exported to the z locale

Rmap_z_=: getmap_rbase_
Rattr_z_=: getattr_rbase_@getmap_rbase_
Rnames_z_=: getnames_rbase_@getmap_rbase_
Rclass_z_=: getclass_rbase_
Rshow_z_=: Rshow_rbase_
Rdata_z_=: Rdata_rbase_
