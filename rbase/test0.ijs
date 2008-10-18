NB. test0

Note 'To run tests:'
NB. Ensure Rserve sockets server is started
  load 'stats/r/rserve'
  load '~R/rbase/test0.ijs'
)

NB. Test data
erase 'MAPR AKEYS VKEYS VARNM'
Rreset''
Rcmd 'data(swiss)'
MAPR=: Rget 'lm(Infant.Mortality ~ Catholic, data=swiss)'

AKEYS=: ,<'`class'
p=. 'assign';'call';'coefficients';'df.residual';'effects';'fitted.values'
VKEYS=: p, 'model';'qr';'rank';'residuals';'terms';'xlevels'
VARNM=:'Infant.Mortality';'Catholic'
test=: 3 : 0
  assert. (AKEYS,VKEYS)-: ~.;{.@parsekey_rbase_ &.> rgetmap_rbase_ MAPR
  assert. AKEYS -: Rmap attr_rbase_ MAPR
  assert. AKEYS -: Rattr MAPR
  assert. VKEYS-: ~.;{.@parsekey_rbase_ &.> Rvars MAPR
  assert. 2 2 = $'coefficients' Rmap MAPR
  assert. 0.00001>0.01225676 - 'coefficients$Catholic' Rmap MAPR
  assert. 47 2 = $'residuals' Rmap MAPR
  assert. 8=3!:0 >{:"1 'residuals' Rmap MAPR
  assert. 0.00001>_1.957214 - 'residuals$V. De Geneve' Rmap MAPR
  assert. 47 2 = $'fitted.values' rgetmap_rbase_ MAPR
  assert. *./ VARNM e. Rmap vars_rbase_ 'model' Rmap MAPR
  assert. 13 = #Rmap attr_rbase_ 'model$`terms' Rmap MAPR
  assert. 'Catholic'-:'terms$`term.labels' Rmap MAPR
  assert. VARNM -: }. res=.'model$`terms$`variables' Rmap MAPR
  assert. res -: 'model$`terms$`variables' getmap MAPR
  assert. 'numeric' -: 'model$`terms$`dataClasses$Catholic' Rmap MAPR
  assert. 47 2 -: #&> 'qr$qr$`dimnames' Rmap MAPR
  NB. Get more than one key
  datkeys=. 'model$'&,&.> Rvars 'model' Rmap MAPR
  data=. datkeys Rmap"0 _ MAPR
  assert. 2 47 -: $data
  assert. 8 = 3!:0 data
  data=. (;:'assign BADNAME rank xlevels') <@Rmap"0 _ MAPR
  assert. 2 0 1 1 -: #&> data
  assert. 1 1 0 2 -: #@$&> data
  'test0.ijs for rmap passed'
)

smoutput test''