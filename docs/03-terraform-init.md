# 03 — Terraform (OpenTofu) Init and Apply

OpenTofu provisions the ArgoCD namespace, the platform namespace (with PSA
labels), the ArgoCD Helm release, and the root ArgoCD Application CRD.

## Create the Backend Config

The backend credentials are kept out of Git in a local `backend.hcl` file.

```bash
cat > terraform/backend.hcl <<'EOF'
bucket                      = "tfstate"
key                         = "sovereign-ai-platform/terraform.tfstate"
region                      = "us-east-1"
endpoint                    = "http://<MINIO_CLUSTER_IP>:9000"
access_key                  = "<MINIO_ROOT_USER>"
secret_key                  = "<MINIO_ROOT_PASSWORD>"
force_path_style            = true
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_region_validation      = true
use_path_style              = true
EOF
```

Replace `<MINIO_CLUSTER_IP>` with the output from the previous step.
`backend.hcl` is gitignored — never commit it.

## Copy and Edit tfvars

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars — at minimum set github_repo_url to your fork
```

`terraform.tfvars` is also gitignored.

## Initialize and Apply

```bash
cd terraform
tofu init -backend-config=backend.hcl
tofu plan
tofu apply
```

Expected resources created:

| Resource | Description |
|---|---|
| `kubernetes_namespace.argocd` | ArgoCD namespace (PSA warn) |
| `kubernetes_namespace.platform` | Platform namespace (PSA enforce restricted) |
| `helm_release.argocd` | ArgoCD installed via Helm chart 9.7.1 |
| `kubernetes_manifest.root_app` | Root ArgoCD Application (app-of-apps) |

`tofu apply` waits up to 10 minutes for ArgoCD pods to become Ready before
creating the root Application CRD.

## Verify

```bash
kubectl -n argocd get pods
# All pods should show 1/1 or 2/2 Running

kubectl -n argocd get application root-app
# NAME       SYNC STATUS   HEALTH STATUS
# root-app   Synced        Healthy
```

Proceed to [04 — ArgoCD GitOps](04-argocd-gitops.md).
