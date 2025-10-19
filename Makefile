ABUILD ?= $(word 1, $(shell which abuild false))
DEBUG ?= 1
GDB ?= gdb --args
XTRACE ?= ../xtrace/xtrace -D 127.0.0.1:9
WISH ?= $(word 1, $(shell which wish false))
SRCDIR := src/tk8.6.10/unix/
FILES := $(SRCDIR)/../generic/tkFont.c $(SRCDIR)/tkUnixRFont.c
all: tktest
src/tk8.6.10/unix/libtk8.6.so: src/tk8.6.10/unix
	$(MAKE) -C $<
src/tk8.6.10/unix: $(HOME)/.abuild
	DEBUG=$(DEBUG) abuild -r -K
push:
	$(foreach remote, $(shell git remote), git push $(remote);)
tktest: /usr/lib/libtk8.6.so
	$(GDB) $(WISH) ./segfault.wish
$(HOME)/.abuild:
	abuild-keygen -an
/usr/lib/%.so: src/tk8.6.10/unix/%.so
	if [ ! -f $@.orig ]; then sudo cp $@ $@.orig; fi
	sudo cp -i $< $@
edit:
	vi $(FILES)
.PHONY: all push tktest edit
