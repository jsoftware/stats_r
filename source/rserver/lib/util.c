/* util.c */

#include <assert.h>
#include "base.h"

// ---------------------------------------------------------------------
I alen(A a)
{
// *INDENT-OFF*
  I p;
	switch (a->t) {
  case 1 :
  case 2 : return 40 + 8 * (a->r + a->c/8);
  case 4 :
  case 8 : return 32 + 8 * (a->r + a->c);
  case 16 : return 32 + 8 * (a->r + 2 * a->c);
  case 32 :
	  p=a->s[a->r+a->c-1];
		if (p==0) return 40;
	  return p + alen((A)(p + (char*)a));
	default : return 0;
  }
// *INDENT-ON*
}

// ---------------------------------------------------------------------
// malloc A structure
A mallocA(I len)
{
  A r=(A)malloc(len);
  r->f=227;
  return r;
}

// ---------------------------------------------------------------------
// malloc boxed list
A mallocB(I len, I count)
{
  A r=(A)mallocA(len);
  r->t=32;
  r->c=count;
  r->r=1;
  r->s[0]=count;
  return r;
}

// ---------------------------------------------------------------------
I errormsg(int num, char *msg)
{
  if (rc==0) {
    rc=num;
    errmsg=msg;
  }
  return 0;
}

// ---------------------------------------------------------------------
// link attributes and values into 1x1x2 array, free all arguments
A jattval(A s, A t)
{
  A r=mallocB(72+alen(s)+alen(t),2);
  r->r=3;
  r->s[0]=1;
  r->s[1]=1;
  r->s[2]=2;
  r->s[3]=72;
  r->s[4]=72+alen(s);
  memcpy((char*)r+r->s[3],s,alen(s));
  memcpy((char*)r+r->s[4],t,alen(t));
  free(s);
  free(t);
  return r;
}

// ---------------------------------------------------------------------
// A from bool vector
A jboolv(I len, char *s)
{
  int wid=40+8*(1+len/8);
  A r=mallocA(wid);
  r->t=1;
  r->c=len;
  r->r=1;
  r->s[0]=len;
  memcpy((char *)(r->s+1),s,len);
  return r;
}

// ---------------------------------------------------------------------
// create boxed list of A, free all arguments
A jboxlist(A *s, I len)
{
  I w, p=40+8*len;
  DO(len,p+=alen(s[i]));
  A r=mallocB(p,len);
  p=40+8*len;
  DO(len,
     r->s[i+1]=p;
     w=alen(s[i]);
     memcpy((char*)r+p,(char*)s[i],w);
     p+=w;
     free(s[i]););
  free(s);
  return r;
}

// ---------------------------------------------------------------------
// A from complex vector
A jcomplexv(I len, double *s)
{
  A r=jdoublev(len*2,s);
  r->t=16;
  r->c=len;
  r->s[0]=len;
  return r;
}

// ---------------------------------------------------------------------
// A from double scalar
A jdouble(double s)
{
  I wid=40;
  A r=mallocA(wid);
  r->t=8;
  r->c=1;
  r->r=0;
  ((double*)r->s)[0]=s;
  return r;
}

// ---------------------------------------------------------------------
// A from double vector
A jdoublev(I len, double *s)
{
  I wid=40+8*len;
  A r=mallocA(wid);
  r->t=8;
  r->c=len;
  r->r=1;
  r->s[0]=len;
  double *p=(double*)r->s+1;
  DO(len,p[i]=s[i]);
  return r;
}

// ---------------------------------------------------------------------
// empty A
A jempty()
{
  A r=mallocA(40);
  r->t=2;
  r->c=0;
  r->r=0;
  r->s[0]=0;
  return r;
}

// ---------------------------------------------------------------------
// A from integer scalar
A jint(I s)
{
  I wid=40;
  A r=mallocA(wid);
  r->t=4;
  r->c=1;
  r->r=0;
  r->s[0]=s;
  return r;
}

// ---------------------------------------------------------------------
// A from int vector
A jintv(I len, int *s)
{
  I wid=40+8*len;
  A r=mallocA(wid);
  r->t=4;
  r->c=len;
  r->r=1;
  r->s[0]=len;
  DO(len,r->s[i+1]=s[i]);
  return r;
}

// ---------------------------------------------------------------------
// join A to existing boxed list, free all arguments
A jjoin1(A s, A t)
{
  I p=8+alen(s);
  I q=40+8*s->c;
  A r=mallocB(p+alen(t),s->c+1);
  DO(s->c,r->s[1+i]=s->s[1+i]+8);
  r->s[s->c+1]=p;
  memcpy((char*)r+8+q,(char*)s+q,alen(s)-q);
  memcpy((char*)r+r->s[s->c+1],t,alen(t));
  free(s);
  free(t);
  return r;
}

// ---------------------------------------------------------------------
// join two A to existing boxed list, free all arguments
A jjoin2(A s, A t, A u)
{
  I p=16+alen(s);
  I q=40+8*s->c;
  A r=mallocB(p+alen(t)+alen(u),s->c+2);
  DO(s->c,r->s[1+i]=s->s[1+i]+16);
  r->s[s->c+1]=p;
  r->s[s->c+2]=p+alen(t);
  memcpy((char*)r+16+q,(char*)s+q,alen(s)-q);
  memcpy((char*)r+r->s[s->c+1],t,alen(t));
  memcpy((char*)r+r->s[s->c+2],u,alen(u));
  free(s);
  free(t);
  free(u);
  return r;
}

// ---------------------------------------------------------------------
// J NA is -infinity
double jna(double s)
{
  return ISNA(s) ? R_NegInf : s;
}

// ---------------------------------------------------------------------
// A from character string
A jstring(char *s)
{
  I len=strlen(s);
  I wid=40+8*(1+len/8);
  A r=mallocA(wid);
  r->t=2;
  r->c=len;
  r->r=1;
  r->s[0]=len;
  strcpy((char *)(r->s+1),s);
  return r;
}

// ---------------------------------------------------------------------
char *type2name(int type)
{
// *INDENT-OFF*
  switch (type) {
  case ANYSXP : return "any";
  case BUILTINSXP : return "builtin";
  case CHARSXP : return "char";
  case CLOSXP : return "closure";
  case CPLXSXP : return "complex";
  case DOTSXP : return "...";
  case ENVSXP : return "environment";
  case EXPRSXP : return "expression";
  case INTSXP : return "integer";
  case LANGSXP : return "language";
  case LGLSXP : return "logical";
  case LISTSXP : return "pairlist";
  case NILSXP : return "NULL";
  case PROMSXP : return "promise";
  case REALSXP : return "double";
  case SPECIALSXP : return "special";
  case STRSXP : return "character";
  case SYMSXP : return "symbol";
  case VECSXP : return "vector";
	default : return "unknown";
  }
// *INDENT-ON*
}
