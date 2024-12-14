##########################################################################
# AWS EKS Cluster
##########################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  eks_managed_node_groups = {
    nodejs-api = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      labels = {
        node_pool = "nodejs-api"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypted             = true
            volume_size           = "20"
            volume_type           = "gp3"
          }
        }
      }
    },
    controller = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      labels = {
        node_pool = "load-balancer-controller"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypted             = true
            volume_size           = "20"
            volume_type           = "gp3"
          }
        }
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }
  depends_on = [module.vpc]
}

# module "allow_eks_access_iam_policy" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.3.1"

#   name          = "allow-eks-access"
#   create_policy = true

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "eks:DescribeCluster",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# module "eks_admins_iam_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.3.1"

#   role_name         = "eks-admin"
#   create_role       = true
#   role_requires_mfa = false

#   custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]

#   trusted_role_arns = [
#     "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
#   ]
# }

# module "eks_iam_user" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-user"
#   version = "5.3.1"

#   name                          = "eks-user"
#   create_iam_access_key         = false
#   create_iam_user_login_profile = false

#   force_destroy = true
# }

# module "allow_assume_eks_admins_iam_policy" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.3.1"

#   name          = "allow-assume-eks-admin-iam-role"
#   create_policy = true

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#         ]
#         Effect   = "Allow"
#         Resource = module.eks_admins_iam_role.iam_role_arn
#       },
#     ]
#   })
# }

# module "eks_admins_iam_group" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.3.1"

#   name                              = "eks-admin"
#   attach_iam_self_management_policy = false
#   create_group                      = true
#   group_users                       = [ module.eks_iam_user.iam_user_name ]
#   custom_group_policy_arns          = [module.allow_assume_eks_admins_iam_policy.arn]
# }
