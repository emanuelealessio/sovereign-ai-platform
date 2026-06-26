# Installs ArgoCD via Helm and creates the root Application (app-of-apps).
# The root Application watches bootstrap/argocd/ in this repo; every file
# there is itself an ArgoCD Application definition.

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false

  # insecure=true: ArgoCD serves plain HTTP. TLS termination is handled
  # at the ingress/port-forward layer in this lab setup.
  set {
    name  = "server.insecure"
    value = "true"
  }

  # Wait until all ArgoCD pods are Ready before Terraform exits
  wait    = true
  timeout = 600
}

# Root Application: the entry point for the app-of-apps pattern.
# ArgoCD discovers and syncs every Application YAML in bootstrap/argocd/.
resource "kubernetes_manifest" "root_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-app"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.github_repo_url
        targetRevision = "HEAD"
        path           = "bootstrap/argocd"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.argocd.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=false"
        ]
      }
    }
  }

  depends_on = [helm_release.argocd]
}
