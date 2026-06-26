# 02 — MinIO Bootstrap

MinIO provides the S3-compatible backend for OpenTofu (Terraform) remote state.
It runs inside the k3s cluster itself, eliminating any cloud provider dependency.

## Before Applying

Edit `bootstrap/minio.yaml` and replace the placeholder values:

| Placeholder | Replace With |
|---|---|
| `<MINIO_ROOT_USER>` | A username string (e.g. `minioadmin`) |
| `<MINIO_ROOT_PASSWORD>` | A strong password (min 8 chars) |
| `<MINIO_IMAGE_TAG>` | A specific MinIO image tag from [quay.io/minio/minio](https://quay.io/repository/minio/minio?tab=tags) (e.g. `RELEASE.2024-10-13T13-34-11Z`) |

> **Do not commit real credentials.** The Secret uses `stringData` placeholders
> intentionally. Replace locally, never push the filled-in file.

## Apply the Manifests

```bash
kubectl apply -f bootstrap/minio.yaml
```

## Verify MinIO is Running

```bash
kubectl -n minio get pods
# NAME                     READY   STATUS    RESTARTS   AGE
# minio-<hash>             1/1     Running   0          60s

kubectl -n minio get svc
# NAME    TYPE        CLUSTER-IP    PORT(S)             AGE
# minio   ClusterIP   10.X.X.X      9000/TCP,9001/TCP   60s
```

## Create the State Bucket

Port-forward to access the MinIO console:

```bash
kubectl -n minio port-forward svc/minio 9001:9001 &
```

Open `http://localhost:9001`, log in with your credentials, and create a bucket
named **`tfstate`**.

Alternatively with the `mc` CLI:

```bash
mc alias set local http://localhost:9000 <MINIO_ROOT_USER> <MINIO_ROOT_PASSWORD>
mc mb local/tfstate
mc ls local/
# [DATE]  0 B  tfstate/
```

## Get the Cluster IP for Terraform

Note the MinIO ClusterIP — you will need it for `backend.hcl`:

```bash
kubectl -n minio get svc minio -o jsonpath='{.spec.clusterIP}'
```

Proceed to [03 — Terraform Init](03-terraform-init.md).
