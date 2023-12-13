NS := kube-system
APP := metrics-server
CHARTVERSION := 3.11.0
VALUES := -f values.yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull $(APP)/$(APP) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add $(APP) https://kubernetes-sigs.github.io/metrics-server/
	helm repo update

include ../build.mk
