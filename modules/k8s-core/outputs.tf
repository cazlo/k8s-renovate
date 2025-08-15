output "eks_addons" {
  description = "Map of EKS add-ons deployed by this module"
  value       = module.eks_blueprints_addons.eks_addons
}

output "aws_efs_csi_driver" {
  description = "Map of AWS EFS CSI Driver add-on attributes"
  value       = module.eks_blueprints_addons.aws_efs_csi_driver
}

output "secrets_store_csi_driver" {
  description = "Map of Secrets Store CSI Driver add-on attributes"
  value       = module.eks_blueprints_addons.secrets_store_csi_driver
}

output "secrets_store_csi_driver_provider_aws" {
  description = "Map of Secrets Store CSI Driver AWS Provider add-on attributes"
  value       = module.eks_blueprints_addons.secrets_store_csi_driver_provider_aws
}

output "aws_load_balancer_controller" {
  description = "Map of AWS Load Balancer Controller add-on attributes"
  value       = module.eks_blueprints_addons.aws_load_balancer_controller
}

output "metrics_server" {
  description = "Map of Metrics Server add-on attributes"
  value       = module.eks_blueprints_addons.metrics_server
}

output "cluster_autoscaler" {
  description = "Map of Cluster Autoscaler add-on attributes"
  value       = module.eks_blueprints_addons.cluster_autoscaler
}
