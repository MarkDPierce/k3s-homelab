REPO := heimdall
REPONAME := djjudas21
CHART := $(REPO)
CHARTVER := 8.5.2
REPOURL := 
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
