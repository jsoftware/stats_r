NB. cmd

p=. jpath '~temp/'
q=. '/' (I.p='\') } p
RIN=: q,'r.in'
ROUT=: q,'r.out'
RPDF=: q,'r.pdf'
RRES=: q,'r.res'

NB. =========================================================
NB. add these to any command
NB. e.g.
NB. RHDR=: 'options(echo=FALSE)'  - to suppress inputs
RHDR=: ''
RFTR=: LF

NB. =========================================================
NB. cmd - run R command with no return
cmd=: 3 : 0
ferase RIN;ROUT;RRES
RIN fwrite~ (addLF RHDR),(fixcmd y),RFTR
if. IFUNIX do.
  2!:1 RCMD
else.
  spawn_jtask_ RCMD
end.
)

NB. =========================================================
NB. cmdr - run command with return result
NB.
NB. either explicitly sink to RRES in the command, or else
NB. the command is wrapped in a sink to RRES.
cmdr=: 3 : 0
if. 1 e. 'RRES' E. y do.
  y=. y rplc 'RRES';RRES
else.
  y=. 'sink("',RRES,'")',LF,'print.eval=TRUE',LF,y,LF,'sink()'
end.
cmd y
fread RRES
)

NB. =========================================================
NB. cmds - run R command, return session
cmds=: 3 : 0
cmd y
fread ROUT
)

NB. =========================================================
NB. cmdp - run command with plot (to pdf)
cmdp=: 3 : 0
cmd 'pdf(file="',RPDF,'")',LF,y
)

NB. =========================================================
NB. cmdps - run command with plot (to pdf), return session
cmdps=: 3 : 0
cmdp y
fread ROUT
)
