PROGRAM=dt

GSC_LDFLAGS?=

LDFLAGS += $(GSC_LDFLAGS)

.PHONY: $(PROGRAM)
$(PROGRAM):
	gsc -ld-options $(LDFLAGS) -exe $@ -o dt

clean:
	rm -f *.{c,o*} $(PROGRAM)
