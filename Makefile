ABUILD ?= $(shell which abuild false)
DEBUG ?= 1
all: src/tk8.6.10/unix
	$(MAKE) -C $<
src/tk8.6.10/unix: $(HOME)/.abuild
	DEBUG=$(DEBUG) abuild -r -K
push:
	$(foreach remote, $(shell git remote), git push $(remote);)
tktest:
	echo 'label .dash -text "-"' | wish
$(HOME)/.abuild:
	abuild-keygen -an
.PHONY: all push tktest
