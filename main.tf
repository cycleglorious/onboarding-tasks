module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${var.name}-vpc"
  cidr = var.cidr_vpc

  azs             = var.availability_zones
  public_subnets  = var.cidr_public_subnets
  private_subnets = var.cidr_private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  bootstrap_self_managed_addons = true

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  enable_security_groups_for_pods = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    group1 = {
      name           = "demo-eks-node-group"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 3
      desired_size   = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}
