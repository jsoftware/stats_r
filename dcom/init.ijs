NB. init

coclass 'prdcom'
NB. init

NB. =========================================================
create=: 3 : 0
makezfns''
wd 'pc jdcom'
HWNDP=: wd 'qhwndp'
wd 'cc w oleautomation:StatConnectorSrv.StatConnector.1'
wd 'olemethod w base Init "R"'
wd 'olemethod w base EvaluateNoReturn *',RDEF_exec
)

NB. =========================================================
destroy=: 3 : 0
wd ::] 'psel jdcom;pclose'
codestroy''
)

