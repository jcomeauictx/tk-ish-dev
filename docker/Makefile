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
MOUNTPREFIX := $(HOME)/mnt/docker
CONTAINERS := $(MOUNTPREFIX)-containers
IMAGES := $(MOUNTPREFIX)-images
PYTHON ?= $(word 1, $(shell which python3 python false))
PYLINT ?= $(word 1, $(shell which pylint3 pylint true))
DRYRUN ?= --dry-run
VERBOSE ?=  # -vvv or left blank
SRC=rentacoder
GFG := .gitconfig
rstrip = $(shell echo $1 | sed -e 's%/$$%%')
tilde = $(shell echo $1 | sed 's%^$(HOME)%$(IHOME)%')
# conditional in case we merge with parent directory
ifeq ($(notdir $(PWD)),docker)
PROJECTDIR := $(call tilde, $(call rstrip, $(dir $(PWD))))
else
PROJECTDIR := $(PWD)
endif
ifeq ($(SHOWENV),)
export IUSER PROJECTDIR
else
export
endif
default: login
$(IMAGES)/$(TAG): Dockerfile | $(IMAGES)/README
	-docker stop $(IMAGE)
	-docker rm $(IMAGE)
	-docker rmi $(TAG)
	docker build \
	 --no-cache \
	 --platform linux/i386 \
	 --build-arg IUSER=$(IUSER) \
	 --build-arg PROJECTDIR=$(PROJECTDIR) \
	 --tag $(TAG) .
$(IMAGES)/README: ../../dockerfs/dockerfs.py $(IMAGES)
	$(MAKE) $(<:.py=.pylint)
	$(MAKE) -C $(<D) install
$(CONTAINERS)/$(IMAGE): $(IMAGES)/$(TAG) | $(CONTAINERS)/README
	docker run \
	 --name $(IMAGE) \
	 --detach \
	 --publish $(HOST):$(SSHPORT):$(SSHPORT) \
	 --mount type=bind,src=$(HOME)/$(SRC),target=$(IHOME)/$(SRC) \
	 --mount type=bind,src=$(HOME)/.ssh,target=$(IHOME)/.ssh \
	 --mount type=bind,src=$(HOME)/$(GFG),target=$(IHOME)/$(GFG) \
	 --mount type=bind,src=$(HOME)/src,target=$(IHOME)/src \
	 --entrypoint /usr/sbin/sshd $(TAG) -D -E /var/log/sshd.log
	# -D means run sshd in foreground
	# docker run [OPTIONS] IMAGE [COMMAND] [ARG]
$(CONTAINERS)/README: ../../dockerfs/dockerfs.py $(CONTAINERS)
	$(MAKE) $(<:.py=.pylint)
	$(MAKE) -c $< install
$(IMAGES) $(CONTAINERS): | $(HOME)
	mkdir -p $@
%.pylint: %.py
	$(PYLINT) $<
$(HOME)/.ssh/id_alpine:
	ssh-keygen -t rsa -b 2048 -f $@
ssh login: $(CONTAINERS)/$(IMAGE) $(HOME)/.ssh/authorized_keys
	# if ~/.ssh/id_rsa is actually an ECDSA format, create id_alpine
	ssh $(VERBOSE) -p $(SSHPORT) -t -Y \
	 -i ~/.ssh/id_alpine \
	 -i ~/.ssh/id_rsa \
	 -oStrictHostKeyChecking=no \
	 -oUserKnownHostsFile=/dev/null \
	 -oKexAlgorithms=+diffie-hellman-group1-sha1 \
	 -oHostKeyAlgorithms=+ssh-rsa \
	 -oPubKeyAcceptedKeyTypes=+ssh-rsa \
	 $(IUSER)@127.0.0.1
$(HOME)/.ssh/authorized_keys: $(HOME)/.ssh/id_alpine .FORCE
	if [ -z "$$(grep $$(cat $<.pub | tr ' ' '.') $@)" ]; then \
	 cat $<.pub >> $@; \
	else \
	 echo "$< is already in $@" >&2; \
	fi
	chmod 0600 $@
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
backup download:
	cd ../../.. && $(MAKE) $@
rerun:
	-docker stop alpine-ish-dev
	-docker rm alpine-ish-dev
	$(MAKE) login
rootlogin:
	# login as root to running container to poke around
	sudo docker exec -it alpine-ish-dev /bin/bash
.FORCE:
