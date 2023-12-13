# This file need some love and attention.
# It was a drop in before I had argoCD working
# Mostly for back and forth testing and learning kubectl apply commands
# I should have used kubectl update in most places (shrug)
# I am leaving this for historical reason for now after getting Argocd working

.PHONY: template template_crds test test_crds namespace del_namespace nuke_it deploy deploy_crds debug deploy_serverside

ifndef ENV
	$(error ENV is undefined)
endif

ifeq ($(ENV),dev)
CTX := --context k3s-devlab
endif
ifeq ($(ENV),prod)
CTX := --context k3s-homelab
endif

TPL_CRDS := helm secrets template --create-namespace $(NS) --include-crds $(VALUES) ./ -n $(NS)
TPL := helm secrets template --create-namespace $(NS) $(VALUES) ./ -n $(NS)

APPLY := kubectl apply $(CTX) --namespace $(NS) --validate='strict' -f -
APPLY_SERVER_SIDE := kubectl apply $(CTX) --server-side --validate='strict' --force-conflicts -f -

RMNS := kubectl delete namespace $(NS) $(CTX)
DEL := kubectl delete $(CTX) -f -
NUKE := kubectl delete -f template.yaml $(CTX) --cascade --all --now --recursive

DNS := kubectl create namespace $(NS) $(CTX)

TST  := @$(TPL) | $(APPLY) --dry-run=server
TST_CRDS  := @$(TPL_CRDS) | $(APPLY) --dry-run=server


template:
	@$(TPL) > template.yaml

template_crds:
	@$(TPL_CRDS)

test:
	@$(TST)

test_crds:
	@$(TST_CRDS)

namespace:
	-@$(DNS)

del_namespace:
	-@$(TPL) | $(DEL)
	@$(RMNS)

nuke_it:
	-@$(TPL) > template.yaml
	-@$(NUKE)
	-@$(TPL_NOCRDS) > template.yaml
	-@$(NUKE)

deploy:
	-@$(DNS)
	@$(TST)
	@$(TPL) | $(APPLY)

# Traefik will always fail the test due to the dashboard requiring CRDs. Just skip the the test and deploy twice.
deploy_crds:
	-@$(DNS)
	-@$(TST_CRDS)
	@$(TPL_CRDS) | $(APPLY)

deploy_serverside:
	-@$(DNS)
	@$(TST_CRDS)
	@$(TPL_CRDS) | $(APPLY_SERVER_SIDE)

debug:
	@echo $(ENV)
	@echo $(CTX)
	@echo $(TPL)
