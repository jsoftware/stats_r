NB. init
NB.
NB. dcom commands are sent one by one
NB. could also write to file and source from file

NB. =========================================================
cutcmd=: 3 : 0
if. L. y do. y return. end.
cmd=. fixcmd y
cmd=. <;._2 toJ cmd,LF
cmd=. cmd #~ '#' ~: {.&> cmd
cmd -. a:
)

NB. =========================================================
NB. cmd - run command with no return
cmd=: 3 : 0
wd 'psel ',HWNDP
for_c. cutcmd y do.
  wd 'olemethod w base EvaluateNoReturn *',>c
end.
)

NB. =========================================================
NB. cmdr - run command with return
NB. note: each sentence must have a valid return
cmdr=: 3 : 0
wd 'psel ',HWNDP
r=. ''
for_c. cutcmd y do.
  r=. r,LF,wd 'olemethod w base Evaluate *',>c
end.
}. r
)

NB. =========================================================
NB. cmdr - run command with extended return
cmdx=: 3 : 0
res=. cmdr 'exec("',y,'")'
res #~ (+./\ *. +./\.) res ~: LF
)

NB. =========================================================
NB. get - not yet supported
get=: 3 : 0
wd 'psel ',HWNDP
wd 'olemethod w base GetSymbol ',y
)

NB. =========================================================
NB. set - not yet supported
set=: 4 : 0
wd 'psel ',HWNDP
wd 'olemethod w base SetSymbol ',x,' ',y
)

NB. =========================================================
NB. exec - execute R command, return printed result
RDEF_exec=: 0 : 0
exec <- function(sourceText)
{
  sourceConn <- textConnection(sourceText, open="r")
  resultConn <- textConnection("resultText", open="w")
  on.exit(function() {sink();close(resultConn);close(sourceConn)})
  sink(resultConn)
  source(file=sourceConn,local=FALSE,echo=FALSE,print.eval=TRUE)
  sink()
  res <- paste(resultText, collapse="\n", sep="")
  close(resultConn)
  close(sourceConn)
  on.exit(NULL)
  return(res)
}
)
