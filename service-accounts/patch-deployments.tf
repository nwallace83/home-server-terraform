
resource "kubernetes_service_account" "patch_deployment_sa" {
  metadata {
    name      = "patch-deployment-sa"
    namespace = var.namespace
  }

  secret {
    name = "patch-deployment-sa-secret"
  }
}

####################################################################################################

resource "kubernetes_secret" "patch_deployment_sa_secret" {
  metadata {
    name      = "patch-deployment-sa-secret"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.patch_deployment_sa.metadata.0.name
    }
  }

  type = "kubernetes.io/service-account-token"
}

####################################################################################################

resource "kubernetes_role" "patch_deployment_role" {
  metadata {
    name      = "patch-deployment-role"
    namespace = var.namespace
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["patch", "get"]
  }
}

####################################################################################################

resource "kubernetes_role_binding" "patch_deployment_role_binding" {
  metadata {
    name      = "patch-deployment-role-binding"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.patch_deployment_role.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.patch_deployment_sa.metadata.0.name
    namespace = var.namespace
  }
}

####################################################################################################

output "patch_deployment_service_account" {
  value = kubernetes_service_account.patch_deployment_sa.metadata.0.name
}