NB. init

NB. path to R binary (change as appropriate):
RBINX=: '/usr/bin/R'
RBINW=: '"c:\program files\r\r-2.4.1\bin\r.exe"'
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
