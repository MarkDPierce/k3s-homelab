REPO := traefik
REPONAME := $(REPO)
CHARTVER := 26.1.0
REPOURL := https://traefik.github.io/charts
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
