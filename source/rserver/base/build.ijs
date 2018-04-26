
S=: jpath '~Addons/stats/r/source/rserver'
PA=: jpath '~Addons/stats/r'
Pa=: jpath '~addons/stats/r'

mkdir_j_ PA,'/lib'
mkdir_j_ Pa,'/lib'

dat=. readsourcex_jp_ '~Addons/stats/r/source/rserver/base'
dat=. dat, freads '~Addons/stats/r/rbase/rmap.ijs'
dat=. dat, 'rmap=: Rmap f.',LF
dat=. dat, freads '~Addons/stats/r/source/rserver/base/zfns.ijs'
dat fwritenew PA,'/rserver.ijs'
dat fwritenew Pa,'/rserver.ijs'

(PA,'/test_rserver.ijs') fcopynew '~Addons/stats/r/source/rserver/base/test_rserver.ijs'
(Pa,'/test_rserver.ijs') fcopynew '~Addons/stats/r/source/rserver/base/test_rserver.ijs'

f=. 3 : 0
(PA,'/lib/librserver.',y) fcopynew S,'/lib/librserver.',y
(Pa,'/lib/librserver.',y) fcopynew S,'/lib/librserver.',y
)

f each ;:'dll dylib so'
