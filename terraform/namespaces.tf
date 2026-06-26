# Kubernetes namespaces are provisioned by Terraform (not ArgoCD) so they exist
# before ArgoCD itself is deployed and before policy enforcement begins.

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      # PSA warn-only on argocd: ArgoCD server pods require elevated permissions
      # that the restricted profile disallows; we enforce restricted only on
      # tenant namespaces.
      "pod-security.kubernetes.io/warn" = "restricted"
    }
  }
}

resource "kubernetes_namespace" "platform" {
  metadata {
    name = "platform"
    labels = {
      # Enforce PSA restricted on the application namespace — any non-compliant
      # pod is rejected at admission, not just warned.
      "pod-security.kubernetes.io/enforce" = "restricted"
      "pod-security.kubernetes.io/warn"    = "restricted"
      "pod-security.kubernetes.io/audit"   = "restricted"
    }
  }
}
