variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider associated with the EKS cluster"
  type        = string
}

# Chart versions for each add-on
variable "aws_efs_csi_driver_chart_version" {
  description = "Chart version for AWS EFS CSI Driver"
  type        = string
  default     = "2.4.0"
}

variable "secrets_store_csi_driver_chart_version" {
  description = "Chart version for Secrets Store CSI Driver"
  type        = string
  default     = "1.3.3"
}

variable "secrets_store_csi_driver_provider_aws_chart_version" {
  description = "Chart version for Secrets Store CSI Driver AWS Provider"
  type        = string
  default     = "0.3.3"
}

variable "aws_load_balancer_controller_chart_version" {
  description = "Chart version for AWS Load Balancer Controller"
  type        = string
  default     = "1.4.8"
}

variable "metrics_server_chart_version" {
  description = "Chart version for Metrics Server"
  type        = string
  default     = "3.10.0"
}

variable "cluster_autoscaler_chart_version" {
  description = "Chart version for Cluster Autoscaler"
  type        = string
  default     = "9.25.0"
}

variable "tags" {
  description = "Tags to apply to resources created by this module"
  type        = map(string)
  default     = {}
}
