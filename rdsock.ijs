NB. built from project: ~R/dsock/dsock
NB. init

script_z_ '~system/main/dll.ijs'
script_z_ '~system/main/libpath.ijs'
script_z_ '~system/main/socket.ijs'

coclass 'prdsock'


coinsert 'jsocket'

NB. =========================================================
create=: 3 : 0
makezfns''
disconnect''
try.
  'host port'=. 2 {. boxopen y
  HOST=: host, (0=#host)#'localhost'
  PORT=: {. port,DEFPORT
NB. for nonce HOST not used
NB.   HOSTIP=: gethostip HOST
  HOSTIP=: 2;'127.0.0.1'
  SK=: sd_socket''
  sd_connect SK;HOSTIP,<PORT
  res=. read1 SK
  if. -. 'RsrvQAP1' -: (, 0 8 +/ i.4) { res do.
    1;res
  end.
  att=. _4 [\ (12 }. res) -. '-',CRLF
NB. expect no attributes:
  if. #att do.
    1;res
  else.
    OK
  end.
catcht. thrown end.
coname''
)

NB. =========================================================
destroy=: 3 : 0
disconnect''
codestroy''
)

NB. util

ALPH0=: {.a.
EMPTY=: i.0 0
NULL=: 'NULL'

NB. =========================================================
ax=: a.&i.
atoi=: 256 #. a. i. |.
av=: ({&a.)`] @. (2 = 3!:0)
firstones=: > (0: , }:)
info=: wdinfo @ ('dsock'&;)
ischar=: 2 = 3!:0
isinteger=: (-: <.) ::0:
isnan=: 128!:5
isscalar=: 0 = #@$
issymbol=: 65536 = 3!:0
round=: [ * [: <. 0.5 + %~
roundint=: <. @ +&0.5
roundup=: [ * [: >. %~
toscalar=: {.^:((,1) -: $)
sym2str=: >@(5&s:) :: ]

NB. =========================================================
NB.commasep v separates boxed items with comma
commasep=: 3 : 0
if. L. y do.
  }. ; (','&, @ ":) each y
else.
  , ": y
end.
)

NB. =========================================================
errormsg=: 3 : 0
if. y e. ERRNUM do.
  'Error code: ',(":y),' ',(ERRNUM i. y) pick ERRMSG
else.
  'Status code: ',":y
end.
)

NB. =========================================================
prefixnames=: 4 : 0
if. 0=#x do. y return. end.
nms=. {."1 y
msk=. 0 < #&> nms
nms=. (<x) ,each (msk{'';'.') ,each nms
nms,.{:"1 y
)

NB. =========================================================
NB. returns hdrlen, overall len from data
rhdrlen=: 3 : 0
if. 64 < 128 | ax {. y do.
  8,8 + atoi }. 8 {. y
else.
  4,4 + atoi }. 4 {. y
end.
)

NB. =========================================================
NB. use for both DT and XT
rtyplen=: 4 : 0
typ=. x
len=. y
if. len < 2^24 do.
  (av typ),3 {. 2 ic len
else.
  av (typ + XT_LARGE),|.(7#256)#:len
end.
)

NB. =========================================================
NB. convert tags to symbols:
tag2sym=: 3 : 0
ndx=. >:+:i.<.-:#y
tag=. ndx { y
if. 0 e. *./ (2 = # &> tag), (<'') = {.&> tag do.
  throw 'Invalid tag list in SEXP' return.
end.
(<&> s: {:&> tag) ndx} y
)

NB. =========================================================
throw=: 3 : 0
msg=. y
if. ischar msg do. msg=. 1;msg end.
thrown=: msg
info 1 pick msg
throw.
)

NB. =========================================================
NB. wrap socket command
wrapcmd=: 4 : 0
cmd=. 2 ic x
cnt=. #y
len=. 4 roundup cnt
cmd,(2 ic len),(8#ALPH0),y,(len-cnt)$ALPH0
)

NB. =========================================================
wraplen=: 4 : '(x rtyplen #y),y'



NB. defs
NB. source: http://svn.rforge.net/Rserve/trunk/src/Rsrv.h

OK=: 0;EMPTY
THROW=: ''

NB. default port:
DEFPORT=: 6311

NB. following is NA returned by R, this is
NB. returned as the NA value (default __)
NAR=: 162 7 0 0 0 0 248 127 { a.
NAJ=: 2 fc __

NB. =========================================================
NB. commands
CMD_login=: 1           NB. "name\npwd"
CMD_voidEval=: 2        NB. string
CMD_eval=: 3            NB. string : encoded SEXP
CMD_shutdown=: 4        NB. [admin-pwd]
CMD_openFile=: 16       NB. fn
CMD_createFile=: 17     NB. fn
CMD_closeFile=: 18      NB. -
CMD_readFile=: 19       NB. [int size] : data... ;
CMD_writeFile=: 20      NB. data
CMD_removeFile=: 21     NB. fn
CMD_setSEXP=: 32        NB. string(name), REXP :
CMD_assignSEXP=: 33     NB. string(name), REXP : as setSEXP except name is parsed
CMD_setBufferSize=: 129 NB. [int sendBufSize]

NB. =========================================================
NB. data types
NB.
NB. string       0 -terminated
NB. bytestream   stream of bytes (may contain 0)
NB. sexp         encoded SEXP
NB. array        array of objects (i.e. first 4 bytes specify how many
NB.              subsequent objects are part of the array; 0 is legitimate)
NB. large        if this flag is set then the length of the object
NB.              is coded as 56-bit integer enlarging the header by 4 bytes
NB.
NB. Types used by the current Rserve implementation
NB.   DT_INT (4 bytes) integer
NB.   DT_STRING (n bytes) null terminated string
NB.   DT_BYTESTREAM (n bytes) any binary data
NB.   DT_SEXP R's encoded SEXP, see below
DT_INT=: 1
DT_CHAR=: 2
DT_DOUBLE=: 3
DT_STRING=: 4
DT_BYTESTREAM=: 5
DT_SEXP=: 10
DT_ARRAY=: 11
DT_LARGE=: 64

NB. =========================================================
NB. R internal types are:
NB. user data:
NB.   logical, integer, double, complex,character, raw and list,
NB.   NULL, closure (function), special, builtin
NB. system internals:
NB.   symbol, pairlist, environment, promise,language, char, ...,
NB.   any, expression, externalptr, bytecode, weakref.
j=. <;._2 (0 : 0)
0  nil = NULL
1  symbols
2  lists of dotted pairs
3  closures
4  environments
5  promises: [un]evaluated closure arguments
6  language constructs (special lists)
7  special forms
8  builtin non-special forms
9  "scalar" string type (internal only)*/
10 logical vectors
13 integer vectors
14 real variables
15 complex variables
16 string vectors
17 dot-dot-dot object
18 make "any" args work.
19 generic vectors
20 expressions vectors
21 byte code
22 external pointer
23 weak reference
24 raw bytes
99 Closure or Builtin or Special
)

INTNAM=: 3 }. each j
INTNUM=: 0 ". &> 2 {. each j

NB. =========================================================
NB. expression types
NB.    REXP - R expressions are packed in the same way as command parameters
NB.    transport format of the encoded Xpressions:
NB.    [0] int type/len (1 byte type, 3 bytes len - same as SET_PAR)
NB.    [4] REXP attr (if bit 8 in type is set)
NB.    [4/8] data ..
NB.
XT_NULL=: 0           NB. data: [0]
XT_INT=: 1            NB. data: [4]int
XT_DOUBLE=: 2         NB. data: [8]double
XT_STR=: 3            NB. data: [n]char null-term. strg.
XT_LANG=: 4           NB. data: same as XT_LIST
XT_SYM=: 5            NB. data: [n]char symbol name
XT_BOOL=: 6           NB. data: [1] byte boolean (1=TRUE, 0=FALSE, 2=NA)
XT_S4=: 7             NB. data: [0] ?
XT_VECTOR=: 16        NB. data: [?]REXP
XT_LIST=: 17          NB. X head, X vals, X tag
XT_CLOS=: 18          NB. X formals, X body  (closure)
XT_SYMNAME=: 19       NB. same as XT_STR
XT_LIST_NOTAG=: 20    NB. same as XT_VECTOR
XT_LIST_TAG=: 21      NB. P X tag, X val, Y tag, Y val, ...
XT_LANG_NOTAG=: 22    NB. same as XT_LIST_NOTAG
XT_LANG_TAG=: 23      NB. same as XT_LIST_TAG
XT_VECTOR_EXP=: 26    NB. same as XT_VECTOR
XT_VECTOR_STR=: 27    NB. same as XT_VECTOR (unused, use XT_ARRAY_STR instead) */
XT_ARRAY_INT=: 32     NB. data: [n*4]int,int,..
XT_ARRAY_DOUBLE=: 33  NB. data: [n*8]double,double,..
XT_ARRAY_STR=: 34     NB. data: [?]string,string,..
XT_RAW=: 37           NB. P data: int(n),byte,byte,...
XT_ARRAY_CPLX=: 38    NB. P data: [n*16]double,double,... (Re,Im,Re,Im,...)
XT_ARRAY_BOOL_UA=: 35 NB. data: [n]byte,byte,..  (unaligned! NOT supported anymore)
XT_ARRAY_BOOL=: 36    NB. data: int(n),byte,byte,...
XT_UNKNOWN=: 48       NB. data: [4]int - SEXP type (as from TYPEOF(x))
XT_LARGE=: 64         NB. new in 0102: length coded as 56-bit integer enlarging the header by 4 bytes
XT_HAS_ATTR=: 128     NB. flag; if set, the following SEXP is the attribute

NB. =========================================================
NB. error/status codes
NB. stat codes; 0-64 are reserved for program specific codes - e.g. for R
NB.    connection they correspond to the stat of Parse command.
NB.    the following codes are returned by the Rserv itself.
NB.    codes <0 denote Rerror as provided by R_tryEval
j=. <;._2 (0 : 0)
65 auth. failed or auth. requested but no login came.
66 connection closed or broken packet killed it
67 unsupported/invalid command
68 some parameters are invalid
69 R-error occurred, usually followed by connection shutdown
70 I/O error
71 attempt to perform file Read/Write on closed file
72 access denied to command
73 unsupported command
74 unknown command
75 incoming packet is too big.
76 the requested object is too big
77 out of memory. the connection is usually closed after this
)

ERRMSG=: 3 }. each j
ERRNUM=: 0 ". &> 2 {. each j


NB. flat

NB. =========================================================
NB. flatten result of toJX
NB. removes unnecessary nesting and does toscalar
flatJX=: 3 : 0
res=. '' flatJX1 y
if. 1 = #res do.
  if. 0 = # > {.{.res do.
    1 pick {.res
  end.
else.
  res /: {."1 res
end.
)

NB. =========================================================
flatJX1=: 4 : 0
'att dat'=. y
pfx=. x
dat=. toscalar dat

NB. ---------------------------------------------------------
if. 0=#att do.
  ,:pfx;dat return.
end.

NB. ---------------------------------------------------------
NB. apply names attribute:
ndx=. att i. <s:<'names'
if. ndx = #att do.
  res=. ,: '';<dat
else.
  nms=. (ndx-1) pick att
  if. (#nms) ~: #dat do.
    throw 'Names do not match data' return.
  end.
  att=. (<<<ndx-0 1) { att
  if. 0 = L. dat do.
    res=. nms,.<"_1 dat
  else.
NB.     res=. i.0 2
NB.     for_i. i.#dat do.
NB.       res=. res, (i pick nms) flatJX1 i pick dat
NB.     end.
    res=. ; nms flatJX1 each dat
  end.
end.

NB. ---------------------------------------------------------
att=. _2 [\ att

NB. ---------------------------------------------------------
NB. do known attributes:
kat=. ;: 'class dimnames'
skat=. <&> s: kat
aid=. {:"1 att
ndx=. I. aid e. skat
if. #ndx do.
dbstopme''
  sel=. ((skat i. ndx{aid){kat),.{."1 ndx{att
  res=. res, sel
  att=. (<<<ndx) { att 
end.

NB. ---------------------------------------------------------
NB. get remaining attributes:
for_d. att do.
  'val hdr'=. d
  res=. res, (sym2str hdr) flatJX1 val
end.

NB. ---------------------------------------------------------
if. #pfx do.
  res=. pfx prefixnames res
end.

res

)



NB. methods
NB.
NB. all methods return a pair:
NB.   returncode (0=success)
NB.   result or throw message
NB.
NB. all methods wrapped in try/catcht
NB.
NB. close
NB. cmd|cmdr|cmdraw
NB. get|set

NB. =========================================================
close=: 3 : 0
destroy''
OK
)

NB. =========================================================
NB. cmd: send command string to R for execution, no response
cmd=: 3 : 0
try.
  send CMD_voidEval wrapcmd toRs ,y
  rread 0
catcht. thrown end.
)

NB. =========================================================
NB. cmdr: with response
cmdr=: 3 : 0
try.
  send CMD_eval wrapcmd toRs ,y
  rread 1
catcht. thrown end.
)

NB. =========================================================
NB. cmdraw
NB.
NB. send command string to R for execution, with raw response
NB.
NB. method intended for development only
cmdraw=: 3 : 0
try.
  send wrapcmd y
  0;read ''
catcht. thrown end.
)

NB. =========================================================
disconnect=: 3 : 0
if. #SK do.
  sdclose :: ] SK
end.
SK=: ''
)

NB. =========================================================
NB. get - identical to cmdr
get=: cmdr

NB. =========================================================
NB. set v name set value
set=: 4 : 0
t=. toRs x
s=. $y
if. 1 < #s do.
  y=. |:"2 y
  s=. |. 1 A. s
end.
send CMD_setSEXP wrapcmd t,toRx ,y
rread 0
if. 1 < #s do.
  s=. }. ; ',' ,each ": each s
  cmd 'dim(',x,')=c(',s,')'
end.
)


NB. sock

SK=: ''
MAX=: 50000
WAIT=: 20000
WAIT=: 2000  NB. 2 seconds for testing
SKACCEPT=: SKLISTEN=: '' NB. for server

NB. =========================================================
sd_accept=: 3 : '0 pick sd_check sdaccept y'
sd_bind=: 3 : 'sd_check sdbind y'
sd_reset=: 3 : 'sdcleanup $0'
sd_gethostbyname=: 3 : 'sd_check sdgethostbyname y'
sd_listen=: 3 : 'sd_check sdlisten y'
sd_recv=: 3 : '0 pick sd_check sdrecv y'
sd_select=: 3 : 'sd_check sdselect y'
sd_send=: 4 : 'sd_check x sdsend y'
sd_socket=: 3 : '0 pick sd_check sdsocket $0'

NB. =========================================================
sd_connect=: 3 : 0
res=. sdconnect y
if. 0 pick res do.
  throw 'Unable to connect: ',sderror res
else.
  EMPTY
end.
)

NB. =========================================================
gethostip=: 3 : 0
if. 3 = +/ '.' = y do.
  txt=. ' ' (bx '.' = y) } y
  if. 4 = # (0 ". txt) -. 0 do. 2;y return. end.
end.
sd_gethostbyname y
)

NB. =========================================================
readsk=: 3 : 0
r=. read1 y
if. 8 > #r do. return. end.
len=. 16 + _2 ic 4 5 6 7 { r
while. len > #r do.
  txt=. read1 y
  if. 0=#txt do.
    throw 'read'
  else.
    r=. r, txt
  end.
end.
r
)

NB. =========================================================
NB. read1
read1=: 3 : 0
if. y e. 0 pick sd_select y;'';'';WAIT do.
  sd_recv y,MAX
else.
  ''
end.
)

NB. =========================================================
NB. sd_check
NB. check socket result
sd_check=: 3 : 0
if. 0 = 0 pick y do. }. y return. end.
throw 'socket ',sderror y
)

NB. =========================================================
sendsk=: 4 : 0
dat=. x
whilst. #dat do.
  blk=. (MAX <. #dat) {. dat
  blk sd_send y,0
  dat=. MAX }. dat
end.
EMPTY
)

NB. =========================================================
read=: 3 : 'readsk SK'
send=: 3 : 'y sendsk SK'


NB. toj
NB.
NB. convert R data to J
NB.
NB. SEXP is either data, or attributes;data

tomap=: [: ,:'';<@toscalar

NB. =========================================================
NB. rread - read response from R
NB.  y=0  only check response OK
NB.     1  read rest of response
rread=: 3 : 0
res=. read''
if. 1 ~: ax 2 { res do.
  throw 1;'invalid response flag'
end.
rc=. _1 ic 2 {. res
if. rc = 1 do.
  if. y=0 do.
    OK
  else.
    rtoJ 16 }. res
  end.
else.
  throw 1;errormsg ax 3 { res
end.
)

NB. =========================================================
NB. convert R data to J
NB.
NB. return returncode;result
rtoJ=: 3 : 0
if. 0 = #y do.
  throw 1;'no data'
end.
0;<toJ y
)

NB. =========================================================
NB. toJ
NB.
NB. note only a few types are used in Rserve
toJ=: 3 : 0
typ=. ax {. y
'hdr len'=. rhdrlen y
dat=. hdr }. len {. y
select. typ
case. DT_INT do.
  toscalar _2 ic dat
case. DT_STRING do.
  toscalar (dat i. ALPH0) {. dat
case. DT_BYTESTREAM do.
  toscalar dat
case. DT_SEXP do.
  flatJX toJX dat
case. do.
  throw 'unknown type: ',":typ
end.
)

NB. not used in Rserve:
NB. case. DT_CHAR do.
NB.   throw 'unexpected char type'
NB. case. DT_DOUBLE do.
NB.   throw 'unexpected double type'
NB. case. DT_ARRAY do.
NB.   throw 'unexpected array type'

NB. =========================================================
toJX=: 3 : 0
typ=. ax {. y
if. typ >: 128 do.
  toJXatt y
else.
  '';<toJXval y
end.
)

NB. =========================================================
NB. assume attribute pair are not themselves attribute lists
toJXatt=: 3 : 0
typ=. av 128 | ax {. y
len=. 8 + _2 ic (5 6 7 { y), ALPH0
att=. 4 }. len {. y

NB. ---------------------------------------------------------
NB. check attributes form usual dat;tag pattern:
if. XT_LIST_TAG ~: ax {.att do.
  throw 'Unrecognized attribute list tag' return.
end.
dbstopme 180=#y
att=. toJXval att
dbstopme 1 e. (<s:<'dimnames') e. att
ndx=. +: i.-:#att
if. 0 e. (<'') = {.&> ndx{att do.
  throw 'Unrecognized attribute list data' return.
end.
att=. ({: &> ndx{att) ndx} att

NB. ---------------------------------------------------------
dat=. len }. y
dat=. toJXval (typ,3 {.2 ic #dat),dat
ndx=. att i. <s:<'dim'
if. ndx < #att do.
  dim=. (ndx-1) pick att
  dat=. _2 |: (|. dim) $ dat
  att=. (<<<ndx-0 1) { att
end.
att;<dat
)

NB. =========================================================
toJXlist=: 3 : 0
r=. ''
dat=. y
while.
NB. remove spurious ALPH0s in representation:
  dat=. (4 * (4 {. dat) -: 4$ALPH0) }. dat
  #dat do.
  'hdr len'=. rhdrlen dat
  r=. r, <toJX len {. dat
  dat=. len }. dat
end.
r
)

NB. =========================================================
toJXval=: 3 : 0
typ=. ax {. y
dat=. 4 }. y
select. typ
case. XT_NULL do.
  NULL
case. XT_STR do.
  (dat i. ALPH0) {. dat
case. XT_LANG do.
  toJXlist dat
case. XT_SYM do.
  s: <toJXval dat
case. XT_BOOL do.
  ax {. dat
case. XT_S4 do.
  throw 'XT_S4 type not yet supported'
case. XT_VECTOR do.
  toJXlist dat
case. XT_LIST do.
  toJXlist dat
case. XT_CLOS do.
  toJX dat
case. XT_SYMNAME do.
  (dat i. ALPH0) {. dat
case. XT_LIST_NOTAG do.
  toJXlist dat
case. XT_LIST_TAG do.
  tag2sym toJXlist dat
case. XT_LANG_NOTAG do.
  toJXlist dat
case. XT_LANG_TAG do.
  tag2sym toJXlist dat
case. XT_VECTOR_EXP do.
  toJXlist dat
case. XT_VECTOR_STR do.
  toJXlist dat
case. XT_ARRAY_INT do.
  _2 ic dat
case. XT_ARRAY_DOUBLE do.
  _2 fc toNAJ dat
case. XT_ARRAY_STR do.
  (dat=ALPH0) <;._2 dat
case. XT_ARRAY_BOOL_UA do.
  ax dat
case. XT_ARRAY_BOOL do.
  (_2 ic 4 {.dat) $ ax 4 }. dat
case. XT_RAW do.
  len=. _2 ic 4 {. dat
  len {. 4 }. dat
case. XT_ARRAY_CPLX do.
  _2 j. /\ _2 fc toNAJ dat
case. XT_UNKNOWN do.
  typ=. (INTNUM i. {. _2 ic dat) pick INTNAM
  'Type unsupported by socket interface: ',typ
case. do.
  throw 'unknown extended type: ',":typ
end.
)

NB. unused types from V0.4:
NB. case. XT_INT do.
NB.    _2 ic dat
NB. case. XT_DOUBLE do.
NB.   _2 fc toNAJ dat

NB. =========================================================
toNAJ=: 3 : 0
d=. _8 [\ y
if. -. NAR e. d do. y return. end.
,NAJ (I. NAR -:"1 d) } d
)


NB. tor
NB.
NB. convert J data to R

NB. =========================================================
NB. to R as bytestream
toRb=: 3 : 0
(DT_BYTESTREAM{a.),(3 {. 2 ic #y),y
)

NB. =========================================================
NB. to R as int
toRi=: 3 : 0
(DT_INT{a.),(3 {. 2 ic len),2 ic y
)

NB. =========================================================
NB. to R as string
toRs=: 3 : 0
dat=. y,ALPH0
len=. 4 roundup cnt=. #dat
(DT_STRING{a.),(3 {. 2 ic len),dat,(len-cnt)#ALPH0
)

NB. =========================================================
NB. to R as SEXP
toRx=: 3 : 'DT_SEXP wraplen toRx1 y'

NB. =========================================================
toRx1=: 3 : 0
if. 1 < #$y do.
  throw 'data should be scalar or vector'
end.
if. L. y do.
  throw 'boxed not yet' return.
end.
typ=. 3!:0 y
select. typ
case. 1 do.
  XT_ARRAY_BOOL wraplen 2 ic y
case. 2 do.
  dat=. y,ALPH0
  len=. 4 roundup cnt=. #dat
  (XT_STR{a.), (3 {. 2 ic cnt), dat,(len-cnt)#ALPH0
case. 4 do.
  XT_ARRAY_INT wraplen 2 ic y
case. 8 do.
  XT_ARRAY_DOUBLE wraplen 2 fc y
case. 16 do.
  throw 'complex data not supported by Rserve'
case. do.
  throw 'datatype ',(":typ),' not supported by Rserve'
end.
)


NB. zfns
NB.
NB. interactive cover functions, defined by makezfns,
NB. e.g. Rcmd calls cmd in prdsock instance locale

NB. =========================================================
ZFNS1=: 0 : 0
close
cmd
cmdr
get
)

NB. =========================================================
ZFNS2=: 0 : 0
set
)

NB. =========================================================
makemonad=: 4 : 0
t=. '''rc res''=. ',(y),'_',(x),'_ y'
('R',y,'_z_')=: 3 : (t;'if. rc do. rc;res else. res end.')
EMPTY
)

NB. =========================================================
makedyad=: 4 : 0
t=. '''rc res''=. x ',(y),'_',(x),'_ y'
('R',y,'_z_')=: 4 : (t;'if. rc do. rc;res else. res end.')
EMPTY
)

NB. =========================================================
makezfns=: 3 : 0
loc=. > coname''
loc&makemonad ;._2 ZFNS1
loc&makedyad ;._2 ZFNS2
EMPTY
)

