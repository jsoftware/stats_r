/* j2r.c */

#include "base.h"

static void dimR(SEXP r, A s);

static SEXP set_bool(A s);
static SEXP set_char(A s);
static SEXP set_integer(A s);
static SEXP set_numeric(A s);
static SEXP set_notyet(A s);

// ---------------------------------------------------------------------
SEXP j2sexp(A s)
{
// *INDENT-OFF*
  switch (s->t) {
  case 1 : return set_bool(s);
  case 2 : return set_char(s);
  case 4 : return set_integer(s);
  case 8 : return set_numeric(s);
 	default: return set_notyet(s);
  }
// *INDENT-ON*
}

// ---------------------------------------------------------------------
SEXP set_bool(A s)
{
  SEXP r;
  int len=s->c;
  char *p=(char*)(s->s+s->r);
  PROTECT(r = NEW_LOGICAL(len));
  DO(len,LOGICAL_POINTER(r)[i] = p[i]);
  dimR(r, s);
  UNPROTECT(1);
  return r;
}

// ---------------------------------------------------------------------
SEXP set_char(A s)
{
  return string2sexp((char*)(s->s+s->r));
}

// ---------------------------------------------------------------------
// set integer if possible, otherwise double
SEXP set_integer(A s)
{
  SEXP r;
  int len=s->c;
  I max=0;
  I *p=(I*)(s->s+s->r);
  DO(len,max=MAX(max,llabs(p[i])));
  if (max>2147483647)
    return set_numeric(s);
  PROTECT(r = NEW_INTEGER(len));
  DO(len,INTEGER_POINTER(r)[i] = (int) p[i]);
  dimR(r, s);
  UNPROTECT(1);
  return r;
}

// ---------------------------------------------------------------------
SEXP set_numeric(A s)
{
  SEXP r;
  int len=s->c;
  double *p=(double*)(s->s+s->r);
  PROTECT(r = NEW_NUMERIC(len));
  DO(len,NUMERIC_POINTER(r)[i] = p[i]);
  dimR(r, s);
  UNPROTECT(1);
  return r;
}

// ---------------------------------------------------------------------
SEXP set_notyet(A s)
{
  return (SEXP) errormsg(ETYPE,"set not yet supported");
}

// ---------------------------------------------------------------------
int set_ok(A s)
{
  return (16 > s->t) && !((2==s->t) && 1<s->r);
}

// ---------------------------------------------------------------------
void dimR(SEXP r, A s)
{
  if (2>s->r) return;
  SEXP d;
  PROTECT(d = NEW_INTEGER(s->r));
  DO(s->r,INTEGER_POINTER(d)[i] = (int) s->s[i]);
  SET_DIM(r,d);
  UNPROTECT(1);
}

// ---------------------------------------------------------------------
SEXP string2sexp(char *s)
{
  SEXP r;
  int i, len=strlen(s);
  char *buffer=strdup(s);
  PROTECT(r = allocVector(STRSXP, 1));
  SET_STRING_ELT(r, 0, mkChar(buffer));
  free(buffer);
  UNPROTECT(1);
  return r;
}
