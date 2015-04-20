NB. defs
NB.
NB. api source:
NB. http://svn.rforge.net/Rserve/trunk/src/Rsrv.h

NB. following is NA returned by R, this is
NB. returned as the NA value (default __)
NAR=: (162 7 0 0 0 0 240 127,:162 7 0 0 0 0 248 127) { a.
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
NB. special types
XP_VEC=: _2147483648  NB. 1+i. list

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

XT_VECTOR=: 16        NB. data: [?]SEXP
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
XT_ARRAY_BOOL_UA=: 35 NB. data: [n]byte,byte,..  (unaligned! NOT supported anymore)
XT_ARRAY_BOOL=: 36    NB. data: int(n),byte,byte,...
XT_RAW=: 37           NB. P data: int(n),byte,byte,...
XT_ARRAY_CPLX=: 38    NB. P data: [n*16]double,double,... (Re,Im,Re,Im,...)

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
80 session is still busy
81 unable to detach session
)

ERRMSG=: 3 }. each j
ERRNUM=: 0 ". &> 2 {. each j
