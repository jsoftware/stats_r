NB. defs

XP_VEC=: _2147483648  NB. 1+i. list

NB. =========================================================
NB. error/status codes
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

NB. =========================================================
errorcode=: 3 : 0
ndx=. ERRNUM i. y
if. ndx<#ERRMSG do.
 ndx pick ERRMSG
else.
 'unknown error number: ',":y
end.
)
