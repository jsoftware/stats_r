NB. tor
NB.
NB. convert J data to R

NB. =========================================================
NB. to R as bytestream
toRb=: 3 : 0
(DT_BYTESTREAM{a.),(3 {. 2 ic #y),y
)

NB. =========================================================
NB. to R as int
toRi=: 3 : 0
(DT_INT{a.),(3 {. 2 ic len),2 ic y
)

NB. =========================================================
NB. to R as string
toRs=: 3 : 0
dat=. y,ALPH0
len=. 4 roundup cnt=. #dat
(DT_STRING{a.),(3 {. 2 ic len),dat,(len-cnt)#ALPH0
)

NB. =========================================================
NB. to R as SEXP
toRx=: 3 : 'DT_SEXP wraplen toRx1 y'

NB. =========================================================
NB. !!!
NB. 24Aug08 - cannot get booleans working with set
NB. use ints instead
NB. cannot get NULL working yet...

toRx1=: 3 : 0
if. 1 < #$y do.
  throw 'data should be scalar or vector'
end.
if. L. y do.
  throw 'boxed not yet' return.
end.
typ=. 3!:0 y

typ=. typ + 3*1=typ
select. typ
case. 1 do.
  XT_ARRAY_BOOL wraplen ,(y{a.),"0 1[255 255 255{a.
case. 2 do.
  dat=. y,ALPH0
  len=. 4 roundup cnt=. #dat
  (XT_STR{a.), (3 {. 2 ic cnt), dat,(len-cnt)#ALPH0
case. 4 do.
  XT_ARRAY_INT wraplen 2 ic y
case. 8 do.
  XT_ARRAY_DOUBLE wraplen 2 fc y
case. 16 do.
  throw 'complex data not supported by Rserve'
case. do.
  throw 'datatype ',(":typ),' not supported by Rserve'
end.
)
