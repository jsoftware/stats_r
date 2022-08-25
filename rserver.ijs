coclass 'rserver'
DEBUG=: 0
DELIM=: '$'
EMPTY=: i.0 0
NULL=: 'NULL'
atoi=: 256 #. a. i. |.
av=: ({&a.)`] @. (2 = 3!:0)
binrep=: 3 : '_8[\ a.i. 3!:1 y'
info=: sminfo @ ('rserver'&;)
isboxed=: 0 < L.
ischar=: 2 = 3!:0
isinteger=: (-: <.) ::0:
ismatrix=: 2 = #@$
isopen=: 0 = L.
isnan=: 128!:5
isscalar=: 0 = #@$
readchar=: memr @ (0 _1 ,~ 0 pick ])
round=: [ * [: <. 0.5 + %~
roundint=: <. @ +&0.5
roundup=: [ * [: >. %~
symsort=: ,~ '10' {~ '`'={.
toscalar=: {.^:((,1) -: $)
alen=: 3 : 0
't c r s'=. memr y,8 4 4
select. t
case. 1;2 do. 40 + 8 * r + <.c % 8 return.
case. 4;8 do. 32 + 8 * r + c return.
case. 16 do. 32 + 8 * r + 2 * c return.
case. 32 do.
  n=. memr y,(8*r+c+3),1 4
  if. n=0 do. 40 else. n + alen(y+n) end.
end.
)
errormsg=: 3 : 0
if. y e. ERRNUM do.
  'Error code: ',(":y),' ',(ERRNUM i. y) pick ERRMSG
else.
  'Status code: ',":y
end.
)
fixscalar=: 3 : 0
if. isnan y do. y return. end.
if. (1=#y) *: 2 > #$y do. y return. end.
r=. > {. y
if. -. r -: y do. fixscalar r end.
)
fixxp=: 3 : 0
select. {. y
case. XP_VEC do.
  1 + i.-1{y
case. do.
  y
end.
)
isattval=: 3 : 0
if. 0 = L. y do. 0 return. end.
if. -. 1 1 2 -: $y do. 0 return. end.
'`' = {. (0 0 0;1) {:: y
)
rflip=: 3 : 0
if. 2 > #$y do. y return. end.
_2 |: (|.$y) ($,) y
)
prefixnames=: 4 : 0
if. (isopen y) >: ismatrix y do.
  ,:x;<y return.
end.
if. 0=#x do. y return. end.
nms=. {."1 y
if. 0 e. ischar &> nms do.
  ,:x;<y return.
end.
nms=. (<x) ,each DELIM ,each nms
nms,.{:"1 y
)
sexp2list=: 3 : 0
if. isopen y do.
  toscalar y
elseif. isattval y do.
  sexp2list each ,y
elseif. do.
  sexp2list each y
end.
)
throw=: 3 : 0
msg=. y
if. ischar msg do. msg=. 1;msg end.
thrown=: msg
if. DEBUG do.
  info 1 pick msg
else.
  smoutput 1 pick msg
end.
throw.
)
XP_VEC=: _2147483648
j=. <;._2 (0 : 0)
01 ENOCONN could not connect to R
10 ENAME name not supported for set
11 EVALUE value not supported for set
12 ETYPE type not supported for get
21 EEVAL eval error
22 EINCMP parse incomplete
23 EPARSE parse error
)

ERRNUM=: 0 ". &> 2 {. each j
j=. 3 }. each j
x=. j i.&> ' '
". (x {.&> j) ,"1 '=:' ,"1 ":,.ERRNUM
ERRMSG=: (x+1) }. each j
errorcode=: 3 : 0
ndx=. ERRNUM i. y
if. ndx<#ERRMSG do.
 ndx pick ERRMSG
else.
 'unknown error number: ',":y
