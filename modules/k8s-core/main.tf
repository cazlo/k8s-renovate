# EKS Blueprints Add-ons Module
# This module sets up core Kubernetes add-ons using the AWS EKS Blueprints add-ons module

locals {
  eks_addon_tags = {
    "terraform-aws-eks-blueprints" = "k8s-core"
  }
}

# EKS Blueprints Add-ons
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  # EKS Add-ons
  eks_addons = {
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  # AWS EFS CSI Driver
  enable_aws_efs_csi_driver = true
  aws_efs_csi_driver = {
    namespace          = "kube-system"
    create_namespace   = false
    values             = [file("${path.module}/helm-values/aws-efs-csi-driver-values.yaml")]
    set                = []
    set_sensitive      = []
  }

  # AWS Secrets Store CSI Driver
  enable_secrets_store_csi_driver = true
  enable_secrets_store_csi_driver_provider_aws = true
  secrets_store_csi_driver = {
    namespace        = "kube-system"
    create_namespace = false
  }
  secrets_store_csi_driver_provider_aws = {
    namespace        = "kube-system"
    create_namespace = false
  }

  # AWS Load Balancer Controller
  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    namespace        = "kube-system"
    create_namespace = false
    chart_version    = "1.4.8"  # Specify the chart version
    values           = [file("${path.module}/helm-values/aws-load-balancer-controller-values.yaml")]
  }

  # Metrics Server
  enable_metrics_server = true
  metrics_server = {
    namespace        = "kube-system"
    create_namespace = false
    values           = [file("${path.module}/helm-values/metrics-server-values.yaml")]
  }

  # Cluster Autoscaler
  enable_cluster_autoscaler = true
  cluster_autoscaler = {
    namespace        = "kube-system"
    create_namespace = false
    chart_version    = "9.25.0"  # Specify the chart version
    values           = [file("${path.module}/helm-values/cluster-autoscaler-values.yaml")]
  }

  tags = var.tags
}
