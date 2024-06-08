.PHONY: run

# ssh -o "StrictHostKeyChecking no" ansible@192.168.178.112
# Dont forget to run export ANSIBLE_VAULT_PASSWORD_FILE=$(pwd)/ansible/secrets.txt
# $ENV:ANSIBLE_VAULT_PASSWORD_FILE=$($(pwd).Path)\ansible/secrets.txt

check:
	ansible-playbook --inventory inventory.yaml playbook/homelab.yaml --check --diff

run:
	ansible-playbook --inventory inventory.yaml playbook/homelab.yaml --diff

backup:
	ansible-playbook --inventory inventory.yaml playbook/homelab.yaml --diff --start-at-task="backups"