resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "platform" {
  metadata {
    name = "platform"
    labels = {
      # Pod Security Admission: vieta workload privilegiati nel namespace applicativo
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}
