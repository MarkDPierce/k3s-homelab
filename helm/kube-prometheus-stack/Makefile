# This file need some love and attention.
# It was a drop in before I had argoCD working
# Mostly for back and forth testing and learning kubectl apply commands
# I should have used kubectl update in most places (shrug)
# I am leaving this for historical reason for now after getting Argocd working

NS := kube-prometheus-stack
CHARTVERSION := 54.1.0
VALUES := -f values.yaml -f values.$(ENV).yaml -f alertmanager.yaml -f prometheus.yaml

ifeq ($(ENV),test)
CTX := --context k3s-testlab
endif
ifeq ($(ENV),dev)
CTX := --context k3s-devlab
endif
ifeq ($(ENV),prod)
CTX := --context k3s-homelab
endif

TPL_CRDS := helm template --generate-name --create-namespace $(VALUES) ./ --include-crds
TPL := helm template --generate-name --create-namespace $(VALUES) ./
APPLY_SERVER_SIDE := kubectl apply $(CTX) --server-side --validate='strict' --force-conflicts -f -
APPLY := kubectl apply $(CTX) --validate='strict' -f -
DNS := kubectl create namespace $(NS) $(CTX)
DEL := kubectl delete $(CTX) --recursive=true --now=true --force=true --grace-period=0 -f -
NUKE := kubectl delete -f template.yaml $(CTX) --cascade --all --now --recursive
TST  := @$(TPL) | $(APPLY) --dry-run=server
RMNS := kubectl delete namespace $(NS) $(CTX)

.PHONY: unpack add_helm_repo template test namespace del_namespace deploy debug first_time_deploy

unpack:
	rm -rf charts
	helm pull prometheus-community/kube-prometheus-stack --version $(CHARTVERSION) --untar=true --untardir charts

add_helm_repo:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

test:
	@$(TST)

namespace:
	-@$(DNS)

template:
	@$(TPL)

del_namespace:
	-@$(TPL) | $(DEL)
	@$(RMNS)

first_time_deploy:
	-@$(DNS)
	@$(TPL_CRDS) | $(APPLY_SERVER_SIDE)

deploy:
	-@$(DNS)
	@$(TPL) | $(APPLY)

debug:
	echo $(CTX)

#../build.mk
