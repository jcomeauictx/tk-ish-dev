DEBUG ?= 1
export DEBUG
all:
	$(MAKE) -C src/tk8.6.10/unix
abuild:
	$@ -K
