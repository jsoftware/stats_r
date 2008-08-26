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
  assert. AKEYS -: Rgetmap attr_rbase_ MAPRTREE
  assert. VKEYS -: Rgetmap vars_rbase_ MAPRTREE
  assert. 2 2 = $'coefficients' Rgetmap MAPRTREE
  assert. 0.00001>0.01225676 - 'coefficients$Catholic' Rgetmap MAPRTREE
  assert. 47 2 = $'residuals' Rgetmap MAPRTREE
  assert. 8=3!:0 >{:"1 'residuals' Rgetmap MAPRTREE
  assert. 0.00001>_1.957214 - 'residuals$V. De Geneve' Rgetmap MAPRTREE
  assert. 47 2 = $'fitted.values' rgetmap_rbase_ MAPRTREE
  assert. VARNM -: Rgetmap vars_rbase_ 'model' Rgetmap MAPRTREE
  assert. 11 = #Rgetmap attr_rbase_ 'model$`terms' Rgetmap MAPRTREE
  assert. 'Catholic'-:'terms$`term.labels' Rgetmap MAPRTREE
  assert. VARNM -: }.'model$`terms$`variables' Rgetmap MAPRTREE
  assert. 'numeric' -: 'model$`terms$`dataClasses$Catholic' Rgetmap MAPRTREE
  assert. 47 2 -: #&> 'qr$qr$`dimnames' Rgetmap MAPRTREE
  NB. Get more than one key
  datkeys=. 'model$'&,&.> Rgetmap vars_rbase_ 'model' Rgetmap MAPRTREE
  data=. datkeys Rgetmap"0 _ MAPRTREE
  assert. 2 47 -: $data
  assert. 8 = 3!:0 data

  'test0.ijs for mapr passed'
)

Note ''
Instead of adverbs could use verbs:
[name] getAttr STRUCT
[name] getVars STRUCT

[data] [name] setAttrs STRUCT
[data] [name] setVars STRUCT
)

smoutput test''