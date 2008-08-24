NB. event

FORCETHROW=: 0
throwtext=: ''

NB. =========================================================
NB. throw
NB.
NB. write y to throwtext_rserve_
NB.
NB. if debug is on and not FORCETHROW, display y in
NB. an info box, and stop all verbs on stack,
NB. otherwise write text to the session and throw.
throw=: 3 : 0
throwtext_rserve_=: y
if. FORCETHROW < dbq'' do.
  dbss ; (}. {."1 (13!:13)'') ,each <' *:*,'
  info y
else.
  smoutput y
  throw.
end.
)

