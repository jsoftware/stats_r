NB. sock

DEFPORT=: 6311
RSK=: 0
MAX=: 50000
WAIT=: 20000
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
connect=: 3 : 0
if. RSK e. SOCKETS do. 1 return. end.
RSK_rserve_=: 0
'host port'=. 2 {. boxopen y
HOST=: host, (0=#host)#'localhost'
PORT=: {. port,DEFPORT
if. -. HOST -: 'localhost' do.
  HOSTIP=: 2;'127.0.0.1'
else.
  HOSTIP=: gethostip HOST
end.
RSK_rserve_=: sd_socket''
sd_connect RSK;HOSTIP,<PORT
res=. read1 RSK
if. -. 'RsrvQAP1' -: (, 0 8 +/ i.4) { res do.
  throw 'Rserve connect returns ',res
  0 return.
end.
att=. _4 [\ (12 }. res) -. '-',CRLF
NB. expect no attributes:
if. #att do.
  throw 'Rserve connect returns: ',,res,.LF
  0 return.
end.
1
)

NB. =========================================================
disconnect=: 3 : 0
if. RSK e. SOCKETS do.
  sdclose :: ] RSK
end.
RSK_jsocket_=: 0
)

NB. =========================================================
read=: 3 : 'readsk RSK'

NB. =========================================================
send=: 3 : 0
if. connect'' do.
  y sendsk RSK
end.
EMPTY
)
