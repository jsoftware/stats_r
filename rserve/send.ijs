NB. NB. following was for sending att, but this not
NB. NB. yet supported by Rserve
NB.
NB. NB. =========================================================
NB. toRxatt=: 4 : 0
NB. nam=. XT_SYM wraplen toRx1 x
NB. val=. toRx1 y
NB. XT_LIST wraplen val,(4$ALPH0),nam
NB. )
NB.
NB. NB. =========================================================
NB. addatt=: 4 : 0
NB. att=. x
NB. dat=. y
NB. (128+ax{.dat) wraplen att, 4 }. dat
NB. )
NB.   dat=. toRx1 ,y
NB.   att=. 'dim' toRxatt $y
NB.   att addatt dat return.