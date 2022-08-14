NB. util

DEBUG=: 0
DELIM=: '$'
EMPTY=: i.0 0
NULL=: 'NULL'

NB. =========================================================
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

NB. =========================================================
NB. alen v length of A representation from R
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

NB. =========================================================
errormsg=: 3 : 0
if. y e. ERRNUM do.
  'Error code: ',(":y),' ',(ERRNUM i. y) pick ERRMSG
else.
  'Status code: ',":y
end.
)

NB. =========================================================
NB. fixscalar
NB. convert to scalar and open if possible
NB. explicit form avoids problems with NAN in result
NB. fixscalar=: >@{.^:((1 = #) *. 2 > #@$)^:_
fixscalar=: 3 : 0
if. isnan y do. y return. end.
if. (1=#y) *: 2 > #$y do. y return. end.
r=. > {. y
if. -. r -: y do. fixscalar r end.
)

NB. =========================================================
fixxp=: 3 : 0
select. {. y
case. XP_VEC do.
  1 + i.-1{y
case. do.
  y
end.
)

NB. =========================================================
isattval=: 3 : 0
if. 0 = L. y do. 0 return. end.
if. -. 1 1 2 -: $y do. 0 return. end.
'`' = {. (0 0 0;1) {:: y
)

NB. =========================================================
rflip=: 3 : 0
if. 2 > #$y do. y return. end.
_2 |: (|.$y) ($,) y
)

NB. =========================================================
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

NB. =========================================================
NB. sexp2list
sexp2list=: 3 : 0
if. isopen y do.
  toscalar y
elseif. isattval y do.
  sexp2list each ,y
elseif. do.
  sexp2list each y
end.
)

NB. =========================================================
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
