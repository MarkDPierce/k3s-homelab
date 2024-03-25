REGISTRY       := ghcr.io/markdpierce/privatelab
REGISTRY_CACHE := ghcr.io/markdpierce/privatelab-cache

ifeq ($(IMAGE),)
	IMAGE :=  $(shell grep "FROM" Dockerfile | tail -1 | cut -d' ' -f2 | sed -r 's|([a-z0-9]+\.)?[a-z]+\.[a-z]+/||' | cut -d':' -f1 | xargs)
endif

ifeq ($(VERSION),)
	VERSION := $(shell grep "FROM" Dockerfile | tail -1 | cut -d':' -f2 | cut -d'@' -f1 | xargs)
endif

ifeq ($(PLATFORM),)
	PLATFORM := linux/amd64,linux/arm64
endif

BUILDX      := docker buildx build -t $(REGISTRY)/$(IMAGE):$(VERSION) --platform $(PLATFORM) --provenance=false --cache-to=type=registry,ref=$(REGISTRY_CACHE)/$(IMAGE) --cache-from=type=registry,ref=$(REGISTRY_CACHE)/$(IMAGE) .
BUILDX_PUSH := $(BUILDX) --push

.PHONY: build
build:
	$(BUILDX)

.PHONY: push
push:
	$(BUILDX_PUSH)
