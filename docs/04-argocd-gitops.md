# 04 — ArgoCD GitOps: App-of-Apps

The root ArgoCD Application (created by Terraform) watches `bootstrap/argocd/`
in this repository. Every YAML file in that directory is itself an ArgoCD
Application — this is the app-of-apps pattern.

```
root-app (Terraform)
  └── bootstrap/argocd/
        ├── kyverno.yaml        → installs Kyverno via Helm
        ├── policies.yaml       → deploys policies/kyverno/ ClusterPolicies
        └── platform-apps.yaml  → deploys apps/platform/ workloads
```

## Update bootstrap/argocd/*.yaml Before Syncing

Replace `<GITHUB_USER>` in `bootstrap/argocd/policies.yaml` and
`bootstrap/argocd/platform-apps.yaml` with your actual GitHub username (or
organisation), then push to the `main` branch.

## Access the ArgoCD Console

```bash
# Port-forward the ArgoCD server (running in insecure/HTTP mode)
kubectl -n argocd port-forward svc/argocd-server 8080:80
```

Open `http://localhost:8080`.

Initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d && echo
```

Login: username `admin`, password from above.

## Install the ArgoCD CLI (optional)

```bash
curl -sSL -o /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

argocd login localhost:8080 --username admin --password <PASSWORD> --insecure
```

## Trigger a Full Sync

```bash
argocd app sync root-app --prune
```

ArgoCD recurses through the app-of-apps and syncs all child apps. You can also
trigger this from the console UI.

## GitOps Workflow

```
Git push → GitHub → ArgoCD polls (default 3 min) → reconcile → cluster state
```

To force an immediate resync of all apps:

```bash
argocd app sync --all
```

Proceed to [05 — Verify Policies](05-verify-policies.md).
