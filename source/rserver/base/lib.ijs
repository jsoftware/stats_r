NB. lib

ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
lib=. '"',(jpath '~addons/stats/r/lib/librserver.',ext),'"'

NB. =========================================================
rclose1=: (lib,' rclose > i i') & cd
rcmd1=: (lib,' rcmd > x *c') cd <
rget1=: (lib,' rget x *c *') & cd
ropen1=: (lib,' ropen > i i') & cd
rset1=: (lib,' rset > x *c *') & cd

NB. =========================================================
rclose=: 3 : 0
r=. rclose1 0
if. r=0 do. return. end.
throw errorcode r
)

NB. =========================================================
rcmd=: 3 : 0
r=. rcmd1 y
if. r=0 do. EMPTY return. end.
throw errorcode r
)

NB. =========================================================
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

NB. =========================================================
rget=: 3 : 0
sexp2map rgetx y
:
x Rmap rget y
)

NB. =========================================================
rgetexp=: sexp2list @ rgetx

NB. =========================================================
ropen=: 3 : 0
r=. ropen1 {.y,0
if. r=0 do. return. end.
throw errorcode r
)

NB. =========================================================
NB. set v name(s) set value(s)
NB. names is a boxed list, or a space-delimited list
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

NB. =========================================================
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
