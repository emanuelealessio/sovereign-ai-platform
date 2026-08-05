output "argocd_namespace" {
  description = "Namespace in cui gira ArgoCD"
  value       = kubernetes_namespace.argocd.metadata[0].name
}
