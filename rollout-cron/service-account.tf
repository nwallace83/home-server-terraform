
resource "kubernetes_service_account" "rolloutcron" {
  metadata {
    name      = "rolloutcron"
    namespace = var.namespace
  }

  secret {
    name = "rolloutcron-secret"
  }
}

####################################################################################################

resource "kubernetes_secret" "rolloutcron" {
  metadata {
    name      = "rolloutcron-secret"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.rolloutcron.metadata.0.name
    }
  }

  type = "kubernetes.io/service-account-token"
}

####################################################################################################

resource "kubernetes_role" "rolloutcron" {
  metadata {
    name      = "rolloutcron"
    namespace = var.namespace
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["patch", "get"]
  }
}

####################################################################################################

resource "kubernetes_role_binding" "rolloutcron" {
  metadata {
    name      = "rolloutcron"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.rolloutcron.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.rolloutcron.metadata.0.name
    namespace = var.namespace
  }
}
