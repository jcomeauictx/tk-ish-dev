DEBUG ?= 1
all:
	$(MAKE) -C src/tk8.6.10/unix
abuild:
	DEBUG=$(DEBUG) $@ -K
push:
	$(foreach remote, $(shell git remote), git push $(remote);)
