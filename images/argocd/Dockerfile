FROM alpine:3.19.0 AS binaries
ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-releases depName=mozilla/sops versioning=loose
ENV SOPS_VERSION=v3.8.1
RUN wget https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.${TARGETOS}.${TARGETARCH} -O /tmp/sops && chmod +x /tmp/sops

########################################################################################################################
FROM quay.io/argoproj/argocd:v2.9.3@sha256:dfc13f4b9ddbf25a88f7018667ee45e35a49520e2716242e3f65ef75f88c25ff
# renovate: datasource=github-tags depName=jkroepke/helm-secrets versioning=loose
ENV HELM_SECRETS_VERSION=v4.5.1

# Install SOPS binary
COPY --from=binaries /tmp/sops /usr/local/bin/sops

# Helm plugins need to be installed by the correct user
# USER argocd = 999, needs to be numeric to run argocd-notifications with 'workAsNonRootUser'
USER 999
# Set env so plugins can be found
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
# Install plugins
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}
