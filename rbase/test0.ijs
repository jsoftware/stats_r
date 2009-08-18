NB. test0

Note 'To run tests:'
NB. Ensure Rserve sockets server is started
  load 'stats/r/rserve'
  load '~R/rbase/test0.ijs'
)

NB. Test data
erase 'LMSWISS AKEYS VKEYS VARNM'
Rreset''
Rcmd 'data(swiss)'
IRIS=: Rget 'iris'
LMSWISS=: Rget 'lm(Infant.Mortality ~ Catholic, data=swiss)'

AKEYS=: ,<'`class'
p=. 'assign';'call';'coefficients';'df.residual';'effects';'fitted.values'
VKEYS=: p, 'model';'qr';'rank';'residuals';'terms';'xlevels'
VARNM=:'Infant.Mortality';'Catholic'
test=: 3 : 0
  assert. (AKEYS,VKEYS)-: ~.;{.@parsekey_rbase_ &.> getmap_rbase_ LMSWISS
  assert. AKEYS -: getattr_rbase_ Rmap LMSWISS
  assert. AKEYS -: Rattr LMSWISS
  assert. VKEYS-: ~.;{.@parsekey_rbase_ &.> Rnames LMSWISS
  assert. 2 2 = $'coefficients' Rmap LMSWISS
  assert. 0.00001>0.01225676 - 'coefficients$Catholic' Rmap LMSWISS
  assert. 47 2 = $'residuals' Rmap LMSWISS
  assert. 8=3!:0 >{:"1 'residuals' Rmap LMSWISS
  assert. 0.00001>_1.957214 - 'residuals$V. De Geneve' Rmap LMSWISS
  assert. 47 2 = $'fitted.values' getmap_rbase_ LMSWISS
  assert. *./ VARNM e. Rmap getnames_rbase_ 'model' Rmap LMSWISS
  assert. 13 = #Rmap getattr_rbase_ 'model$`terms' Rmap LMSWISS
  assert. 'Catholic'-:'terms$`term.labels' Rmap LMSWISS
  assert. VARNM -: }. res=.'model$`terms$`variables' Rmap LMSWISS
  assert. res -: 'model$`terms$`variables' getmap LMSWISS
  assert. 'numeric' -: 'model$`terms$`dataClasses$Catholic' Rmap LMSWISS
  assert. 47 2 -: #&> 'qr$qr$`dimnames' Rmap LMSWISS
  NB. Get more than one key
  datkeys=. 'model$'&,&.> Rnames 'model' Rmap LMSWISS
  data=. datkeys Rmap"0 _ LMSWISS
  assert. 2 47 -: $data
  assert. 8 = 3!:0 data
  data=. (;:'assign BADNAME rank xlevels') <@Rmap"0 _ LMSWISS
  assert. 2 0 1 1 -: #&> data
  assert. 1 1 0 2 -: #@$&> data
  'test0.ijs for rmap passed'
)

test2=: 3 : 0
  assert 'data.frame' -: Rclass IRIS
  assert 'data.frame' -: Rclass 'model' Rmap LMSWISS
  assert 'qr' -: Rclass 'qr' Rmap LMSWISS
  assert 'matrix' -: Rclass 'qr$qr' Rmap LMSWISS
  assert 'matrix' -: Rclass 'qr$qr$`data' Rmap LMSWISS
  assert 'list' -: Rclass 'qr$qr$`dimnames' Rmap LMSWISS
  assert 'integer' -: Rclass 'rank' Rmap LMSWISS
  assert 'floating' -: Rclass 'qr$qraux' Rmap LMSWISS
  'class-based tests for showdata passed'
)

smoutput test''
smoutput test2''