require 'task'
coclass 'prdcmd'
RBINX=: '/usr/bin/R'
RBINW=: '"c:\program files\r\r-3.1.3\bin\r.exe"'
RBIN=: IFUNIX pick RBINW;RBINX
create=: 3 : 0
makezfns''
opt=. ' CMD BATCH --quiet --slave --vanilla '
RCMD=: RBIN,opt,'"',RIN,'" "',ROUT,'"'
)

destroy=: codestroy
addLF=: 3 : 0
y, (0<#y) # LF -. {: y
)
fixcmd=: 3 : 0
y rplc 'NB.';'#'
)
p=. jpath '~temp/'
q=. '/' (I.p='\') } p
RIN=: q,'r.in'
ROUT=: q,'r.out'
RPDF=: q,'r.pdf'
RRES=: q,'r.res'
RHDR=: ''
RFTR=: LF
cmd=: 3 : 0
ferase RIN;ROUT;RRES
RIN fwrite~ (addLF RHDR),(fixcmd y),RFTR
if. IFUNIX do.
  2!:1 RCMD
else.
  spawn_jtask_ RCMD
end.
)
cmdr=: 3 : 0
if. 1 e. 'RRES' E. y do.
  y=. y rplc 'RRES';RRES
else.
  y=. 'sink("',RRES,'")',LF,'print.eval=TRUE',LF,y,LF,'sink()'
end.
cmd y
fread RRES
)
cmds=: 3 : 0
cmd y
fread ROUT
)
cmdp=: 3 : 0
cmd 'pdf(file="',RPDF,'")',LF,y
)
cmdps=: 3 : 0
cmdp y
fread ROUT
)
ZFNS=: 0 : 0
cmd
cmdp
cmdps
cmdr
cmds
)
makezfn=: 4 : 0
smoutput ('R',y,'_z_')=: 3 : (y,'_',x,'_ y')
EMPTY
)
makezfns=: 3 : 0
(> coname'') & makezfn ;._2 ZFNS
)
