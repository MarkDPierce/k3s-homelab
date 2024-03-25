#!/bin/bash

mkdir -p /etc/rancher/k3s

cp kubelet.config /etc/rancher/k3s
cp registries.yaml /etc/rancher/k3s

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -s - \
	--disable servicelb \
	--disable traefik

cat /etc/rancher/k3s/k3s.yaml
cat /var/lib/rancher/k3s/server/node-token