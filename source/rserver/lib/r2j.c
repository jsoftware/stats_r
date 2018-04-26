/* r2j.c */

#include "base.h"

static A attR(A r, SEXP s);

static A get_char(SEXP);
static A get_character(SEXP);
static A get_closure(SEXP);
static A get_complex(SEXP);
static A get_dot(SEXP);
static A get_double(SEXP);
static A get_environment(SEXP);
static A get_integer(SEXP);
static A get_language(SEXP);
static A get_logical(SEXP);
static A get_name(SEXP);
static A get_notyet(SEXP);
static A get_null(SEXP);
static A get_numeric(SEXP);
static A get_pairlist(SEXP);
static A get_promise(SEXP);
static A get_sexp(SEXP);
static A get_symbol(SEXP);
static A get_tick(SEXP s);
static A get_vector(SEXP);

// ---------------------------------------------------------------------
A sexp2J(SEXP s)
{
  int type = TYPEOF(s);
//~printf("sexp2J for %s\n",type2name(type));
// *INDENT-OFF*
  switch (type) {
  case CHARSXP : return get_char(s);
  case CLOSXP : return get_closure(s);
  case CPLXSXP : return get_complex(s);
  case DOTSXP : return get_dot(s);
  case ENVSXP : return get_environment(s);
  case EXPRSXP : return get_sexp(s);
  case INTSXP : return get_integer(s);
  case LANGSXP : return get_language(s);
  case LGLSXP : return get_logical(s);
  case LISTSXP : return get_pairlist(s);
  case NILSXP : return get_null(s);
  case PROMSXP : return get_promise(s);
  case REALSXP : return get_double(s);
  case STRSXP : return get_character(s);
  case SYMSXP : return get_symbol(s);
  case VECSXP : return get_vector(s);
	default: return get_notyet(s);
  }
// *INDENT-ON*
}

// ---------------------------------------------------------------------
A get_notyet(SEXP s)
{
  char *t=type2name(TYPEOF(s));
  char *v=malloc(10+strlen(t));
  strcpy(v,"not yet: ");
  strcat(v,t);
  return (A) errormsg(ETYPE,v);
}

// ---------------------------------------------------------------------
A get_char(SEXP s)
{
  A r=jstring((char*) CHAR(STRING_ELT(s,0)));
  return attR(r,s);
}

// ---------------------------------------------------------------------
// single string or list of strings
A get_character(SEXP s)
{
  A r,t;
  I i, p, w, len = LENGTH(s);
  if (len == 1)
    r=jstring((char*) CHAR(STRING_ELT(s,0)));
  else {
    p=40+48*len;;
    DO(len,p+=8*(1+strlen((char*) CHAR(STRING_ELT(s,i)))/8));
    r=mallocB(p,len);
    p=40+8*len;
    DO(len,
       r->s[i+1]=p;
       t=jstring((char*) CHAR(STRING_ELT(s,i)));
       w=alen(t);
       memcpy((char*)r+p,t,w);
       p+=w;
       free(t););
  }
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_closure(SEXP s)
{
  A t = sexp2J(FORMALS(s));
  A v = sexp2J(BODY(s));
  return attR(jattval(t,v),s);
}

// ---------------------------------------------------------------------
A get_complex(SEXP s)
{
  A r;
  int len = LENGTH(s);
  double *v = malloc((2*len)*sizeof(double));
  DO(len,
     v[i*2]=  jna(COMPLEX(s)[i].r);
     v[i*2+1]=jna(COMPLEX(s)[i].i););
  r = jcomplexv(len,v);
  free(v);
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_dot(SEXP s)
{
  return attR(jstring("pairlist"),s);
}

// ---------------------------------------------------------------------
A get_double(SEXP s)
{
  A r;
  int len = LENGTH(s);
  double *v = malloc(len*sizeof(double));
  DO(len,v[i]=jna(REAL(s)[i]););
  r = jdoublev(len,v);
  free(v);
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_environment(SEXP s)
{
  return attR(jstring("environment"),s);
}

// ---------------------------------------------------------------------
A get_integer(SEXP s)
{
  A r;
  int len = LENGTH(s);
  int *v = malloc(len*sizeof(int));
  DO(len,v[i]=INTEGER_POINTER(s)[i]);
  r = jintv(len,v);
  free(v);
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_language(SEXP s)
{
  int i,len = length(s);
  A r=jempty();
  SEXP t=s;
  while (length(t)) {
    r=jjoin1(r,sexp2J(CAR(t)));
    t=CDR(t);
  }
  return attR(r,s);
}

// ---------------------------------------------------------------------
// set boolean if possible, otherwise integer
A get_logical(SEXP s)
{
  A r;
  int len = LENGTH(s);
  int ifint=0;
  DO(len,
     ifint=NA_LOGICAL==(LOGICAL_POINTER(s)[i]);
     if (ifint) break;);
  if (ifint) {
    int *v = malloc(len*sizeof(int));
    DO(len,v[i]=LOGICAL_POINTER(s)[i];
       if (v[i]!=0 && v[i]!=1) v[i]=2;);
    r = jintv(len,v);
    free(v);
  } else {
    char *v = malloc(len);
    DO(len,v[i]=LOGICAL_POINTER(s)[i];);
    r = jboolv(len,v);
    free(v);
  }
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_name(SEXP s)
{
  return attR(jstring("name"),s);
}

// ---------------------------------------------------------------------
A get_null(SEXP s)
{
  return attR(jstring("NULL"),s);
}

// ---------------------------------------------------------------------
A get_numeric(SEXP s)
{
  return attR(jstring("numeric"),s);
}

// ---------------------------------------------------------------------
A get_pairlist(SEXP s)
{
  A r=jempty();
  A t;
  SEXP p=s;
  while (length(p)) {
    if (SYMSXP==TYPEOF(TAG(p)))
      t=get_tick(TAG(p));
    else
      t=sexp2J(TAG(p));
    r=jjoin2(r,sexp2J(CAR(p)),t);
    p=CDR(p);
  }
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_promise(SEXP s)
{
  return attR(jstring("promise"),s);
}

// ---------------------------------------------------------------------
A get_sexp(SEXP s)
{
  return attR(jstring("dot"),s);
}

// ---------------------------------------------------------------------
A get_symbol(SEXP s)
{
  A r=jstring((char*) CHAR(CAR(s)));
  return attR(r,s);
}

// ---------------------------------------------------------------------
// variant of get_symbol with initial back tick
A get_tick(SEXP s)
{
  const char *t=CHAR(CAR(s));
  char *v=malloc(2+strlen(t));
  v[0]='`';
  strcpy(v+1,t);
  A r=jstring(v);
  free(v);
  return attR(r,s);
}

// ---------------------------------------------------------------------
A get_vector(SEXP s)
{
  int i, len = LENGTH(s);
  A *p=malloc(len * sizeof(A*));
  DO(len,p[i]=sexp2J(VECTOR_ELT(s,i)));
  A r=jboxlist(p,len);
  return attR(r,s);
}

// ---------------------------------------------------------------------
A attR(A r, SEXP s)
{
  SEXP a=ATTRIB(s);
  if (isNull(a)) return r;
  return jattval(sexp2J(a),r);
}
