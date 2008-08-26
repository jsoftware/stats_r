NB. utilities for working with R structures

DELIM=: '$'

isAttr=: '`' = [: {. &> {."1^:ismap_jmap_

getAttr=: I.@:isAttr { ]
getVars=: I.@:-.@:isAttr { ]


NB.*getmapr v Returns keys/values of R tree structure
NB. form: monad-  getmapr maprtree
NB. form: dyad-   nestedkey getmapr treestruct
NB. nestedkey is: string consisting of variable names and 
NB.               attribute names delimited by DELIM. 
NB.              Attribute names are signified by a 
NB.              leading backtick (`) 
NB. eg: KEYS=: getmapr MAPRTREE
NB. eg: VALUE=: 'qr$qr$`dimnames' getmapr MAPRTREE
getmapr=: 3 : 0
  getmap y
  :
  for_i. parsekey boxopen x do.
    y=. i getmap y
  end.
)

NB.parsekey v Parses string of key name for getmapr 
NB. returns list of boxed literals describing key
NB.  eg:  parsekey 'terms$`terms.labels'
parsekey=: [: <;._1 DELIM&,@:>

NB.*attr a Filters results of getmapr to only attributes
NB. eg: KEYS=: getmapr attr MAPRTREE
NB. eg: VALUE=: 'model' getmapr attr MAPRTREE
attr=: 1 : 'getAttr_rbase_@:u'

NB.*vars a Filters results of getmapr to non-attributes
NB. eg: KEYS=: getmapr vars MAPRTREE
NB. eg: VALUE=: 'model' getmapr vars MAPRTREE
vars=: 1 : 'getVars_rbase_@:u'

getmapr_z_=: getmapr_rbase_
attr_z_   =: attr_rbase_
vars_z_   =: vars_rbase_