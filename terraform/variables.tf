variable "argocd_chart_version" {
  type        = string
  description = "ArgoCD Helm chart version (from argoproj/argo-helm)."
  default     = "9.7.1"
}

variable "github_repo_url" {
  type        = string
  description = "HTTPS URL of this repository; used by the root ArgoCD Application."
  # Replace with your fork URL before applying
  default = "https://github.com/<GITHUB_USER>/sovereign-ai-platform.git"
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig file. Defaults to the standard k3s location."
  default     = "~/.kube/config"
}
