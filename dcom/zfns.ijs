NB. zfns
NB.
NB. interactive cover functions, defined by makezfns,
NB. e.g. Rcmd calls cmd in instance locale
NB.
NB. commands:
NB. Rcmd - command, no return
NB. Rcmdr - command, return result
NB. Rcmdx - command, with extended return

NB. =========================================================
ZFNS=: 0 : 0
cmd
cmdr
cmdx
)

NB. =========================================================
makezfn=: 4 : 0
('R',y,'_z_')=: 3 : (y,'_',x,'_ y')
EMPTY
)

NB. =========================================================
makezfns=: 3 : 0
(> coname'') & makezfn ;._2 ZFNS
)
