variable "kubeconfig_path" {
  description = "Percorso del kubeconfig di k3s"
  type        = string
  default     = "~/.kube/config"
}

variable "argocd_chart_version" {
  description = "Versione del chart Helm di ArgoCD"
  type        = string
  default     = "7.6.12"
}

variable "git_repo_url" {
  description = "URL del repo Git tracciato da ArgoCD (root app)"
  type        = string
}
