NS := external-dns
CHARTVERSION := 1.13.1
VALUES := -f values.yaml

.PHONY: unpack
unpack:
	rm -rf charts
	helm pull $(NS)/$(NS) --version $(CHARTVERSION) --untar=true --untardir charts

.PHONY: add_helm_repo
add_helm_repo:
	helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
	helm repo update

include ../build.mk