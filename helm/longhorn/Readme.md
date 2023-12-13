# Uninstalling this product
`kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.4.0/uninstall/uninstall.yaml`

I broke everything doing the wrong thing

```bash
#remove-pending-namespace.sh [pending-namespace-name]
#!/bin/bash
ns=longhorn-system
kubectl get ns ${ns} -o json > tmp.json
cat ./tmp.json | jq 'del(.spec.finalizers[])' > ./modify.json
kubectl replace --raw "/api/v1/namespaces/${ns}/finalize" -f ./modify.json
rm -f tmp.json modify.json
```
