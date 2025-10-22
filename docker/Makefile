# allow Bashisms
SHELL := /bin/bash
# prefer /usr/bin over /usr/local/bin, especially for python3
PATH := /usr/bin:$(PATH)
HOST ?= 127.0.0.1
SSHPORT ?= 3022
IUSER := ishuser
IHOME := /home/$(IUSER)
IMAGE := alpine-ish-dev
TAG := $(IMAGE)\:latest
MOUNTPOINT := $(HOME)/mnt/docker-images
PYTHON ?= $(word 1, $(shell which python3 python false))
PYLINT ?= $(word 1, $(shell which pylint3 pylint true))
DRYRUN ?= --dry-run
VERBOSE ?=  # -vvv or left blank
SRC=rentacoder
GFG := .gitconfig
ifeq ($(SHOWENV),)
export IUSER
else
export
endif
default: bind-run
$(MOUNTPOINT)/$(TAG): Dockerfile | $(MOUNTPOINT)/README
	-docker stop $(IMAGE)
	-docker rm $(IMAGE)
	-docker rmi $(TAG)
	docker build \
	 --no-cache \
	 --platform linux/i386 \
	 --build-arg IUSER=$(IUSER) \
	 --tag $(TAG) .
$(MOUNTPOINT)/README: ../../dockerfs/dockerfs.py $(MOUNTPOINT)
	$(MAKE) $(<:.py=.pylint)
	$(PYTHON) $+
$(MOUNTPOINT): | $(HOME)
	mkdir -p $@
%.pylint: %.py
	$(PYLINT) $<
bind-run: | $(MOUNTPOINT)/$(TAG)
	docker run \
	 --name $(IMAGE) \
	 --detach \
	 --publish $(HOST):$(SSHPORT):$(SSHPORT) \
	 --mount type=bind,src=$(HOME)/$(SRC),target=$(IHOME)/$(SRC) \
	 --mount type=bind,src=$(HOME)/.ssh,target=$(IHOME)/.ssh \
	 --mount type=bind,src=$(HOME)/$(GFG),target=$(IHOME)/$(GFG) \
	 --mount type=bind,src=/usr/src,target=/usr/src \
	 --entrypoint /usr/sbin/sshd $(TAG) -D -E /var/log/sshd.log
	# -D means run sshd in foreground
	# docker run [OPTIONS] IMAGE [COMMAND] [ARG]
ssh login: | $(MOUNTPOINT)/$(TAG)
	ssh $(VERBOSE) -p $(SSHPORT) -Y \
	 -oStrictHostKeyChecking=no \
	 -oUserKnownHostsFile=/dev/null \
	 -oKexAlgorithms=+diffie-hellman-group1-sha1 \
	 -oHostKeyAlgorithms=+ssh-rsa \
	 -oPubKeyAcceptedKeyTypes=+ssh-rsa \
	 $(IUSER)@localhost
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
umount:
	fusermount -u $(MOUNTPOINT)
backup download:
	cd ../../.. && $(MAKE) $@
rerun:
	docker stop alpine-ish-dev
	docker rm alpine-ish-dev
	$(MAKE) bind-run
