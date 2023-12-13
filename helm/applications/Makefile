.PHONY: dev prod

dev:
	helm template -f values.dev.yaml applications ./ | kubectl apply --cluster k3s-devlab -f -
prod:
	helm template -f values.prod.yaml applications ./ | kubectl apply --cluster k3s-homelab -f -
