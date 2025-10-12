module "vpc" {
  source          = "./modules/vpc"
  project_tags    = var.project_tags
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "eks" {
  source             = "./modules/eks"
  cluster_version    = var.cluster_version
  cluster_name       = var.cluster_name
  aws_region         = var.aws_region
  project_tags       = var.project_tags
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnet_ids
  private_subnets    = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}
