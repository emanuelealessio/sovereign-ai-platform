# 05 — Verify Policy Enforcement

This runbook demonstrates that Kyverno policies are actively enforcing
security controls in the cluster.

## 1. Confirm Policies Are Active

```bash
kubectl get clusterpolicy
# NAME                      ADMISSION   BACKGROUND   READY   AGE
# disallow-privileged       true        true         True    Xm
# require-requests-limits   true        true         True    Xm
# verify-image-signatures   false       true         True    Xm
# require-netpol            false       true         True    Xm
```

## 2. Test: Reject Privileged Pod

The following pod MUST be rejected by `disallow-privileged`:

```bash
kubectl -n platform apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod-privileged
spec:
  containers:
  - name: c
    image: cgr.dev/chainguard/nginx:1.27
    resources:
      requests:
        cpu: "10m"
        memory: "16Mi"
      limits:
        cpu: "100m"
        memory: "64Mi"
    securityContext:
      privileged: true
EOF
# Expected: Error from server: admission webhook denied the request
# Message: "Privileged containers are not allowed."
```

## 3. Test: Reject Pod Without Resource Limits

```bash
kubectl -n platform apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod-no-limits
spec:
  containers:
  - name: c
    image: cgr.dev/chainguard/nginx:1.27
EOF
# Expected: Error from server: admission webhook denied the request
# Message: "CPU and memory requests and limits are required..."
```

## 4. Test: Auto-Generated NetworkPolicy

Create a new namespace and verify Kyverno generates a default-deny NetworkPolicy:

```bash
kubectl create namespace test-netpol-verify
kubectl -n test-netpol-verify get networkpolicy
# NAME           POD-SELECTOR   AGE
# default-deny   <none>         Xs

# Clean up
kubectl delete namespace test-netpol-verify
```

## 5. Test: Compliant Workload Deploys

Before applying, replace `<CHAINGUARD_NGINX_TAG>` in `apps/platform/sample-app.yaml`
with a real tag (e.g. `1.27`), then apply:

```bash
kubectl apply -f apps/platform/
kubectl -n platform get pods
# NAME                          READY   STATUS    RESTARTS   AGE
# sample-app-<hash>             1/1     Running   0          30s
```

## 6. Check Image Signature Audit Reports

The `verify-image-signatures` policy runs in Audit mode. Check for audit
findings in the PolicyReport:

```bash
kubectl get policyreport -n platform
kubectl describe policyreport -n platform
```

## Summary

| Policy | Mode | Verified |
|---|---|---|
| disallow-privileged | Enforce | Privileged pod rejected |
| require-requests-limits | Enforce | No-limits pod rejected |
| require-netpol | Generate | NetworkPolicy auto-created |
| verify-image-signatures | Audit | Findings visible in PolicyReport |
