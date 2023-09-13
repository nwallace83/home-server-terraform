resource "kubernetes_ingress_v1" "html_stub_ingress" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/use-regex"    = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["*.${var.local_domain}"]
      secret_name = var.local_tls_secret_name
    }

    rule {
      host = "*.${var.local_domain}"
      http {
        path {
          path      = "/(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.html_stub.metadata.0.name

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
