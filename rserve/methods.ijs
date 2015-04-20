NB. methods
NB.
NB. all prefixed with 'rd'
NB. close|open
NB. cmd
NB. get|getexp|getraw
NB. set

NB. =========================================================
rdclose=: disconnect
rdopen=: connect

NB. =========================================================
NB. cmd: send command string to R for execution, no response
rdcmd=: 3 : 0
send CMD_voidEval wrapcmd toRs ,y
rread 0
)

NB. =========================================================
NB. get: with map response
rdget=: 3 : 0
send CMD_eval wrapcmd toRs ,y
rread 2
)

NB. =========================================================
NB. getexp: with REXP response
rdgetexp=: 3 : 0
send CMD_eval wrapcmd toRs ,y
rread 1
)

NB. =========================================================
NB. getraw
NB.
NB. send command string to R for execution, with raw response
NB.
NB. method intended for development only
rdgetraw=: 3 : 0
send CMD_eval wrapcmd toRs ,y
read ''
)

NB. =========================================================
NB. set v name(s) set value(s)
NB. names is a boxed list, or a space-delimited list
rdset=: 4 : 0
if. isopen x do.
  x=. deb x
  if. -. ' ' e. x do.
    x rdset1 y return.
  end.
  x=. <;._1 ' ',x
end.
if. -. (1=L.y) *. (1 >: #$y) *. (#x)=#y do.
  throw 'Names and values do not match for rdset'
end.

NB. debugging
NB. for_i. i.#x do.
NB. smoutput  (i pick x);i { y
NB.  (i pick x) rdset1 i pick y
NB. end.

x rdset1 each y

)

NB. =========================================================
NB. set v single name set value
rdset1=: 4 : 0

if. y -: NULL do.
  rdcmd x,'=',NULL return.
end.

t=. toRs x
s=. $y
if. 1 < #s do.
  y=. |:"2 y
  s=. |. 1 A. s
end.
send CMD_setSEXP wrapcmd t,toRx ,y
rread 0
if. 1 < #s do.
  s=. }. ; ',' ,each ": each s
  rdcmd 'dim(',x,')=c(',s,')'
end.
EMPTY
)
