NS := heimdall
CHARTVERSION := 8.5.2
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull djjudas21/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add djjudas21 https://djjudas21.github.io/charts/
	helm repo update

include ../build.mk
