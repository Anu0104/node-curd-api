provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }

  required_version = "~> 1.0"
}

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }
