resource "kubernetes_ingress_v1" "prowlarr_ingress" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["*.${var.local_domain}"]
      secret_name = var.local_tls_secret_name
    }

    rule {
      host = "${var.app_name}.${var.local_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.prowlarr.metadata.0.name

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
