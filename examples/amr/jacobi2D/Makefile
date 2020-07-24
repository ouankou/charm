
CHARMDIR=../../..
CHARMC=$(CHARMDIR)/bin/charmc $(OPTS)
AMRLIB=$(CHARMDIR)/lib/libamr.a
FLAGS=-fopenmp -lgomp -lpthread -foffload=nvptx-none -fno-stack-protector -flto -L/usr/lib/gcc/x86_64-linux-gnu/10

DEST=jacobi.out
OBJS=jacobi2DAMR.o

all: $(DEST)

$(DEST): $(OBJS)
	$(CHARMC) $(FLAGS) -lm -language charm++ -o $(DEST) $(OBJS) $(AMRLIB)
	chmod 755 $(DEST)

jacobi2DAMR.o: jacobi2DAMR.C jacobi2DAMR.decl.h jacobi2DAMR.def.h
	$(CHARMC) $(FLAGS) -g -c jacobi2DAMR.C

jacobi2DAMR.decl.h jacobi2DAMR.def.h: jacobi2DAMR.ci
	$(CHARMC) jacobi2DAMR.ci

clean:
	rm -f *.o *~ *.de*.h $(DEST) conv-host charmrun













































































































