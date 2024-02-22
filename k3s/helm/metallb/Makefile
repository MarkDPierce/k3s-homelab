REPO := metallb
REPONAME := $(REPO)
CHARTVER := 0.14.3
REPOURL := https://metallb.github.io/metallb
VALUE := -f values.yaml
NAMESPACE := $(REPO)

ifndef ENV
	$(error ENV is undefined)
endif
ifeq ($(ENV),dev)
VALUES := $(VALUE) -f values.dev.yaml
endif
ifeq ($(ENV),prod)
VALUES := $(VALUE) -f values.prod.yaml
endif

include ../build.mk
