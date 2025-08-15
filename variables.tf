# This file contains variables that apply to the entire project
# Environment-specific variables are defined in their respective directories

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "eks-blueprints-example"
}

variable "organization" {
  description = "Name of the organization"
  type        = string
  default     = "example-org"
}
