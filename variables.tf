variable "region" {
  description = "The AWS region to deploy the infrastructure"
}
variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "azs" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "intra_subnets" {
  type = list(string)
}
variable "enable_nat_gateway" {
  type    = bool
  default = true
}
variable "single_nat_gateway" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "eks_cluster_name" {
  type = string
}
variable "kubernetes_version" {
  type    = string
  default = "1.33"
}
variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}
variable "node_ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}
variable "node_capacity_type" {
  type    = string
  default = "SPOT"
}
variable "node_min_size" {
  type    = number
  default = 2
}
variable "node_max_size" {
  type    = number
  default = 3
}
variable "node_desired_size" {
  type    = number
  default = 2
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}
