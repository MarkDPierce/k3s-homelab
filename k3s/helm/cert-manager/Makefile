REPO := cert-manager
REPONAME := jetstack
CHARTVER := 1.14.4
REPOURL := https://charts.jetstack.io
VALUE := -f values.yaml -f secrets.yaml
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
