#################################CREATE SOPS LAYER#############################
FROM alpine:3.19.1 AS binaries
ARG TARGETOS
ARG TARGETARCH

ENV SOPS_VERSION=v3.8.1
RUN wget https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.${TARGETOS}.${TARGETARCH} -O /tmp/sops && chmod +x /tmp/sops
###########################Create ArgoCD Layer#################################
FROM quay.io/argoproj/argocd:v2.10.1@sha256:5f1de1b4d959868c1e006e08d46361c8f019d9730e74bc1feeab8c7b413f1187
ENV HELM_SECRETS_VERSION=v4.5.1

# Install SOPS binary from previous layer
COPY --from=binaries /tmp/sops /usr/local/bin/sops

# Helm plugins need to be installed by the correct user
# USER argocd = 999, needs to be numeric to run argocd-notifications with 'workAsNonRootUser'
USER 999
# Set env so plugins can be found
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
# Install plugins
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}
