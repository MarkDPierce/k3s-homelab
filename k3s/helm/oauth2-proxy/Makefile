REPO := oauth2-proxy
REPONAME := $(REPO)
CHARTVER := 7.1.0
REPOURL := https://oauth2-proxy.github.io/manifests
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
