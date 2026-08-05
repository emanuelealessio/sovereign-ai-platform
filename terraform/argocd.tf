# ArgoCD installato via Helm. Dopo questo, sarà ArgoCD (non Terraform)
# a gestire il deploy continuo dei workload via GitOps.
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  # Lab-only: console senza TLS. In produzione TLS termina all'ingress.
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
