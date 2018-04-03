# Variables

NS = alt_bier
REPO = u16winevnc
NAME = u16winevnc

VERSION ?= latest
INSTANCE = default
PORTS = -p 522:22 -p 5901:5901 -p 6901:6901
VOLUMES = -v /var/log/docker:/var/log
ENV = -e SOME_KEY=SOME_VALUE

# Commands

.PHONY: help build push shell run start stop attach rm rmi release

help:
	@echo help build push shell run start stop attach rm rmi release

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

attach:
	docker attach --sig-proxy=false $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

rmi:
	docker rmi $(NS)/$(REPO)

release: build
	make push -e VERSION=$(VERSION)

default: help

