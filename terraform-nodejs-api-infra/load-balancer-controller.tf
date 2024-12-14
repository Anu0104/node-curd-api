# module "aws_load_balancer_controller_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   role_name = "aws-load-balancer-controller"

#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

# resource "kubernetes_service_account" "service-account" {
#  metadata {
#      name      = "aws-load-balancer-controller"
#      namespace = "kube-system"
#      labels = {
#      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
#      "app.kubernetes.io/component" = "controller"
#      }
#      annotations = {
#      "eks.amazonaws.com/role-arn"               = module.aws_load_balancer_controller_irsa_role.iam_role_arn
#      "eks.amazonaws.com/sts-regional-endpoints" = "true"
#      }
#  }
#  depends_on = [ module.aws_load_balancer_controller_irsa_role ]
#  }

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
#      name  = "serviceAccount.create"
#      value = "false"
#   }

#   set {
#      name  = "serviceAccount.name"
#      value = "aws-load-balancer-controller"
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
#   depends_on = [ kubernetes_service_account.service-account ]
# }
