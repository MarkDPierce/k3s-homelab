# Each Child directory needs a make file with the following added to it
# REPO := metallb
# REPONAME := $(REPO) # Sometimes the repo name is slightly different from the chart name.
# CHARTVER := 0.14.3
# REPOURL := https://metallb.github.io/metallb


.PHONY: unpack add_helm_repo template install

ifndef ENV
	$(error ENV is undefined)
endif
ifeq ($(ENV),dev)
CTX:= k3s-devlab
endif
ifeq ($(ENV),prod)
CTX := k3s-homelab
endif

update_repo := helm repo update
add_repo := helm repo add $(REPONAME) $(REPOURL)
unpack := helm pull $(REPONAME)/$(REPO) --version $(CHARTVER) --untar=true --untardir=charts

TEMPLATE := helm secrets template --include-crds --release-name --create-namespace $(NAMESPACE) $(VALUES) ./ -n $(NAMESPACE)
APPLY := kubectl apply --context=$(CTX) --validate=strict -f -
MAKE_NAMESPACE := kubectl create namespace $(NAMESPACE) --context=$(CTX)

unpack:
	$(update_repo)
	rm -rf charts
	$(unpack)

add_helm_repo:
	$(add_repo)
	$(update_repo)

template:
	@$(TEMPLATE)

install:
	-@$(MAKE_NAMESPACE)
	@$(TEMPLATE) | $(APPLY)