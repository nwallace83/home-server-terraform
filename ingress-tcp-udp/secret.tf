resource "kubernetes_secret" "local_tls_secret" {
  metadata {
    name      = "local-tls-secret"
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64decode(var.tls_certificate)
    "tls.key" = base64decode(var.tls_key)
  }
}

#####################################################################################################################

output "local_tls_secret_name" {
  value = kubernetes_secret.local_tls_secret.metadata.0.name
}