resource "kubernetes_ingress_v1" "pihole_ingress" {
  metadata {
    name = "pihole-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"           = "true"
      "nginx.ingress.kubernetes.io/configuration-snippet"  = "if ($uri = /) {return 302 /admin;}"
      "nginx.ingress.kubernetes.io/use-regex"              = "true"
      "nginx.ingress.kubernetes.io/affinity"               = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name"    = "INGRESSCOOKIE"
      "nginx.ingress.kubernetes.io/session-cookie-path"    = "/"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "3600"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["${var.app_name}.${var.local_domain}"]
      secret_name = var.local_tls_secret_name
    }

    rule {
      host = "${var.app_name}.${var.local_domain}"
      http {
        path {
          path      = "/(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = "pihole-http-service"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      http {
        path {
          path      = "/(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = "pihole-http-service"

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