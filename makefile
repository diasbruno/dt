.DEFAULT_GOAL:=all

PROGRAM=dt

GSC_LDFLAGS?=

LDFLAGS += $(GSC_LDFLAGS)

.PHONY: $(PROGRAM)
$(PROGRAM):
	gsc -ld-options $(LDFLAGS) -exe $@ -o dt


.PHONY: all
all: $(PROGRAM)

clean:
	rm -f *.{c,o*} $(PROGRAM)
