NS := traefik
CHARTVERSION := 25.0.0
VALUES := -f values.yaml -f values.$(ENV).yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull $(NS)/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add traefik https://traefik.github.io/charts
	helm repo update

.PHONY: deploy_traefik
deploy:
	kubectl create namespace $(NS)
	helm $(values) install $(NS) $(NS)/$(NS) --namespace $(NS)

include ../build.mk
