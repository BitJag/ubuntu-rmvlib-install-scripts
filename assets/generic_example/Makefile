include	Makefile.config

PROJECT=genericExample
SRCC=genericExample.c
SRCS=
SRCH=
STRUCT_S=$(wildcard ./struct/*.s)
GFX_S=$(wildcard ./gfx/data/*.s) 
AUD_S=$(wildcard ./sound/data/*.s)
OBJS=$(SRCC:.c=.o) $(SRCS:.s=.o) $(GFX_S:.s=.o) $(STRUCT_S:.s=.o) $(AUD_S:.s=.o)
OTHEROBJS=
RMVLIBS=display.o interrupt.o sound.o rmvlib.a fb2d.o lz77.o gpudriver.o

include	Makefile.example
