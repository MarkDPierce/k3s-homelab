REPO := longhorn
REPONAME := $(REPO)
CHARTVER := 1.6.0
REPOURL := https://charts.longhorn.io
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
