provider "aws" {
  region = var.region
}

locals {
  cluster_name = "eks-prod-cluster"
  environment  = "prod"

  tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "eks-blueprint-example"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.cluster_name}-vpc"
  cidr = "10.2.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets  = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = false  # Use multiple NAT gateways for high availability
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    disk_size      = 100
    instance_types = ["m5.large"]
  }

  eks_managed_node_groups = {
    general = {
      min_size     = 3
      max_size     = 10
      desired_size = 5

      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"
      labels = {
        role = "general"
      }
    }

    workloads = {
      min_size     = 2
      max_size     = 8
      desired_size = 3

      instance_types = ["c5.large"]
      capacity_type  = "ON_DEMAND"
      labels = {
        role = "workloads"
      }
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  # Create an IAM role for the EFS CSI driver
  create_iam_role = true
  iam_role_name   = "${local.cluster_name}-cluster-role"

  tags = local.tags
}

# Create an EFS filesystem for persistent storage
resource "aws_efs_file_system" "eks" {
  creation_token = "${local.cluster_name}-efs"
  encrypted      = true
  performance_mode = "generalPurpose"
  throughput_mode  = "provisioned"
  provisioned_throughput_in_mibps = 100

  tags = merge(
    local.tags,
    {
      Name = "${local.cluster_name}-efs"
    }
  )
}

# Create mount targets for the EFS filesystem
resource "aws_efs_mount_target" "eks" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}

# Security group for EFS
resource "aws_security_group" "efs" {
  name        = "${local.cluster_name}-efs-sg"
  description = "Allow EFS inbound traffic from EKS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "NFS from EKS"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [module.eks.node_security_group_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# Deploy the K8s core add-ons
module "k8s_core" {
  source = "../../modules/k8s-core"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Specify chart versions for add-ons
  aws_efs_csi_driver_chart_version                  = "2.4.0"
  secrets_store_csi_driver_chart_version            = "1.3.3"
  secrets_store_csi_driver_provider_aws_chart_version = "0.3.3"
  aws_load_balancer_controller_chart_version        = "1.4.8"
  metrics_server_chart_version                      = "3.10.0"
  cluster_autoscaler_chart_version                  = "9.25.0"

  tags = local.tags
}
