/* base.c */

#include "base.h"

// ---------------------------------------------------------------------
int rclose(int);
int rcmd(char *);
int rget(char *x, A *r);
int ropen(int);
int rset(char *, A);

// ---------------------------------------------------------------------
// error globals used in conversions:
int rc=0;
char *errmsg;

static void clear();
static int rexec(int type, char *x, A *res);
static int ROPEN=0;
static void *result=NULL;

char* str = "string";
int x = 10;

// ---------------------------------------------------------------------
void clear()
{
  rc=0;
  free(errmsg);
  errmsg=NULL;
  free(result);
  result=NULL;
}

// ---------------------------------------------------------------------
int rclose(int x)
{
  if (ROPEN == 1) {
    R_RunExitFinalizers();
    R_CleanTempDir();
    Rf_KillAllDevices();
#ifndef WIN32
    fpu_setup(FALSE);
#endif
    Rf_endEmbeddedR(1);
  }
  ROPEN=0;
  return 0;
}

// ---------------------------------------------------------------------
int rcmd(char *s)
{
  clear();
  int r=rexec(0,s,(A*)0);
  if (r==0) r=rc;
  return r;
}

// ---------------------------------------------------------------------
int rexec(int type, char *s, A *res)
{
  if (ROPEN == 0) ropen(0);
  SEXP e, p, r, xp;
  if (type) *res=0;
  int error;
  ParseStatus status;
  PROTECT(e=string2sexp(s));
  PROTECT(p=R_ParseVector(e, 1, &status, R_NilValue));
  if (status != 1) {
    UNPROTECT(2);
    return EEXEC+status; // parse errors
  }
  PROTECT(xp=VECTOR_ELT(p, 0));
  r=R_tryEval(xp, R_GlobalEnv, &error);
  UNPROTECT(3);
  if (error) return EEXEC+1;  // eval error
  if (type) *res=sexp2J(r);
  return 0;
}

// ---------------------------------------------------------------------
int rget(char *s, A *v)
{
  clear();
  int r=rexec(1,s,v);
  if (rc && r==0) {
    r=rc;
    free(*v);
    *v=jstring(errmsg);
  }
  result=(void*)*v;
  return r;
}

// ---------------------------------------------------------------------
int ropen(int n)
{
  if (ROPEN == 1) return 0;
  int s,mode=0;
  char *argv[] = {"R","--slave"};
  s=Rf_initEmbeddedR(2, argv);
  if (s<0) return ENOCONN;
  if(1==n)R_CStackLimit = (uintptr_t)-1;
  ROPEN=1;
  return 0;
}

// ---------------------------------------------------------------------
int rset(char *name, A y)
{
  clear();
  if (ROPEN == 0) ropen(0);
  ParseStatus status;
  SEXP txt, sym, val;
// check value can be converted
  if (!set_ok(y))
    return EVALUE;
// check name is valid
  PROTECT(txt=allocVector(STRSXP, 1));
  SET_STRING_ELT(txt, 0, mkChar(name));
  PROTECT(sym = R_ParseVector(txt, 1, &status,R_NilValue));
  if (status != 1) {
    UNPROTECT(2);
    return ENAME;
  }
  const char *c = CHAR(PRINTNAME(VECTOR_ELT(sym,0)));
  PROTECT(val = j2sexp(y));
  if (rc==0)
    defineVar(install(c),val,R_GlobalEnv);
  UNPROTECT(3);
  return rc;
}

