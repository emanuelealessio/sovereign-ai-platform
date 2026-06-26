# Sovereign AI Platform — GitOps Infrastructure

Production-grade Kubernetes GitOps lab running on a single-node k3s cluster,
replicating enterprise security controls (policy enforcement, image verification,
network isolation, IaC state management) at zero cloud cost.

> Layer 1 of a multi-layer Sovereign AI Platform portfolio project.
> Designed to demonstrate senior DevOps / Platform Engineer competencies.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Linux Mint PC (12 GB RAM)                │
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │    k3s       │    │    MinIO     │    │    OpenTofu      │  │
│  │  (1-node)    │    │  (S3 state)  │    │  (IaC engine)    │  │
│  └──────┬───────┘    └──────────────┘    └──────────────────┘  │
│         │                                                       │
│  ┌──────▼───────────────────────────────────────────────────┐  │
│  │                    Kubernetes Cluster                     │  │
│  │                                                           │  │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐  │  │
│  │  │   ArgoCD    │  │   Kyverno    │  │  platform ns   │  │  │
│  │  │ (GitOps CD) │  │ (Policy Eng) │  │ (sample-app)   │  │  │
│  │  └─────────────┘  └──────────────┘  └────────────────┘  │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │        NetworkPolicy (default-deny + allow-DNS)      │ │  │
│  │  └─────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                            │
                     ┌──────▼──────┐
                     │   GitHub    │
                     │  (GitOps    │
                     │   source)   │
                     └─────────────┘
```

---

## Stack

| Component | Role | Version |
|---|---|---|
| k3s | Kubernetes distribution | latest stable |
| OpenTofu | Infrastructure as Code | 1.12.2 |
| ArgoCD | GitOps continuous delivery | chart 9.7.1 |
| Kyverno | Policy engine (admission + generate) | chart 3.8.1 |
| MinIO | S3-compatible Terraform state backend | quay.io/minio/minio |
| kubeconform | Kubernetes manifest validation | v0.7.0 |
| Trivy | Container / IaC security scanning | latest |
| Checkov | Static analysis for Terraform & K8s | latest |

---

## Security Controls

- **Pod Security Admission** — `restricted` profile enforced on the `platform` namespace
- **Kyverno: disallow-privileged** — Enforced; rejects any pod requesting privileged containers
- **Kyverno: require-resources** — Enforced; every container must declare CPU/memory requests and limits
- **Kyverno: require-netpol** — Generates a default-deny NetworkPolicy automatically for every new namespace
- **Kyverno: verify-image-signatures** — Audit mode; Cosign keyless verification for `ghcr.io/<GITHUB_USER>/*`
- **NetworkPolicy** — Explicit default-deny + allow-DNS in the `platform` namespace
- **No secrets in Git** — All credentials injected via gitignored files or Kubernetes Secrets
- **Image pinning** — No `:latest` tags; all images use explicit version tags or digests

---

## Quick Start

```bash
# 1. Bootstrap MinIO (Terraform state backend)
kubectl apply -f bootstrap/minio.yaml

# 2. Provision ArgoCD + namespaces via OpenTofu
cd terraform && tofu init -backend-config=backend.hcl && tofu apply

# 3. Sync GitOps apps
kubectl -n argocd get application
```

---

## How to Reproduce

Follow the numbered runbooks in order:

1. [Cluster Setup](docs/01-cluster-setup.md) — k3s + kubectl + OpenTofu
2. [MinIO Bootstrap](docs/02-minio-bootstrap.md) — local S3 state backend
3. [Terraform Init](docs/03-terraform-init.md) — IaC provisioning
4. [ArgoCD GitOps](docs/04-argocd-gitops.md) — app-of-apps pattern
5. [Verify Policies](docs/05-verify-policies.md) — enforcement demo

---

## Project Context

This repository is **Layer 1** of the Sovereign AI Platform:

- **Layer 1** (this repo) — GitOps infrastructure: namespaces, policies, networking
- **Layer 2** (planned) — ML workload deployment: GPU scheduling, model serving (vLLM + Qdrant)
- **Layer 3** (planned) — Runtime security: Falco, mTLS mesh, NIS2 compliance mapping

---

*Reproducible on any single-node k3s cluster. No cloud account required.*
