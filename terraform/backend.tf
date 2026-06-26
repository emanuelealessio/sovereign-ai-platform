# This file documents the backend.hcl template that must be created locally
# (and is gitignored). The actual backend block lives in versions.tf as
# `backend "s3" {}` and is populated at init time with:
#
#   tofu init -backend-config=backend.hcl
#
# backend.hcl template (copy, fill in values, DO NOT COMMIT):
#
#   bucket                      = "tfstate"
#   key                         = "sovereign-ai-platform/terraform.tfstate"
#   region                      = "us-east-1"
#   endpoint                    = "http://<MINIO_CLUSTER_IP>:9000"
#   access_key                  = "<MINIO_ROOT_USER>"
#   secret_key                  = "<MINIO_ROOT_PASSWORD>"
#   force_path_style            = true
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_region_validation      = true
#   use_path_style              = true
#
# Why MinIO as a backend:
#   S3-compatible object storage running in-cluster eliminates cloud provider
#   dependency for state while retaining locking semantics. DynamoDB-style
#   locking is skipped in this single-operator lab setup.
