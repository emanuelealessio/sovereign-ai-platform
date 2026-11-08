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
      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = var.pss_version
    }
  }
}
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      # Pod Security Admission: non necessari root e permessi privileged per jenkins 
      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = var.pss_version
    }
  }
}
resource "kubernetes_namespace" "ci_agents" {
  metadata {
    name = "ci-agents"
    labels = {
      # Pod Security Admission: kaniko per costruire l'immagine ha bisogno di root nel container ma non privileged cioè accesso all'host
      "pod-security.kubernetes.io/enforce"         = "baseline"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/enforce-version" = var.pss_version
      "pod-security.kubernetes.io/warn-version"    = var.pss_version
    }
  }
}

