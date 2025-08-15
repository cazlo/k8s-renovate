output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "config_map_aws_auth" {
  description = "The AWS auth ConfigMap for use with kubectl"
  value       = module.eks.aws_auth_configmap_yaml
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "efs_file_system_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.eks.id
}

output "k8s_core_addons" {
  description = "K8s core add-ons deployed"
  value = {
    efs_csi_driver                      = module.k8s_core.aws_efs_csi_driver
    secrets_store_csi_driver            = module.k8s_core.secrets_store_csi_driver
    secrets_store_csi_driver_provider_aws = module.k8s_core.secrets_store_csi_driver_provider_aws
    aws_load_balancer_controller        = module.k8s_core.aws_load_balancer_controller
    metrics_server                      = module.k8s_core.metrics_server
    cluster_autoscaler                  = module.k8s_core.cluster_autoscaler
  }
}

output "kubectl_config" {
  description = "kubectl config command to connect to the cluster"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}
