R server for J
--------------

This is an interface to R for J64.

R should be available as a shared object, libR.so (compile R
using --enable-R-shlib, or install a package with the shared
object, e.g. Rserve).

To recompile, first copy in R.dll to this directory (use the 64-bit version),
then run makewin.bat.

Calling R
---------

When calling R, you need to set appropriate environment variables.
Required are:

  R_HOME               - R home path      (e.g. /usr/lib/R)

Optional are (depends on what calls are made to R):

  R_SHARE_DIR          - R share dir      (e.g. /usr/share/R)
  R_INCLUDE_DIR        - R include dir    (e.g. /usr/share/R/include)

Possibly required:

  LD_LIBRARY_PATH      - path to libR.so  (e.g. /usr/lib/R/lib)

Note: The interface is for J64 systems, but expects R lengths to be
their usual 4-byte integer type.
