NB. =========================================================
NB. R range
range=: <./ , >./

NB.*rpath v Valid R path from jpath
NB. (R requires '\\' on windows but '/' works on all platforms)
rpath=: '\/' charsub jpath

NB. utils from Inverted Tables essay
ifa=: <@(>"1)@|:  NB. inverted from atomic
afi=: |:@:(<"_1@>)  NB. atomic from inverted
