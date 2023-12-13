NS := cert-manager
CHARTVERSION := 1.13.2
ENV := dev
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull jetstack/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update

include ../build.mk
