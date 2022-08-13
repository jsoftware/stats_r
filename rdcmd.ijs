require 'task'
coclass 'prdcmd'
RBINX=: ((0-:2!:5'R_HOME'){::(2!:5'R_HOME');'/usr'),'/bin/R'
RBINW=: 3 : 0^:('Win'-:UNAME)''
p=. (2!:5'programfiles'),'\r\'
d=. 1 1 dir p,'*'
i=. ;100#.each".each (2&}.@:}:each(#p)}.each d) rplc each <'.';' '
i=. 1 i.~d i.>./i
'R not installed in "program files" folder' assert i<#d
p=. ,;i{d
b=. 1 1  dir    p,'bin\x64\r.exe'
('R exe not found in ',;b) assert 1=#b
'"','"',~;b
)
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
