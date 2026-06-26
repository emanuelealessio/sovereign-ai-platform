# Pin all provider versions to ensure reproducibility. The backend block is
# intentionally empty — credentials and endpoint are supplied via backend.hcl
# (gitignored) at `tofu init` time.

terraform {
  required_version = ">= 1.6"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      # Using a conservative ~> 2.33 constraint; the 3.x provider is available
      # but introduces breaking changes to resource_prefix behaviour.
      version = "~> 2.33"
    }
    helm = {
      source = "hashicorp/helm"
      # 2.x uses the Helm SDK (not the Helm v4 binary), avoiding v4 issues.
      version = "~> 2.15"
    }
  }

  backend "s3" {}
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}
