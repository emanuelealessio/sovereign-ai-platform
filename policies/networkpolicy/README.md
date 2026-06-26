# Network Policies

This directory contains the baseline NetworkPolicies for the `platform` namespace.

## Files

| File | Purpose |
|---|---|
| `platform-default-deny.yaml` | Denies all ingress and egress by default |
| `platform-allow-dns.yaml` | Permits egress to port 53 (UDP/TCP) for DNS |

## How It Works

NetworkPolicies are additive: `platform-default-deny` sets the baseline (deny
everything), and each subsequent policy opens specific traffic paths.

The `require-netpol` Kyverno ClusterPolicy automatically generates a
`default-deny` NetworkPolicy in **every new namespace** at creation time — not
just `platform`. The files here are the static counterparts applied via ArgoCD.

## Adding Application-Specific Rules

For each workload that needs to communicate across namespace boundaries, add a
targeted NetworkPolicy in this directory (or in `apps/platform/`). Example:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-sample-app-ingress
  namespace: platform
spec:
  podSelector:
    matchLabels:
      app: sample-app
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: ingress-nginx
```
