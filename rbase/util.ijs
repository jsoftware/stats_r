NB. util

NB. =========================================================
NB. R range
range=: <./ , >./

NB.*rpath v Valid R path from jpath
NB. (R requires '\\' on windows but '/' works on all platforms)
rpath=: '\/' charsub jpath