.PHONY: add_helm_repo unpack

### ArgoCD
REPO := argo-cd
CHARTVER := 6.2.0

### ArgoCD-Apps
REPOAPPS := argocd-apps
CHARTVERAPPS := 1.6.1

### Repo Specific
REPONAME := argo
REPOURL := https://argoproj.github.io/argo-helm
update_repo := helm repo update
add_helm_repo := helm repo add $(REPONAME) $(REPOURL)
NAMESPACE := argocd
VALUE := -f values.yaml -f secrets.yaml

ifndef ENV
	$(error ENV is undefined)
endif
ifeq ($(ENV),dev)
VALUES := $(VALUE) -f values.dev.yaml -f secrets.dev.yaml
endif
ifeq ($(ENV),prod)
VALUES := $(VALUE) -f values.prod.yaml -f secrets.prod.yaml
endif

add_helm_repo:
	$(add_helm_repo)
	$(update_repo)

unpack := rm -rf charts/$(REPO) && helm pull $(REPONAME)/$(REPO) --version $(CHARTVER) --untar=true --untardir=charts

unpackApps := rm -rf charts/$(REPOAPPS) && helm pull $(REPONAME)/$(REPOAPPS) --version $(CHARTVERAPPS) --untar=true --untardir=charts

.PHONY: unpack unpack_argo unpack_apps

unpack_argo:
	$(update_repo)
	rm -rf ./charts/argo-cd
	$(unpack)

unpack_apps:
	$(update_repo)
	rm -rf ./charts/argocd-app
	$(unpackApps)

unpack:
	$(unpack_argo)

include ../build.mk