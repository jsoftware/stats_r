NB. zfns
NB.
NB. interactive cover functions, defined by makezfns,
NB. e.g. Rcmd calls cmd in instance locale
NB.
NB. commands:
NB. Rcmd - command, no return
NB. Rcmdp - command, plot to pdf
NB. Rcmdps - command, plot to pdf, return session
NB. Rcmdr - command, return result
NB. Rcmds - command, return session

NB. =========================================================
ZFNS=: 0 : 0
cmd
cmdp
cmdps
cmdr
cmds
)

NB. =========================================================
makezfn=: 4 : 0
smoutput ('R',y,'_z_')=: 3 : (y,'_',x,'_ y')
EMPTY
)

NB. =========================================================
makezfns=: 3 : 0
(> coname'') & makezfn ;._2 ZFNS
)
