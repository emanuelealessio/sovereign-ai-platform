terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket = "terraform-state"
    key    = "dev/k3s-platform.tfstate"

    endpoints = {
      s3 = "http://192.168.1.11:9000"
    }

    region = "main"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}
