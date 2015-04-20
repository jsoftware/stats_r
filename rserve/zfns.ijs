NB. zfns

cocurrent 'z'

Rclose=: rdclose_rserve_
Ropen=: rdopen_rserve_
Rcmd=: rdcmd_rserve_

Rget=: 3 : 0
rdget_rserve_ y
:
x Rmap_rbase_ rdget_rserve_ y
)

Rgetexp=: rdgetexp_rserve_
Rset=: rdset_rserve_
Rreset=: Ropen@Rclose

cocurrent 'base'
