NB. test0

Note 'To run tests:'
NB. Ensure Rserve sockets server is started
  load 'stats/r/rserve'
  load '~R/rbase/test0.ijs'
)

NB. Test data
Rcmd 'data(swiss)'
MAPRTREE=: Rgettree 'lm(Infant.Mortality ~ Catholic, data=swiss)'
MAPR=: Rget 'lm(Infant.Mortality ~ Catholic, data=swiss)'

AKEYS=: ,<'`class'
p=. 'assign';'call';'coefficients';'df.residual';'effects';'fitted.values'
VKEYS=: p, 'model';'qr';'rank';'residuals';'terms';'xlevels'
VARNM=:'Infant.Mortality';'Catholic'
test=: 3 : 0
  assert. (AKEYS,VKEYS)-: rgetmap_rbase_ MAPRTREE
  assert. AKEYS -: Rmap attr_rbase_ MAPRTREE
  assert. AKEYS -: Rattr MAPRTREE
  assert. VKEYS -: Rmap vars_rbase_ MAPRTREE
  assert. VKEYS -: Rvars MAPRTREE
  assert. 2 2 = $'coefficients' Rmap MAPRTREE
  assert. 0.00001>0.01225676 - 'coefficients$Catholic' Rmap MAPRTREE
  assert. 47 2 = $'residuals' Rmap MAPRTREE
  assert. 8=3!:0 >{:"1 'residuals' Rmap MAPRTREE
  assert. 0.00001>_1.957214 - 'residuals$V. De Geneve' Rmap MAPRTREE
  assert. 47 2 = $'fitted.values' rgetmap_rbase_ MAPRTREE
  assert. VARNM -: Rmap vars_rbase_ 'model' Rmap MAPRTREE
  assert. 11 = #Rmap attr_rbase_ 'model$`terms' Rmap MAPRTREE
  assert. 'Catholic'-:'terms$`term.labels' Rmap MAPRTREE
  assert. VARNM -: }. res=.'model$`terms$`variables' Rmap MAPRTREE
  assert. res -: 'model$terms$variables' getmap MAPR
  assert. 'numeric' -: 'model$`terms$`dataClasses$Catholic' Rmap MAPRTREE
  assert. 47 2 -: #&> 'qr$qr$`dimnames' Rmap MAPRTREE
  NB. Get more than one key
  datkeys=. 'model$'&,&.> Rvars 'model' Rmap MAPRTREE
  data=. datkeys Rmap"0 _ MAPRTREE
  assert. 2 47 -: $data
  assert. 8 = 3!:0 data
  assert. 187 2 = $Rtomap MAPRTREE
  'test0.ijs for rmap passed'
)

smoutput test''