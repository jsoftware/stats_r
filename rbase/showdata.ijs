NB. =========================================================
NB. Utilities for displaying formated R map structures
NB. and returning data from R map structures based on class of structure

NB.*getclass v Determines class of R map structure y
NB. If class not explicitly given by key, 
NB.   try and determine what it is: matrix, call, list, integer, numeric, ...
getclass=: 3 : 0
 res=. '`class' getmap y
 if. 0 = >./ #&> boxopen res do.
   res=. empty''
   if. ismap y  do. NB. check if map structure
     if. #dat=. '`data' Rmap y do. NB. if `data attribute present
       NB. rank 2 - matrix ('qr$qr' Rmap MAPR)
       NB. > rank 2 - array
       res=. (;:'vector matrix array'){::~ 1 2 i. #$dat
     else.
       if. 1 = L. y do. 
         res=. 'numeric' NB. - numeric ('residuals' Rmap MAPR)
       else.
         res=. 'unknown' NB. 
       end.
     end.
   else.  NB. not a map structure
     if. 0 = L. y do. NB. not boxed
       if. 1 < #$y do. 
         res=. (;:'vector matrix array'){::~ 1 2 i. #$y
       else.
         res=. datatype y
       end.
     else. NB. is boxed
       res=. 'list'
       NB. check if boxed list with `NULL in 2nd one - call
       NB. check if boxed list containing literals - character (Rmap 'residuals' Rmap MAPR)
     end.
   end.
 end.
 res
)

NB.*Rshow v Returns "formatted" representation of R map structure y
NB.  the representation depends on the class of the map structure
NB. eg: a data.frame will show row & column labels
Rshow=: 3 : 0
  class=. getclass y
  select. class 
  case. 'data.frame' do.
    showDataFrame y
  case. 'floating';'integer';'boolean' do.
    y
  case. 'factor' do.
    showFactor y
  case. 'list' do.
    showList y
  case. 'matrix' do.
    showMatrix y
  case. do.
    (class,' class not handled') assert 0
  end.
)

ifa=: <@(>"1)@|:
afi=: |:@:(<"_1@>)

NB.*Rdata v Returns data representation of R map structure y
NB.  the representation depends on the class of the map structure
NB.  result: data[;labels]
Rdata=: 3 : 0
  class=. getclass y
  select. class 
  case. 'data.frame' do.
    dataDataFrame y
  case. 'floating';'integer';'boolean' do.
    y
  case. 'list' do.
    dataList y
  case. 'factor' do.
    dataFactor y
  case. do.
    (class,' class not handled') assert 0
  end.
)

NB.*showDataFrame v Displays representation of R dataframe.
showDataFrame=: 3 : 0
  'Not a data.frame' assert 'data.frame' -: getclass y
  df=. y
  rlabels=. '`row.names' getmap df
  clabels=. getnames top df
  data=. clabels <@Rshow@getmap"0 _ df
  clabels=. (a: #~ 0 < #rlabels), clabels
  clabels ,: (<,.>rlabels) , ,.&.> data
)

showMatrix=: 3 : 0
  'Not a matrix' assert 'matrix' -: getclass y
  mat=. y
  if. 0 < L. mat do.
    mat=. '`data' getmap mat
    if. 0< #labels=. '`dimnames' Rmap y do.
      'rlabels clabels'=. labels
      mat=. (' 'joinstring clabels) , (,.>rlabels) ,. ' ' ,. ": mat
      NB. mat=. (,.>rlabels) ,. ' ' ,. ": mat
    end.
  end.
  mat
)

NB.*dataDataFrame v Displays representation of R dataframe.
dataDataFrame=: 3 : 0
  'Not a data.frame' assert 'data.frame' -: getclass y
  df=. y
  rlabels=. '`row.names' getmap df
  clabels=. getnames top df
  data=. clabels Rdata@getmap"0 _ df
  data;< rlabels;<clabels
)

showFactor=: 3 : 0
  'Not a factor' assert 'factor' -: getclass y
  fac=. y
  >ifa (<:@('`data'&Rmap) { '`levels'&Rmap) fac
)

dataFactor=: 3 : 0
  'Not a factor' assert 'factor' -: getclass y
  fac=. y
  <:@('`data'&Rmap) fac
)

showList=: >^:(1 = L.)
