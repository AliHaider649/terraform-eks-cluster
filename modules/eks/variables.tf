variable "cluster_name" { type = string }
variable "aws_region" { type = string }
variable "project_tags" { type = map(string) }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "node_instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "min_capacity" { type = number }
variable "max_capacity" { type = number }
variable "cluster_version" { 
    type = string
    default = "1.33"
}
