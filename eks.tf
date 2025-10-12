module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.eks_cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access = var.endpoint_public_access

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  eks_managed_node_groups = {
    example = {
      ami_type                      = var.node_ami_type
      instance_types                = [var.node_instance_type]
      capacity_type                 = var.node_capacity_type
      min_size                      = var.node_min_size
      max_size                      = var.node_max_size
      desired_size                  = var.node_desired_size
      attach_primary_security_group = true
    }
  }



  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
