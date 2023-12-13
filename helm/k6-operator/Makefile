NS := k6-operator
CHARTVERSION := 2.0.0
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull grafana/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

include ../build.mk
