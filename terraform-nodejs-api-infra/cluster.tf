##########################################################################
# AWS EKS Cluster
##########################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

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
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = "${aws_iam_role.ebs_csi_driver_role.arn}"
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

resource "aws_security_group_rule" "eks_cluster" {
  security_group_id = module.eks.cluster_security_group_id
  protocol          = "-1"               # -1 means all protocols
  from_port         = 0                  # Allow all ports
  to_port           = 65535              # Allow all ports
  type              = "ingress"
  description       = "Allow all inbound traffic to the EKS cluster"
  cidr_blocks       = ["0.0.0.0/0"]      # Allow traffic from all IPs
  depends_on        = [module.eks]
}

##########################################################################
# AWS EKS EBS CSI DRIVER ROLE
##########################################################################
data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ebs_csi_driver_policy" {
  name = "AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name        = "AmazonEBSCSIDriverRole"
  description = "Amazon EKS - EBS CSI Driver role."
  path        = "/"
  assume_role_policy = jsonencode({


    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}:aud" : "sts.amazonaws.com",
            "oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
  force_detach_policies = false

  managed_policy_arns = [
    data.aws_iam_policy.ebs_csi_driver_policy.arn
  ]
}
