-include ../../common.mk
-include ../../../include/conv-mach-opt.mak
CHARMC = ../../../bin/charmc $(OPTS)

OBJS = vartest.o

all: vartest

vartest: vartest.o
	$(CHARMC) $(CHARMCFLAGS) -language charm++ -o vartest vartest.o

vartest.def.h: vartest.ci
	$(CHARMC) $(CHARMCFLAGS) vartest.ci

vartest.o: vartest.C vartest.def.h
	$(CHARMC) $(CHARMCFLAGS) -c vartest.C

test: vartest
	$(call run, ./vartest +p4 8 100 100)

testp: vartest
	$(call run, ./vartest +p$(P) $$(( $(P) * 10 )) 100 100)

smptest: vartest
	$(call run, ./vartest 8 100 100 +p4 ++ppn 2)
clean:
	rm -f *.o *.decl.h *.def.h vartest charmrun*
