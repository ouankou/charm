-include ../../common.mk
CHARMC=../../../bin/charmc $(OPTS)

OBJS = taskSpawn.o

all: taskSpawn

taskSpawn: $(OBJS)
	$(CHARMC) -language charm++ -o taskSpawn $(OBJS)

taskSpawn.decl.h: taskSpawn.ci
	$(CHARMC)  taskSpawn.ci

clean:
	rm -f *.decl.h *.def.h *.o taskSpawn charmrun

taskSpawn.o: taskSpawn.C taskSpawn.decl.h
	$(CHARMC) -c taskSpawn.C

test: all
	$(call run, ./taskSpawn +p4 50000 100 )

testp: all
	$(call run, ./taskSpawn +p$(P) $$(( $(P) * 50000)) 100)
