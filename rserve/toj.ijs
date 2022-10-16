NB. toj
NB.
NB. convert R data to J
NB.
NB. SEXP is either data, or attributes;data

NB. =========================================================
NB. rread - read response from R
NB.  y=0  only check response
NB.    1  read SEXP format
NB.    2  read map format
rread=: 3 : 0
res=. read''
if. 1 ~: ax 2 { res,(3#{.a.) do.
  throw 'invalid response flag'
end.
rc=. _1 ic 2 {. res
NB. success response
if. rc = 1 do.
  if. y=0 do. EMPTY return. end.
  res=. 16 }. res
  if. 0 = #res do.
    throw 'no data'
  end.
  typ=. ax {. res
  res=. toJ res
  if. y=2 do.
    sexp2map res
  end.
else.
NB. fail response
  throw errormsg ax 3 { res
end.
)

NB. =========================================================
NB. toJ
toJ=: 3 : 0
typ=. ax {. y
'hdr len'=. rhdrlen y
dat=. hdr }. len {. y
select. typ
case. DT_INT do.
  toscalar _2 ic dat
case. DT_STRING do.
  toscalar (dat i. ALPH0) {. dat
case. DT_BYTESTREAM do.
  toscalar dat
case. DT_SEXP do.
  toJX dat
case. do.
  throw 'unknown type: ',":typ
end.
)

NB. =========================================================
NB. toJX
toJX=: 3 : 0
typ=. ax {. y
if. typ >: 128 do.
  toJXatt y
else.
  fixscalar toJXval y
end.
)

NB. =========================================================
NB. toJXatt
NB. convert attribute/data pair
toJXatt=: 3 : 0
typ=. av 128 | ax {. y
len=. 8 + _2 ic (5 6 7 { y), ALPH0
att=. 4 }. len {. y
dat=. len }. y
dat=. (typ,3 {.2 ic #dat),dat
,:toJX each att;dat
)

NB. =========================================================
toJXlist=: 3 : 0
r=. ''
dat=. y
while.
  #dat do.
  'hdr len'=. rhdrlen dat
  r=. r, <toJX len {. dat
  dat=. len }. dat
end.
r
)

NB. =========================================================
toJXval=: 3 : 0
typ=. ax {. y
dat=. 4 }. y
select. typ
case. XT_NULL do.
  NULL
case. XT_STR do.
  (dat i. ALPH0) {. dat
case. XT_LANG do.
  toJXlist dat
case. XT_SYM do.
  s: <toJXval dat
case. XT_BOOL do.
  ax {. dat
case. XT_S4 do.
  throw 'XT_S4 type not yet supported'
case. XT_VECTOR do.
  toJXlist dat
case. XT_LIST do.
  toJXlist dat
case. XT_CLOS do.
  toJX dat
case. XT_SYMNAME do.
  (dat i. ALPH0) {. dat
case. XT_LIST_NOTAG do.
  toJXlist dat
case. XT_LIST_TAG do.
  tag2sym toJXlist dat
case. XT_LANG_NOTAG do.
  toJXlist dat
case. XT_LANG_TAG do.
  tag2sym toJXlist dat
case. XT_VECTOR_EXP do.
  toJXlist dat
case. XT_VECTOR_STR do.
  toJXlist dat
case. XT_ARRAY_INT do.
  _2 ic dat
case. XT_ARRAY_DOUBLE do.
  _2 fc toNAJ dat
case. XT_ARRAY_STR do.
  (dat=ALPH0) <;._2 dat
case. XT_ARRAY_BOOL_UA do.
  ax dat
case. XT_ARRAY_BOOL do.
  (_2 ic 4 {.dat) $ ax 4 }. dat
case. XT_RAW do.
  len=. _2 ic 4 {. dat
  len {. 4 }. dat
case. XT_ARRAY_CPLX do.
  _2 j. /\ _2 fc toNAJ dat
case. XT_UNKNOWN do.
  typ=. (INTNUM i. {. _2 ic dat) pick INTNAM
  'Type unsupported by Rserve: ',typ
case. do.
  throw 'unknown extended type: ',":typ
end.
)

NB. =========================================================
toNAJ=: 3 : 0
n=. NAR e.~ d=. _8 [\ y
if. -. 1 e. n do. y return. end.
,NAJ (I.n) } d
)
