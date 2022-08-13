NB. init

require 'task'
coclass 'prdcmd'
NB. init

NB. path to R binary (change as appropriate):
RBINX=: ((0-:2!:5'R_HOME'){::(2!:5'R_HOME');'/usr'),'/bin/R'
NB. RBINW=: '"c:\program files\r\r-3.1.3\bin\r.exe"'
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

NB. =========================================================
NB. create
NB.
NB. defines RCMD to run R CMD BATCH ...
NB.
NB. R options:
NB. --vanilla =
NB.   --no-save --no-environ --no-site-file --no-init-file --no-restore
NB. --quiet = no initial R blurb
NB. --slave = no extra messages
NB. --gui=gnome - for interactive use
create=: 3 : 0
makezfns''
opt=. ' CMD BATCH --quiet --slave --vanilla '
RCMD=: RBIN,opt,'"',RIN,'" "',ROUT,'"'
)

destroy=: codestroy
