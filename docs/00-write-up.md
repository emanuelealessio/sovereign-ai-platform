# CV Write-Up: Sovereign AI Platform — Infrastructure Layer

## One-Liner (for CV bullet)

> Designed and implemented a production-grade Kubernetes GitOps platform on k3s
> with policy-as-code (Kyverno), IaC state in self-hosted MinIO, ArgoCD
> app-of-apps, and a full CI security pipeline (Trivy, Checkov, Conftest).

## Extended Bullet Points (for detailed CV section)

- **GitOps with ArgoCD**: Implemented app-of-apps pattern to manage cluster
  workloads declaratively from Git; zero manual `kubectl apply` after bootstrap.

- **Policy-as-Code with Kyverno**: Authored four ClusterPolicies covering
  privilege escalation prevention, resource quota enforcement, network policy
  auto-generation, and supply-chain image verification (Cosign keyless).

- **Pod Security Admission**: Applied Kubernetes PSA `restricted` profile to
  application namespaces, eliminating an entire class of privilege-escalation
  attack vectors.

- **Self-hosted Terraform State**: Configured OpenTofu with an S3-compatible
  MinIO backend running in-cluster; eliminated cloud provider dependency for
  state management.

- **CI Security Pipeline**: Built GitHub Actions workflows running kubeconform
  (manifest validation), Trivy (config scan), Checkov (IaC static analysis),
  Kyverno CLI (policy dry-run), and Conftest (OPA policy gates).

- **Zero-cost Enterprise Replication**: Entire stack runs on a single 12 GB RAM
  Linux Mint workstation, demonstrating ability to architect production controls
  without cloud spend.

## Competencies Demonstrated

| Area | Evidence |
|---|---|
| Kubernetes | Namespaces, PSA, NetworkPolicy, CRDs (Application, ClusterPolicy) |
| GitOps | ArgoCD app-of-apps, reconciliation loop, declarative desired state |
| Policy Engineering | Kyverno validate + generate + verifyImages rule types |
| IaC | OpenTofu (Terraform-compatible) with remote S3 backend |
| Supply Chain Security | Image pinning, Cosign keyless verification, Sigstore |
| CI/CD | Multi-job GitHub Actions with security scan gates |
| Documentation | Runbook-driven; reproducible from scratch by any reader |
