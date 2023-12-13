#!/bin/bash

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -s - \
	--disable servicelb \
	--disable traefik