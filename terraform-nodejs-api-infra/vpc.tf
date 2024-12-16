##########################################################################
# AWS EKS Cluster
##########################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  map_public_ip_on_launch = true
  enable_nat_gateway      = true

  public_subnet_tags = {
    key                 = "kubernetes.io/role/elb"
    value               = "1"
    propagate_at_launch = true
  }

  private_subnet_tags = {
    key                 = "kubernetes.io/role/internal-elb"
    value               = "1"
    propagate_at_launch = true
  }
}
