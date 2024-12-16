
# ##########################################################################
# # AWS EKS LoadBalancer Role
# ##########################################################################

# resource "aws_iam_policy" "load_balancer_controller_policy" {
#   name        = "AWSLoadBalancerControllerIAMPolicy"
#   path        = "/"
#   description = "My AWSLoadBalancerControllerIAMPolicy policy"

#   policy = file("policy/aws_load_balancer_controller_policy.json")
#   depends_on = [ module.eks ]
# }

# resource "aws_iam_role" "load_balancer_controller_role" {
#   name        = "LoadBalancerControllerRole"
#   description = "Amazon EKS - Load Balancer Controller role."
#   path        = "/"
#   assume_role_policy = jsonencode({


#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}"
#         },
#         Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#           StringEquals = {
#             "oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}:aud" : "sts.amazonaws.com",
#             "oidc.eks.${var.region}.amazonaws.com/id/${split("/", module.eks.cluster_oidc_issuer_url)[4]}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }
#       }
#     ]
#   })

#   force_detach_policies = false
#   managed_policy_arns = [
#     aws_iam_policy.load_balancer_controller_policy.arn
#   ]
#   depends_on = [ aws_iam_policy.load_balancer_controller_policy ]
# }

# resource "kubernetes_service_account" "service-account" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     labels = {
#       "app.kubernetes.io/name"      = "aws-load-balancer-controller"
#       "app.kubernetes.io/component" = "controller"
#     }
#     annotations = {
#       "eks.amazonaws.com/role-arn"               = aws_iam_role.load_balancer_controller_role.arn
#       "eks.amazonaws.com/sts-regional-endpoints" = "true"
#     }
#   }
#   depends_on = [ aws_iam_role.load_balancer_controller_role ]
# }

# # terraform/helm-load-balancer-controller.tf

# resource "helm_release" "aws_load_balancer_controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.5.0"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
#     value = "node_pool"
#   }

#   set {
#     name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
#     value = "In"
#   }

#   set {
#     name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
#     value = "load-balancer-controller"
#   }
#   depends_on = [kubernetes_service_account.service-account]
# }
