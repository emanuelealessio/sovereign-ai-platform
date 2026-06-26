# 01 — Cluster Setup: k3s + kubectl + OpenTofu

## Prerequisites

- Linux Mint (or any Debian-based distro)
- 12 GB RAM recommended; 8 GB minimum
- `curl` installed

## Install k3s

```bash
# Disable Traefik — ingress is handled separately (or not needed in this lab)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
```

k3s writes a kubeconfig to `/etc/rancher/k3s/k3s.yaml`. Export it:

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```

## Verify the Node

```bash
kubectl get nodes
# NAME        STATUS   ROLES                  AGE   VERSION
# <hostname>  Ready    control-plane,master   Xm    vX.Y.Z+k3s1
```

k3s ships its own `kubectl` symlinked at `/usr/local/bin/kubectl`.

## Install OpenTofu

```bash
curl -Lo /tmp/tofu.tar.gz \
  https://github.com/opentofu/opentofu/releases/download/v1.12.2/tofu_1.12.2_linux_amd64.tar.gz
tar -xzf /tmp/tofu.tar.gz -C /tmp tofu
sudo mv /tmp/tofu /usr/local/bin/tofu
tofu version
# OpenTofu v1.12.2
```

## Install kubeconform

```bash
curl -Lo /tmp/kubeconform.tar.gz \
  https://github.com/yannh/kubeconform/releases/download/v0.7.0/kubeconform-linux-amd64.tar.gz
tar -xzf /tmp/kubeconform.tar.gz -C /tmp kubeconform
sudo mv /tmp/kubeconform /usr/local/bin/kubeconform
kubeconform -v
# v0.7.0
```

## (Optional) Install Helm

ArgoCD and Kyverno are deployed via Helm through Terraform/OpenTofu, so the
`helm` CLI is not strictly required for the bootstrap. Install it if you want
to inspect chart releases directly:

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Proceed to [02 — MinIO Bootstrap](02-minio-bootstrap.md).
