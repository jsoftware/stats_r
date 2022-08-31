NB. util

ALPH0=: {.a.
DELIM=: '$'
EMPTY=: i.0 0
NULL=: 'NULL'

NB. =========================================================
ax=: a.&i.
atoi=: 256 #. a. i. |.
av=: ({&a.)`] @. (2 = 3!:0)
info=: sminfo @ ('rserve'&;)
isboxed=: 0 < L.
ischar=: 2 = 3!:0
isinteger=: (-: <.) ::0:
ismatrix=: 2 = #@$
isopen=: 0 = L.
isnan=: 128!:5
isscalar=: 0 = #@$
rflip=: _2 |: |.@$ $ ,
round=: [ * [: <. 0.5 + %~
roundint=: <. @ +&0.5
roundup=: [ * [: >. %~
symsort=: ,~ '10' {~ '`'={.
toscalar=: {.^:((,1) -: $)

NB. =========================================================
NB. required debug verbs
debugq=: 13!:17
debugss=: 13!:3
debugstack=: 13!:13

NB. =========================================================
errormsg=: 3 : 0
if. y e. ERRNUM do.
  'Error code: ',(":y),' ',(ERRNUM i. y) pick ERRMSG
else.
  if. y-:127 do.
    try.
      rdget 'geterrmessage()'
    catcht.
      'Status code: ',":y
    end.
  else.
    'Status code: ',":y
  end.
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
NB. returns hdrlen, overall len from data
rhdrlen=: 3 : 0
if. 64 < 128 | ax {. y do.
  8,8 + atoi }. 8 {. y
else.
  4,4 + atoi }. 4 {. y
end.
)

NB. =========================================================
NB. use for both DT and XT
rtyplen=: 4 : 0
typ=. x
len=. y
if. len < 2^24 do.
  (av typ),3 {. 2 ic len
else.
  av (typ + XT_LARGE),|.(7#256)#:len
end.
)

NB. =========================================================
NB. convert tags to `tags
tag2sym=: 3 : 0
ndx=. >:+:i.<.-:#y
('`' ,each ndx { y) ndx} y
)

NB. =========================================================
throw=: 3 : 0
msg=. y
if. ischar msg do. msg=. 1;msg end.
thrown=: msg
info 1 pick msg
throw.
)

NB. =========================================================
NB. wrap socket command
wrapcmd=: 4 : 0
cmd=. 2 ic x
cnt=. #y
len=. 4 roundup cnt
cmd,(2 ic len),(8#ALPH0),y,(len-cnt)$ALPH0
)

NB. =========================================================
wraplen=: 4 : '(x rtyplen #y),y'
