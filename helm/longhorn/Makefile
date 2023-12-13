NS := longhorn-system
CHARTVERSION := 1.5.2
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull longhorn/longhorn --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add longhorn https://charts.longhorn.io
	helm repo update

include ../build.mk
