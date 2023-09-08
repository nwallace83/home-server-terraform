resource "kubernetes_secret" "admin_service_account_secret" {
  metadata {
    name = "admin-service-account-secret"
    namespace = var.dashboard_namespace
    annotations = {
      "kubernetes.io/service-account.name" = "admin"
    }
  }

  type = "kubernetes.io/service-account-token"
}

####################################################################################################

resource "kubernetes_service_account" "admin_service_account" {
  metadata {
    name = "admin"
    namespace = var.dashboard_namespace
  }
  secret {
    name = "admin-service-account-secret"
  }
}

####################################################################################################

resource "kubernetes_cluster_role_binding" "cluster_admin_role_binding" {
  metadata {
    name = "cluster-admin-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind = "ServiceAccount"
    namespace = var.dashboard_namespace
    name = kubernetes_service_account.admin_service_account.metadata.0.name
  }
}