end.
)
ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
lib=. '"',(jpath '~addons/stats/r/lib/librserver.',ext),'"'
rclose1=: (lib,' rclose > i i') & cd
rcmd1=: (lib,' rcmd > x *c') cd <
rget1=: (lib,' rget x *c *') & cd
ropen1=: (lib,' ropen > i i') & cd
rset1=: (lib,' rset > x *c *') & cd
rclose=: 3 : 0
r=. rclose1 0
if. r=0 do. return. end.
throw errorcode r
)
rcmd=: 3 : 0
r=. rcmd1 y
if. r=0 do. EMPTY return. end.
throw errorcode r
)
rgetx=: 3 : 0
'r c p'=. rget1 (,y);,2
if. p do.
  res=. 3!:2 memr p,0,alen p
else.
  res=. 0
end.
if. r=0 do. res return. end.
if. res=0 do. res=. errorcode r end.
throw res
)
rget=: 3 : 0
sexp2map rgetx y
:
x Rmap rget y
)
rgetexp=: sexp2list @ rgetx
ropen=: 3 : 0
r=. ropen1 {.y,0
if. r=0 do. return. end.
throw errorcode r
)
rset=: 4 : 0
if. isopen x do.
  x=. deb x
  if. -. ' ' e. x do.
    x rset1a y return.
  end.
  x=. <;._1 ' ',x
end.
if. -. (1=L.y) *. (1 >: #$y) *. (#x)=#y do.
  throw 'Names and values do not match for rset'
end.

x rset1a each y

)
rset1a=: 4 : 0
if. 8 < 3!:0 y do.
  throw errorcode ETYPE return.
end.
s=. $y
if. 1 < #s do.
  y=. (|. 1 A. s) $ ,|:"2 y
end.
r=. rset1 (,x);3!:1 y
if. r=0 do. EMPTY return. end.
throw errorcode r
)
sData=: <'`data'
sDim=: <'`dim'
sNames=: <'`names'
sRownames=: <'`row.names'
sexp2map=: 3 : 0
IfAtt=: 0
dat=. att2map y
if. -.IfAtt do. return. end.
ndx=. 1 i.~ 0 = # &> {."1 dat
dat /: symsort each {."1 dat
)
att2map=: 3 : 0
if. isopen y do. toscalar y return. end.
if. -. isattval y do. att2map each y return. end.
'att dat'=. att2map each ,y
if. -. ismatrix att do.
  if. 2 | #att do.
    throw 'Invalid attribute list - not in value;attribute pairs'
  end.
  att=. _2 |.\ att
end.
ndx=. ({."1 att) i. sDim
if. ndx<#att do.
  dim=. 1 pick ndx{att
  att=. (<<<ndx){att
  dat=. _2 |: (|. dim) $ dat
  if. 0=#att do. dat return. end.
end.
IfAtt=: 1
ndx=. ({."1 att) i. sNames
if. ndx = #att do.
  res=. ,:'`data';<dat
else.
  nms=. boxxopen 1 pick ndx { att
  att=. (<<<ndx) { att
  if. 1 = #nms do.
    dat=. boxxopen dat
  else.
    if. (#nms) ~: #dat do.
      throw 'Names do not match data' return.
    end.
    if. 0 = L. dat do.
      dat=. <"_1 dat
    end.
  end.
  res=. i.0 2
  res=. res,;nms prefixnames each dat
end.
ndx=. ({."1 att) i. sRownames
if. ndx < #att do.
  ind=. <ndx;1
  att=. (<fixxp >ind{att) ind}att
end.
att=. flatt att
res,att
)
flatt=: 3 : 0
msk=. 2 = #@$ &> {:"1 y
if. -. 1 e. msk do. y return. end.
((-.msk) # y),;flatt1"1 msk # y

)
flatt1=: 3 : 0
'nam mat'=. y
<nam prefixnames mat
)
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
rmap=: Rmap f.
NB. zfns

cocurrent 'z'

Rclose=: rclose_rserver_
Ropen=: ropen_rserver_
Rcmd=: rcmd_rserver_
Rget=: rget_rserver_
Rgetexp=: rgetexp_rserver_
Rset=: rset_rserver_
Rmap=: rmap_rserver_

cocurrent 'base'
