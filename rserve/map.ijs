NB. map

sData=: <'`data'
sDim=: <'`dim'
sNames=: <'`names'
sRownames=: <'`row.names'

NB. =========================================================
NB. sexp2map
NB. globals:
NB.  IfAtt if result has attributes, and not just data.
sexp2map=: 3 : 0
IfAtt=: 0
dat=. att2map y
if. -.IfAtt do. return. end.
ndx=. 1 i.~ 0 = # &> {."1 dat
NB. if. ndx < #y do.
NB.   dat=. (<'`data') (<ndx;0)} dat
NB. end.
dat /: symsort each {."1 dat
)

NB. =========================================================
att2map=: 3 : 0
if. -. ismatrix y do.
  if. isopen y do.
    y
  else.
    att2map each y
  end.
  return.
end.

'att dat'=. att2map each ,y

if. -. ismatrix att do.
  if. 2 | #att do.
    throw 'Invalid attribute list - not in value;attribute pairs'
  end.
  att=. _2 |.\ att
end.

NB. ---------------------------------------------------------
NB. dim
ndx=. ({."1 att) i. sDim
if. ndx<#att do.
  dim=. 1 pick ndx{att
  att=. (<<<ndx){att
  dat=. _2 |: (|. dim) $ dat
  if. 0=#att do. dat return. end.
end.

NB. ---------------------------------------------------------
IfAtt=: 1

NB. ---------------------------------------------------------
NB. names attribute:
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

NB. ---------------------------------------------------------
NB. row.names attribute
ndx=. ({."1 att) i. sRownames
if. ndx < #att do.
  ind=. <ndx;1
  att=. (<fixxp >ind{att) ind}att
end.

NB. ---------------------------------------------------------
att=. flatt att

NB. ---------------------------------------------------------
res,att
)

NB. =========================================================
flatt=: 3 : 0
msk=. 2 = #@$ &> {:"1 y
if. -. 1 e. msk do. y return. end.
((-.msk) # y),;flatt1"1 msk # y

)

NB. =========================================================
flatt1=: 3 : 0
'nam mat'=. y
<nam prefixnames mat
)
