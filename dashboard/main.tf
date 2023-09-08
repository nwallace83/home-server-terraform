resource "kubernetes_secret" "dashboard_certs" {
  metadata {
    name = "kubernetes-dashboard-certs"
    namespace = var.dashboard_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64decode(var.tls_certificate)
    "tls.key" = base64decode(var.tls_key)
  }
}