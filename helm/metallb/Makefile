NS := metallb
CHARTVERSION := 0.13.12
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull $(NS)/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add metallb https://metallb.github.io/metallb
	helm repo update

include ../build.mk
