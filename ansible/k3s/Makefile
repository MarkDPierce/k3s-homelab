.PHONY: run

run:
	ansible-playbook playbook/site.yaml -i inventory.yaml -u ansible --diff

prod:
	ansible-playbook --inventory inventory.yaml playbook/picluster.yaml -u ansible --diff

reset:
	ansible-playbook playbook/reset.yaml -i inventory.yaml -u ansible --diff

reboot:
	ansible-playbook playbook/reboot.yaml -i inventory.yaml -u ansible --diff

upgrade: 
	ansible-playbook playbook/upgrade.yaml -i inventory.yaml -u ansible --diff