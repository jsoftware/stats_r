
# del librserver.dll
rm -f librserver.dll
# gcc -I. -I"c:/Program Files/R/R-3.3.2/include" -L. -lR -shared -Wl,--export-all-symbols -Wl,--enable-auto-import base.c util.c j2r.c r2j.c -o librserver.dll
x86_64-w64-mingw32-gcc -I. -I"$R_HOME/include" -L. -lR -shared -Wl,--export-all-symbols -Wl,--enable-auto-import base.c util.c j2r.c r2j.c -o librserver.dll
