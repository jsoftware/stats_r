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
  assert. (AKEYS,VKEYS)-: getmapr MAPRTREE
  assert. AKEYS -: getmapr attr MAPRTREE
  assert. VKEYS -: getmapr vars MAPRTREE
  assert. 2 2 = $'coefficients' getmapr MAPRTREE
  assert. 0.00001>0.01225676 - 'coefficients$Catholic' getmapr MAPRTREE
  assert. 47 2 = $'residuals' getmapr MAPRTREE
  assert. 8=3!:0 >{:"1 'residuals' getmapr MAPRTREE
  assert. 0.00001>_1.957214 - 'residuals$V. De Geneve' getmapr MAPRTREE
  assert. 47 2 = $'fitted.values' getmapr MAPRTREE
  assert. VARNM -: getmapr vars 'model' getmapr MAPRTREE
  assert. 11 = #getmapr attr 'model$`terms' getmapr MAPRTREE
  assert. 'Catholic'-:'terms$`term.labels' getmapr MAPRTREE
  assert. VARNM -: }.'model$`terms$`variables' getmapr MAPRTREE
  assert. 'numeric' -: 'model$`terms$`dataClasses$Catholic' getmapr MAPRTREE
  assert. 47 2 -: #&> 'qr$qr$`dimnames' getmapr MAPRTREE
  NB. Get more than one key
  datkeys=. 'model$'&,&.> getmapr vars 'model' getmapr MAPRTREE
  data=. datkeys getmapr"0 _ MAPRTREE
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