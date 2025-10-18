ABUILD ?= $(shell which abuild false)
DEBUG ?= 1
all: tktest
src/tk8.6.10/unix/libtk8.6.so: src/tk8.6.10/unix
	$(MAKE) -C $<
src/tk8.6.10/unix: $(HOME)/.abuild
	DEBUG=$(DEBUG) abuild -r -K
push:
	$(foreach remote, $(shell git remote), git push $(remote);)
tktest: /usr/lib/libtk8.6.so
	echo 'label .dash -text "-"' | wish
$(HOME)/.abuild:
	abuild-keygen -an
/usr/lib/%.so: src/tk8.6.10/unix/%.so
	if [ ! -f $@.orig ]; then sudo cp $@ $@.orig; fi
	sudo cp -i $< $@
.PHONY: all push tktest
