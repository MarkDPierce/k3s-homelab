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

## Secrets
Secrets are handled via SOPs.

We use the `age` feature of SOPS.

### Github

We use a repository secret for the purpose of building and shipping the images that is consumed by the github action.

`GHCR_TOKEN` Should be a PAT with artifact permissions that lives as a repository secret.

### Age

Age secrets are setup as follows.
```
mkdir secrets
age-keygen -o secrets/age-key.txt
```
`age-key.txt` Does hold private information so this is added to the `.gitignore` to prevent accidental uploads.

To include this file as a variable for future use.
`export SOPS_AGE_KEY_FILE=$(pwd)/secrets/age-key.txt`

## Helm charts
All custom and home made helm charts live in k3s/helm

## Custom Images

Argocd is a custom image because we want to include the SOPs binaries in the base image. This enables us to provide our SOPs encryption with Argocd so it can pull private repos and apply to custom clusters.


# Helm Charts

* Each application has a directory with an easy to read name.
* Each directory has at minimum a `values.yaml` file and a `Charts.yaml` file
* Upstream helm charts are cloned into the `charts` directory
    * Modification is handled in the parent folders `values.yaml`
* Environments have a 3 letter aconym to represent them
    * Environment specific attributes are located in `values.ENV.yaml` and if needed `secrets.ENV.yaml`
* Each directory has a `Makefile`
    * Initially the makefile should provide the following variables
        * REPO <this will be the helm repo>
        * REPONAME <this will be the helm repo>
        * CHARTVER <helm search repo/reponame>
        * REPOURL <The helm repo url>
        * VALUES <Environment specific values files should be handled in a condition>
        * NAMESPACE
    *  An `include ../build.mk` at the end.

# Docker Setup

You need one network created. A network meant for external network traffik like accessing the internet.

`docker network create docker-exposed`

# Docker Compose
As part of my legacy infra and for quickly testing and proto-typing apps and tools I use docker. No sense making a helm chart for something I might bin within 5 minutes. I also just use docker when im to lazy to actually put something into kubernetes.

Two networks are generally used. An exposed network to serve external traffic and provide external access. As well as a nonexposed network to provide internal container based communicate create the network stack.

## Core-Keeper
TODO

## Dashy
TODO

## FreshRSS
TODO

## Gotify
TODO

## Joplin
TODO

## Necess
TODO

## Pihole
TODO

## Traefik
TODO

## Uptime Kuma
TODO

## Valheim
A video game hosted via steam. Source repo https://github.com/lloesche/valheim-server-docker


## V-Rising
A video game hosted via steam.

Official dedicated server docs https://github.com/StunlockStudios/vrising-dedicated-server-instructions
Source Repo for Files https://github.com/TrueOsiris/docker-vrising


## Watchtower
Used to keep undefined container versions up to date.

Notifications are sent to a gotify server.