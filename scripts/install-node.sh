#!/bin/bash

curl -sfL https://get.k3s.io | K3S_URL=https://<HOST>:6443 K3S_TOKEN=<TOKEN> sh -
