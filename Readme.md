# Homelab

## Welcome
Welcome to my homelab repo. It is still a major work in progress as of now. However I just wanted to get some of the information out there as I feel it might be valuable as I am starting this journey.

A lot of the methods you see here are similar to those we use at work so this is also a nice environment to help me work on things that might make it into my current employment space. There is something to be said about having near parady in your lab and where you implement those skills and the knowledge gained.

I'm open to feedback but dont expect me to change things for you, as this is my personal 'safe' space. A big plug to a a colleague who helps motivate me and drive me to learn and do better. I've straight ripped some concepts from him (hey its opensource) so give him a follow and check his stuff out @kvanzuijlen.

Again, everything here is just short notes, all over the place and pretty messy. Give it some time while I build the meat and potatoes. Then I'll garnish it all.

## K3s helpers
Get K3S server token to install nodes
`cat /var/lib/rancher/k3s/server/node-token`

Get Kubectl certificate
`cat /etc/rancher/k3s/k3s.yaml`

In the directory `k3s` there should be files to help configure a few aspects of the cluster if they are needed.


### Storage
You will need to install isci client

`sudo apt-get install open-iscsi`

Ensure nfs-common and util-linux are also available

`sudo apt-get install nfs-common`
`sudo apt-get install util-linux`

---
## Kubectl helpers

### Nuke a stuck namespace

```
NAMESPACE=<namespace>
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
```
Kill a proxy you forgot about
```
ps -ef | grep "kubectl proxy"
kill -9 <PID>
```
---

## ArgoCD helpers

### ArgoCD default admin

If you deploy with the default admin and need to get the password for that account

```
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Delete Dangling argocd apps
`kubectl patch app APP_NAME -p '{"metadata": {"finalizers": null}}' --type merge`
`kubectl patch crd CRD_NAME -p '{"metadata": {"finalizers": null}}' --type merge`

If you use k9s you can edit the resource and delete the finalizer or set it to null

--- 

## Github

### Repo Config

Create a deploy key for argo CD. Create private key and add the public key here

Create an actions secret for workflow image building called `GHCR_TOKEN` fill it with a pat that has package permissions

### Private Images to github

You need to provide a pat via `export CR_PAT=<TOKEN>` then you need to log into GHCR with `echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin`

## The Todo List

- [ ] Renovate
- [x] Alertmanager-discord-alerts
- [ ] Uptime-kuma Chart
- [ ] Dashy Chart
- [ ] Gotify Chart
- [ ] fritzbox-prometheus-exporter chart
- [ ] Traggo (maybe)
- [ ] Automate entire deployment
- [ ] Document more
- [ ] Actually use this todo list
- [ ] Configure branches on github
- [ ] Configure branch protection on github
- [ ] Add a bit more automation for deploying helm charts
- [ ] Finalize 'production' cluster
- [ ] Determine tools for dev cluster
- [ ] Configure Heimdall# Homelab

## Welcome
Welcome to my homelab repo. It is still a major work in progress as of now. However I just wanted to get some of the information out there as I feel it might be valuable as I am starting this journey.

A lot of the methods you see here are similar to those we use at work so this is also a nice environment to help me work on things that might make it into my current employment space. There is something to be said about having near parady in your lab and where you implement those skills and the knowledge gained.

I'm open to feedback but dont expect me to change things for you, as this is my personal 'safe' space. A big plug to a a colleague who helps motivate me and drive me to learn and do better. I've straight ripped some concepts from him (hey its opensource) so give him a follow and check his stuff out @kvanzuijlen.

Again, everything here is just short notes, all over the place and pretty messy. Give it some time while I build the meat and potatoes. Then I'll garnish it all.

## K3s helpers
Get K3S server token to install nodes
`cat /var/lib/rancher/k3s/server/node-token`

Get Kubectl certificate
`cat /etc/rancher/k3s/k3s.yaml`

In the directory `k3s` there should be files to help configure a few aspects of the cluster if they are needed.


### Storage
You will need to install isci client

`sudo apt-get install open-iscsi`

Ensure nfs-common and util-linux are also available

`sudo apt-get install nfs-common`
`sudo apt-get install util-linux`

---
## Kubectl helpers

### Nuke a stuck namespace

```
NAMESPACE=<namespace>
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
```
Kill a proxy you forgot about
```
ps -ef | grep "kubectl proxy"
kill -9 <PID>
```
---

## ArgoCD helpers

### ArgoCD default admin

If you deploy with the default admin and need to get the password for that account

```
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Delete Dangling argocd apps
`kubectl patch app APP_NAME -p '{"metadata": {"finalizers": null}}' --type merge`
`kubectl patch crd CRD_NAME -p '{"metadata": {"finalizers": null}}' --type merge`

If you use k9s you can edit the resource and delete the finalizer or set it to null

--- 

## Github

### Repo Config

Create a deploy key for argo CD. Create private key and add the public key here

Create an actions secret for workflow image building called `GHCR_TOKEN` fill it with a pat that has package permissions

### Private Images to github

You need to provide a pat via `export CR_PAT=<TOKEN>` then you need to log into GHCR with `echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin`

## The Todo List

- [ ] Renovate
- [x] Alertmanager-discord-alerts
- [ ] Uptime-kuma Chart
- [ ] Dashy Chart
- [ ] Gotify Chart
- [ ] fritzbox-prometheus-exporter chart
- [ ] Traggo (maybe)
- [ ] Automate entire deployment
- [ ] Document more
- [ ] Actually use this todo list
- [ ] Configure branches on github
- [ ] Configure branch protection on github
- [ ] Add a bit more automation for deploying helm charts
- [ ] Finalize 'production' cluster
- [ ] Determine tools for dev cluster
- [ ] Configure Heimdall