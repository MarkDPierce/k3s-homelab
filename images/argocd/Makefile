REGISTRY       := ghcr.io/markdpierce/k3s-homelab
REGISTRY_CACHE := ghcr.io/markdpierce/k3s-homelab-cache

# IMAGE can be omitted, if the upstream image is hosted on Docker Hub and mirrored with the same name
ifeq ($(IMAGE),)
	IMAGE :=  $(shell grep "FROM" Dockerfile | tail -1 | cut -d' ' -f2 | sed -r 's|([a-z0-9]+\.)?[a-z]+\.[a-z]+/||' | cut -d':' -f1 | xargs)
endif

# VERSION can be omitted, if same version as the upstream image is used
ifeq ($(VERSION),)
	VERSION := $(shell grep "FROM" Dockerfile | tail -1 | cut -d':' -f2 | cut -d'@' -f1 | xargs)
endif

BUILDX      := docker buildx build -t $(REGISTRY)/$(IMAGE):$(VERSION) --platform linux/amd64,linux/arm64 --cache-to=type=registry,ref=$(REGISTRY_CACHE)/$(IMAGE) --cache-from=type=registry,ref=$(REGISTRY_CACHE)/$(IMAGE) .
BUILDX_PUSH := $(BUILDX) --push

.PHONY: build
build:
	$(BUILDX)

.PHONY: push
push:
	$(BUILDX_PUSH)
