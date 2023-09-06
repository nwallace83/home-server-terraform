resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name = "pihole-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/affinity"               = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name"    = "route"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "3600"
    }
  }

  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = "pihole-http-service"
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          path      = "/"
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

#####################################################################################################################

resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name      = "nginx-ingress-tcp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53"    = "default/pihole-dns-service:53"
    "8112"  = "default/delugevpn-service:8112"
    "8081"  = "default/sickchill-service:8081"
    "8082"  = "default/radarr-service:8082"
    "8083"  = "default/prowlarr-service:8083"
    "8084"  = "default/handbrake-service:8084"
    "32400" = "default/plex-service:32400"
  }
}

resource "kubernetes_config_map" "udp_services" {
  metadata {
    name      = "nginx-ingress-udp-microk8s-conf"
    namespace = var.ingress_namespace
  }

  data = {
    "53" = "default/pihole-dns-service:53"
  }
}

#####################################################################################################################


# resource "kubernetes_service" "ingress_nginx_controller" {
#   metadata {
#     name      = "ingress-nginx-controller"
#     namespace = var.ingress_namespace

#     labels = {
#       "app.kubernetes.io/component" = "controller"
#       "app.kubernetes.io/instance"  = "ingress-nginx"
#       "app.kubernetes.io/name"      = "ingress-nginx"
#       "app.kubernetes.io/part-of"   = "ingress-nginx"
#       "app.kubernetes.io/version"   = "1.6.4"
#     }
#   }

#   spec {
#     type = "LoadBalancer"

#     port {
#       name        = "http"
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }

#     port {
#       name        = "https"
#       port        = 443
#       target_port = 443
#       protocol    = "TCP"
#     }

#     port {
#       name        = "dns-tcp"
#       port        = 53
#       target_port = 53
#       protocol    = "TCP"
#     }

#     port {
#       name        = "dns-udp"
#       port        = 53
#       target_port = 53
#       protocol    = "UDP"
#     }

#     port {
#       name        = "delugevpn-tcp"
#       port        = 8112
#       target_port = 8112
#       protocol    = "TCP"
#     }

#     port {
#       name        = "sickchill-tcp"
#       port        = 8081
#       target_port = 8081
#       protocol    = "TCP"
#     }

#     port {
#       name        = "radarr-tcp"
#       port        = 8082
#       target_port = 8082
#       protocol    = "TCP"
#     }

#     port {
#       name        = "prowlarr-tcp"
#       port        = 8083
#       target_port = 8083
#       protocol    = "TCP"
#     }

#     port {
#       name        = "handbrake-tcp"
#       port        = 8084
#       target_port = 8084
#       protocol    = "TCP"
#     }

#     port {
#       name        = "plex-tcp"
#       port        = 32400
#       target_port = 32400
#       protocol    = "TCP"
#     }

#     selector = {
#       "app.kubernetes.io/component" = "controller"
#       "app.kubernetes.io/instance"  = "ingress-nginx"
#       "app.kubernetes.io/name"      = "ingress-nginx"
#     }
#   }
# }


