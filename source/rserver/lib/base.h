#ifndef RSVR_H
#define RSVR_H

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <R.h>
#include <Rdefines.h>
#include <Rembedded.h>

#ifndef WIN32
#define CSTACK_DEFNS
#include <Rinterface.h>
#endif

#include <R_ext/Parse.h>
#include "error.h"

#define DO(n,x)	{I i=0,_i=(n);for(;i<_i;++i){x;}}
#define MAX(a,b) ((a) > (b) ? a : b)

typedef void* J;
typedef long long I;
// array rep: flag, type, count, rank, shape ...
typedef struct AREP {I f;I t;I c;I r;I s[1];} *A;

A jattval(A,A);
A jboolv(I, char*);
A jboxlist(A *s, I len);
A jcomplexv(I, double*);
A jdouble(double s);
A jdoublev(I, double*);
A jempty();
A jint(I s);
A jintv(I, int*);
A jjoin1(A,A);
A jjoin2(A,A,A);
A jstring(char *);

A mallocB(I, I);
A sexp2J(SEXP);

SEXP j2sexp(A s);
SEXP string2sexp(char *);

I alen(A);
I errormsg(int rc, char *msg);
double jna(double s);
int set_ok(A s);
char* type2name(Sint);

extern int rc;
extern char *errmsg;

#endif
