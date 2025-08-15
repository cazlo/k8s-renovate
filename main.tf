# Main terraform configuration file
# This is a placeholder for project-wide configurations

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4"
    }
  }
}

# This is a placeholder for any shared resources or modules that apply across environments
# For actual deployments, navigate to the environments/[dev|stage|prod] directories
