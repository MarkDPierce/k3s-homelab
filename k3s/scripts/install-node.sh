#!/bin/bash
mkdir -p /etc/rancher/k3s

cp kubelet.config /etc/rancher/k3s
cp registries.yaml /etc/rancher/k3s

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.178.40:6443 K3S_TOKEN=YOUR_TOKEN sh -