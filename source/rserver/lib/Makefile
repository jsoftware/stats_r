# linux/osx rserver makefile

UNAME=$(shell uname -s)

ifeq ($(UNAME),Darwin)
 ifeq ($(R_HOME),)
 R_HOME=/Library/Frameworks/R.framework/Resources
 endif
 R_SHARE=$(R_HOME)
	CFLAGS=-O -fPIC -dynamiclib -undefined dynamic_lookup
	TGT=librserver.dylib
else
 ifeq ($(R_HOME),)
	R_HOME=/usr/lib/R
 endif
 R_SHARE=$(R_HOME)
	CFLAGS=-O -fPIC -shared
	TGT=librserver.so
endif

CC=gcc
RCMD=$(R_HOME)/bin/R CMD
INCLUDES=-I. -I$(R_SHARE)/include
LIBS=-L$(R_HOME)/lib -lR

SRC=$(wildcard *.c)

all:
	$(RCMD) $(CC) $(CFLAGS) $(INCLUDES) $(SRC) $(LIBS) -o $(TGT)

clean:
	rm -rf *.o *.so *.dylib
