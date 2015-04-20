NB. example of R extension

coclass 'Rsplines'
coinsert 'rbase'

NB. bs - generate the B-spline basis matrix for a polynomial spline.
NB. argument is numeric list and degrees of freedom
NB. returns the matrix
bs1=: 3 : 0
'x df'=. y
try.
  rdcmd 'library(splines)'
  'x' rdset x
  'df' rdset df
  res=. rdget 'bs(x,df=df)'
catcht.
  sminfo 'Splines Library';throwtext_rserve_
end.
'`data' Rmap res
)

NB. bs - generate the B-spline basis matrix for a polynomial spline.
NB. argument is package, where
NB. value x must be given
NB. values df, degree and intercept are optional
bs2=: 3 : 0
df=. 3
degree=. 3
intercept=. 0
({."1 y)=. {:"1 y
arg=. x;df;degree;intercept
try.
  rdcmd 'library(splines)'
  'x df deg int' rdset arg
  res=. rdget 'bs(x,df=df,degree=deg,intercept=int)'
catcht.
  sminfo 'Splines Library';throwtext_rserve_
end.
'`data' Rmap res
)

cocurrent 'base'

smoutput bs1_Rsplines_ (p: i.7);3
x=. p: i. 7
degree=. 4
intercept=. 1
smoutput bs2_Rsplines_ pack 'x degree intercept'
