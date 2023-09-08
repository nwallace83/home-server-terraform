resource "kubernetes_secret" "admin_service_account_secret" {
  metadata {
    name = "admin-service-account-secret"
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
  }
  secret {
    name = kubernetes_secret.admin_service_account_secret.metadata.0.name
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
    name = kubernetes_service_account.admin_service_account.metadata.0.name
  }
}
