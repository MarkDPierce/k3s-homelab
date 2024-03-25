REPO := kube-prometheus-stack
REPONAME := prometheus-community
CHARTVER := 57.1.0
REPOURL := https://prometheus-community.github.io/helm-charts
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
