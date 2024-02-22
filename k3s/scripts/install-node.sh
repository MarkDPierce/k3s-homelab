#!/bin/bash

TOKEN=''

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.178.40:6443 K3S_TOKEN=$TOKEN sh -